import 'package:maatru_path_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Cases endpoint', (sessionBuilder, endpoints) {
    test(
      'when creating valid case then persists record and initial action log',
      () async {
        final newCase = CaseRecord(
          applicantReference: 'DEMO-PMMVY-001',
          schemeName: 'PMMVY',
          blockerCategory: 'Aadhaar Linkage',
          blockerDescription:
              'Name spelling mismatch on maternal portal records.',
          priority: 'High',
          status: 'Open',
        );

        final created = await endpoints.cases.createCase(
          sessionBuilder,
          newCase,
        );

        expect(created.id, isNotNull);
        expect(created.applicantReference, 'DEMO-PMMVY-001');
        expect(created.status, 'Open');
        expect(created.createdAt, isNotNull);

        // Verify history has initial log
        final history = await endpoints.cases.getCaseHistory(
          sessionBuilder,
          created.id!,
        );
        expect(history.length, 1);
        expect(history.first.actionType, 'created');
        expect(history.first.newStatus, 'Open');
      },
    );

    test(
      'when creating case with invalid non-synthetic reference then throws exception',
      () async {
        final invalidCase = CaseRecord(
          applicantReference: 'REAL-AADHAAR-1234',
          schemeName: 'PMMVY',
          blockerCategory: 'Aadhaar Linkage',
          blockerDescription: 'Invalid synthetic ref test',
          priority: 'High',
          status: 'Open',
        );

        expect(
          () => endpoints.cases.createCase(sessionBuilder, invalidCase),
          throwsA(isA<CaseOperationException>()),
        );
      },
    );

    test(
      'when updating status from Open to In Progress and then Resolved, audit logs are appended',
      () async {
        final c = await endpoints.cases.createCase(
          sessionBuilder,
          CaseRecord(
            applicantReference: 'DEMO-002',
            schemeName: 'JSY',
            blockerCategory: 'Bank Account / NPCI',
            blockerDescription: 'DBT mandate not active at branch.',
            priority: 'Medium',
            status: 'Open',
          ),
        );

        // Transition to In Progress
        final inProgress = await endpoints.cases.updateBlockerStatus(
          sessionBuilder,
          c.id!,
          'In Progress',
          'Beneficiary visited branch with NPCI mandate form.',
        );
        expect(inProgress.status, 'In Progress');

        // Transition to Resolved
        final resolved = await endpoints.cases.updateBlockerStatus(
          sessionBuilder,
          c.id!,
          'Resolved',
          'Bank acknowledged DBT activation.',
        );
        expect(resolved.status, 'Resolved');

        // Verify history shows chronological sequence
        final logs = await endpoints.cases.getCaseHistory(
          sessionBuilder,
          c.id!,
        );
        expect(logs.length, 3);
        expect(logs[0].actionType, 'created');
        expect(logs[1].actionType, 'status_change');
        expect(logs[1].newStatus, 'In Progress');
        expect(logs[2].actionType, 'status_change');
        expect(logs[2].newStatus, 'Resolved');
      },
    );

    test(
      'when reopening a Resolved case, status is updated and deliberate reopen is logged',
      () async {
        final c = await endpoints.cases.createCase(
          sessionBuilder,
          CaseRecord(
            applicantReference: 'DEMO-003',
            schemeName: 'PMMVY',
            blockerCategory: 'Documentation',
            blockerDescription: 'MCP card verification needed.',
            priority: 'Low',
            status: 'Open',
          ),
        );

        await endpoints.cases.updateBlockerStatus(
          sessionBuilder,
          c.id!,
          'Resolved',
          'Initial resolve',
        );

        // Deliberate reopen
        final reopened = await endpoints.cases.updateBlockerStatus(
          sessionBuilder,
          c.id!,
          'In Progress',
          'Supervisor requested secondary verification of immunisation stamp.',
        );

        expect(reopened.status, 'In Progress');

        final logs = await endpoints.cases.getCaseHistory(
          sessionBuilder,
          c.id!,
        );
        expect(logs.last.actionType, 'reopened');
      },
    );

    test(
      'when requesting invalid state transition to same status, operation throws',
      () async {
        final c = await endpoints.cases.createCase(
          sessionBuilder,
          CaseRecord(
            applicantReference: 'DEMO-004',
            schemeName: 'PMMVY',
            blockerCategory: 'Operator Verification',
            blockerDescription: 'Pending L1 queue review.',
            priority: 'High',
            status: 'Open',
          ),
        );

        expect(
          () => endpoints.cases.updateBlockerStatus(
            sessionBuilder,
            c.id!,
            'Open',
            null,
          ),
          throwsA(isA<CaseOperationException>()),
        );
      },
    );

    test(
      'when adding follow-up note, note is appended and case timestamp refreshed',
      () async {
        final c = await endpoints.cases.createCase(
          sessionBuilder,
          CaseRecord(
            applicantReference: 'DEMO-005',
            schemeName: 'PMMVY',
            blockerCategory: 'Mobile Seeding',
            blockerDescription: 'Beneficiary changed mobile number.',
            priority: 'Medium',
            status: 'Open',
          ),
        );

        final noteLog = await endpoints.cases.addFollowUpNote(
          sessionBuilder,
          c.id!,
          'Met with ASHA worker; scheduled CSC visit for Thursday.',
        );

        expect(noteLog.actionType, 'note_added');
        expect(noteLog.note, contains('scheduled CSC visit'));

        final history = await endpoints.cases.getCaseHistory(
          sessionBuilder,
          c.id!,
        );
        expect(history.length, 2);
        expect(history.last.actionType, 'note_added');
      },
    );

    test(
      'when fetching recommended actions, returns rule-based guidance distinguishing verified status',
      () async {
        final aadhaarRecs = await endpoints.cases.getRecommendedActions(
          sessionBuilder,
          'Aadhaar Linkage',
        );
        expect(aadhaarRecs, isNotEmpty);
        expect(aadhaarRecs.first.requiresOfficialVerification, isTrue);
        expect(aadhaarRecs.first.officialReferenceUrl, isNotNull);

        final opRecs = await endpoints.cases.getRecommendedActions(
          sessionBuilder,
          'Operator Verification',
        );
        expect(opRecs, isNotEmpty);
        expect(opRecs.first.requiresOfficialVerification, isFalse);
        expect(opRecs.first.officialReferenceUrl, isNull);
      },
    );
  });
}
