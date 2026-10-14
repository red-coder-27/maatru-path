import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint managing welfare blocker cases, deterministic remediation guidance,
/// status transitions, and audit action logging.
/// Access on the client via `client.cases`.
class CasesEndpoint extends Endpoint {
  static const Set<String> validPriorities = {'High', 'Medium', 'Low'};

  static const Set<String> validStatuses = {'Open', 'In Progress', 'Resolved'};

  static const Set<String> validCategories = {
    'Aadhaar Linkage',
    'Bank Account / NPCI',
    'Documentation',
    'Operator Verification',
    'Biometric Authentication',
    'Mobile Seeding',
    'Unclear Requirement',
  };

  static final RegExp _syntheticRefRegex = RegExp(r'^DEMO-[A-Za-z0-9_\-]+$');

  /// Creates a new persistent case with validation and an initial action log entry.
  Future<CaseRecord> createCase(Session session, CaseRecord caseRecord) async {
    final ref = caseRecord.applicantReference.trim();
    if (ref.isEmpty || !_syntheticRefRegex.hasMatch(ref)) {
      throw CaseOperationException(
        message:
            'Applicant reference "$ref" is invalid. It must start with "DEMO-" '
            'and use only letters, numbers, and hyphens (e.g., DEMO-001, DEMO-PMMVY-01). '
            'Real beneficiary identifiers (Aadhaar, bank numbers) are strictly prohibited.',
      );
    }

    final scheme = caseRecord.schemeName.trim();
    if (scheme.isEmpty || scheme.length > 100) {
      throw CaseOperationException(
        message:
            'Scheme name cannot be blank and must not exceed 100 characters.',
      );
    }

    final category = caseRecord.blockerCategory.trim();
    if (!validCategories.contains(category)) {
      throw CaseOperationException(
        message:
            'Invalid blocker category "$category". Permitted categories: ${validCategories.join(', ')}.',
      );
    }

    final description = caseRecord.blockerDescription.trim();
    if (description.length < 5 || description.length > 1000) {
      throw CaseOperationException(
        message:
            'Blocker description must be between 5 and 1000 characters. Blank descriptions are rejected.',
      );
    }

    final priority = caseRecord.priority.trim();
    if (!validPriorities.contains(priority)) {
      throw CaseOperationException(
        message:
            'Invalid priority "$priority". Allowed priorities: ${validPriorities.join(', ')}.',
      );
    }

    // Atomic transaction ensuring CaseRecord and its initial CaseActionLog are both persisted.
    return await session.db.transaction<CaseRecord>((tx) async {
      final now = DateTime.now();
      final toInsert = caseRecord.copyWith(
        id: null,
        applicantReference: ref,
        schemeName: scheme,
        blockerCategory: category,
        blockerDescription: description,
        priority: priority,
        status: 'Open',
        createdAt: now,
        updatedAt: now,
      );

      final createdCase = await CaseRecord.db.insertRow(
        session,
        toInsert,
        transaction: tx,
      );

      final initialLog = CaseActionLog(
        caseId: createdCase.id!,
        actionType: 'created',
        previousStatus: null,
        newStatus: 'Open',
        note:
            'Case registered with initial blocker category: "$category". Priority set to $priority.',
        createdAt: now,
      );

      await CaseActionLog.db.insertRow(
        session,
        initialLog,
        transaction: tx,
      );

      return createdCase;
    });
  }

  /// Lists all persisted cases, sorted by most recently updated/created.
  Future<List<CaseRecord>> listCases(Session session) async {
    final records = await CaseRecord.db.find(
      session,
      orderByList: (t) => [t.updatedAt.desc(), t.createdAt.desc()],
    );

    // Ensure fallback sorting in memory if updatedAt was null on legacy records
    records.sort((a, b) {
      final timeA = a.updatedAt ?? a.createdAt;
      final timeB = b.updatedAt ?? b.createdAt;
      return timeB.compareTo(timeA);
    });

    return records;
  }

  /// Retrieves a specific case by its primary key ID. Returns null if not found.
  Future<CaseRecord?> getCase(Session session, int id) async {
    return await CaseRecord.db.findById(session, id);
  }

  /// Updates the blocker status with transition validation and atomic action logging.
  Future<CaseRecord> updateBlockerStatus(
    Session session,
    int caseId,
    String newStatus,
    String? reason,
  ) async {
    final targetStatus = newStatus.trim();
    if (!validStatuses.contains(targetStatus)) {
      throw CaseOperationException(
        message:
            'Invalid status "$targetStatus". Permitted statuses: ${validStatuses.join(', ')}.',
      );
    }

    final existingCase = await CaseRecord.db.findById(session, caseId);
    if (existingCase == null) {
      throw CaseOperationException(
        message: 'Case with ID $caseId not found.',
      );
    }

    final currentStatus = existingCase.status;
    if (currentStatus == targetStatus) {
      throw CaseOperationException(
        message:
            'Case #$caseId is already in status "$targetStatus". State transition rejected.',
      );
    }

    // Documented transition rules:
    // Open -> In Progress, Resolved
    // In Progress -> Open, Resolved
    // Resolved -> In Progress, Open (Deliberate reopening of resolved case)
    final isReopening =
        currentStatus == 'Resolved' &&
        (targetStatus == 'In Progress' || targetStatus == 'Open');

    final noteText = (reason != null && reason.trim().isNotEmpty)
        ? reason.trim()
        : (isReopening
              ? 'Case deliberately reopened from Resolved to $targetStatus.'
              : (targetStatus == 'Resolved'
                    ? 'Blocker marked as Resolved after follow-up verification.'
                    : 'Status transitioned from $currentStatus to $targetStatus.'));

    return await session.db.transaction<CaseRecord>((tx) async {
      final now = DateTime.now();
      final updatedCase = existingCase.copyWith(
        status: targetStatus,
        updatedAt: now,
      );

      final saved = await CaseRecord.db.updateRow(
        session,
        updatedCase,
        transaction: tx,
      );

      final log = CaseActionLog(
        caseId: caseId,
        actionType: isReopening ? 'reopened' : 'status_change',
        previousStatus: currentStatus,
        newStatus: targetStatus,
        note: noteText,
        createdAt: now,
      );

      await CaseActionLog.db.insertRow(
        session,
        log,
        transaction: tx,
      );

      return saved;
    });
  }

  /// Retrieves chronological action log entries for a given case.
  Future<List<CaseActionLog>> getCaseHistory(
    Session session,
    int caseId,
  ) async {
    final existingCase = await CaseRecord.db.findById(session, caseId);
    if (existingCase == null) {
      throw CaseOperationException(
        message: 'Case with ID $caseId not found.',
      );
    }

    final logs = await CaseActionLog.db.find(
      session,
      where: (t) => t.caseId.equals(caseId),
      orderBy: (t) => t.createdAt,
    );

    logs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return logs;
  }

  /// Appends a new follow-up note to the case history and refreshes the case update timestamp.
  Future<CaseActionLog> addFollowUpNote(
    Session session,
    int caseId,
    String note,
  ) async {
    final trimmedNote = note.trim();
    if (trimmedNote.length < 3) {
      throw CaseOperationException(
        message:
            'Follow-up note cannot be blank (minimum 3 characters required).',
      );
    }
    if (trimmedNote.length > 1000) {
      throw CaseOperationException(
        message: 'Follow-up note cannot exceed 1000 characters.',
      );
    }

    final existingCase = await CaseRecord.db.findById(session, caseId);
    if (existingCase == null) {
      throw CaseOperationException(
        message: 'Case with ID $caseId not found.',
      );
    }

    return await session.db.transaction<CaseActionLog>((tx) async {
      final now = DateTime.now();
      final updatedCase = existingCase.copyWith(
        updatedAt: now,
      );

      await CaseRecord.db.updateRow(
        session,
        updatedCase,
        transaction: tx,
      );

      final actionLog = CaseActionLog(
        caseId: caseId,
        actionType: 'note_added',
        previousStatus: existingCase.status,
        newStatus: existingCase.status,
        note: trimmedNote,
        createdAt: now,
      );

      return await CaseActionLog.db.insertRow(
        session,
        actionLog,
        transaction: tx,
      );
    });
  }

  /// Deterministic, category-specific recommendations for supported blocker categories.
  /// Rule-based engine strictly distinguishing verified guidance from items needing official confirmation.
  Future<List<RecommendedAction>> getRecommendedActions(
    Session session,
    String category,
  ) async {
    final cat = category.trim();

    switch (cat) {
      case 'Aadhaar Linkage':
        return [
          RecommendedAction(
            category: 'Aadhaar Linkage',
            explanation:
                'Demographic mismatch (name spelling, gender, or date of birth) between welfare portal records and Aadhaar database.',
            prioritizedNextAction:
                'Advise applicant to visit an authorized UIDAI Aadhaar Seva Kendra or Post Office with supporting identity proof (voter ID or birth certificate).',
            practicalFollowUp:
                'Follow up in 7-10 business days. Record the demographic update request reference number (URN) without storing the 12-digit Aadhaar number.',
            requiresOfficialVerification: true,
            officialReferenceUrl: 'https://myaadhaar.uidai.gov.in/',
          ),
          RecommendedAction(
            category: 'Aadhaar Linkage',
            explanation:
                'Aadhaar status may be active in UIDAI but unlinked in the state social welfare beneficiary database.',
            prioritizedNextAction:
                'Confirm with the Anganwadi / ASHA worker whether the local offline register reflects the updated demographic certificate.',
            practicalFollowUp:
                'Check if the portal shows green validation tick after the state batch sync.',
            requiresOfficialVerification: true,
            officialReferenceUrl: null,
          ),
        ];

      case 'Bank Account / NPCI':
        return [
          RecommendedAction(
            category: 'Bank Account / NPCI',
            explanation:
                'Direct Benefit Transfer (DBT) credit failed because the bank account is not mapped to the NPCI Aadhaar payment bridge or IFSC changed during bank merger.',
            prioritizedNextAction:
                'Direct beneficiary to submit an NPCI Aadhaar Seeding / Mandate form in-person at their bank branch; do not ask for or collect bank account credentials.',
            practicalFollowUp:
                'Check back with the beneficiary after 5 working days to confirm whether the bank stamped the DBT mandate acknowledgement.',
            requiresOfficialVerification: true,
            officialReferenceUrl: 'https://www.npci.org.in/',
          ),
          RecommendedAction(
            category: 'Bank Account / NPCI',
            explanation:
                'Account might be dormant or frozen due to lack of recent minimum transactions.',
            prioritizedNextAction:
                'Ask applicant to make a nominal deposit or balance enquiry at their home branch to ensure the account is active.',
            practicalFollowUp:
                'Confirm account active status before requesting portal re-validation.',
            requiresOfficialVerification: false,
            officialReferenceUrl: null,
          ),
        ];

      case 'Documentation':
        return [
          RecommendedAction(
            category: 'Documentation',
            explanation:
                'Mandatory supporting documentation (e.g., Mother & Child Protection MCP card, institutional birth record, or category certificate) is missing or unverified.',
            prioritizedNextAction:
                'Coordinate with the local ASHA worker or Anganwadi Center (AWC) to review and cross-verify the Mother and Child Protection (MCP) card record.',
            practicalFollowUp:
                'Confirm whether the medical officer has signed off on the ANC (Antenatal Care) checkup and immunization schedule stamps.',
            requiresOfficialVerification: true,
            officialReferenceUrl: 'https://pmmvy.wcd.gov.in/',
          ),
          RecommendedAction(
            category: 'Documentation',
            explanation:
                'Scanned document upload failed portal clarity check or file size limit.',
            prioritizedNextAction:
                'Request the CSC operator to re-scan original documents under 200KB PDF format without cropping dates or seal signatures.',
            practicalFollowUp:
                'Verify with the operator that the upload progress bar completed successfully.',
            requiresOfficialVerification: false,
            officialReferenceUrl: null,
          ),
        ];

      case 'Operator Verification':
        return [
          RecommendedAction(
            category: 'Operator Verification',
            explanation:
                'Application is submitted but remains pending approval in the Block Development Officer (BDO) or Child Development Project Officer (CDPO) review queue.',
            prioritizedNextAction:
                'Present the case during the weekly block-level grievance redressal day or coordinate with the Lady Supervisor at the CDPO office.',
            practicalFollowUp:
                'Record the date of the review hearing and track whether the verification stage advances from L1 to L2.',
            requiresOfficialVerification: false,
            officialReferenceUrl: null,
          ),
        ];

      case 'Biometric Authentication':
        return [
          RecommendedAction(
            category: 'Biometric Authentication',
            explanation:
                'Repeated fingerprint or iris scan failure at the citizen service center (CSC) preventing biometric authentication.',
            prioritizedNextAction:
                'Request the CSC operator to attempt facial authentication or Iris-based alternative authentication, or request manual exception logging if biometrics continue to fail.',
            practicalFollowUp:
                'Follow up after the exception handling memo is issued by the authorized supervisor.',
            requiresOfficialVerification: true,
            officialReferenceUrl: 'https://uidai.gov.in/',
          ),
        ];

      case 'Mobile Seeding':
        return [
          RecommendedAction(
            category: 'Mobile Seeding',
            explanation:
                'Mobile number linked with the application is inactive, changed, or not receiving one-time passwords (OTP) from the scheme portal.',
            prioritizedNextAction:
                'Assist the applicant to visit a designated Post Office or CSC to update their active mobile number on the Aadhaar linkage.',
            practicalFollowUp:
                'Verify SMS delivery with a test alert once the operator confirms database sync (typically 48-72 hours).',
            requiresOfficialVerification: true,
            officialReferenceUrl: 'https://myaadhaar.uidai.gov.in/',
          ),
        ];

      case 'Unclear Requirement':
      default:
        return [
          RecommendedAction(
            category: cat.isEmpty ? 'Unclear Requirement' : cat,
            explanation:
                'The rejection reason or pendency note is ambiguous or unverified in standard guidelines. Unofficial assumptions must not be made.',
            prioritizedNextAction:
                'Escalate to the CDPO / Block Helpdesk with the synthetic application reference to request written clarification on the exact objection.',
            practicalFollowUp:
                'Do not guess the requirement. Record notes only after authorized staff provide specific missing document requirements.',
            requiresOfficialVerification: false,
            officialReferenceUrl: null,
          ),
        ];
    }
  }
}
