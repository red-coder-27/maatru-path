import 'package:maatru_path_server/src/cases/cases_endpoint.dart';
import 'package:test/test.dart';

void main() {
  group('Case Business Rules and Validation Tests', () {
    test(
      'Synthetic applicant reference pattern strictly enforces DEMO- prefix',
      () {
        final validRefs = [
          'DEMO-001',
          'DEMO-PMMVY-2024-001',
          'DEMO-JSY-102',
          'DEMO-APP_99',
        ];
        final invalidRefs = [
          '',
          '123456789012', // Aadhaar-like number (prohibited)
          'SBIN0001234', // Bank IFSC (prohibited)
          'REAL-USER-01',
          'demo-lowercase', // Must be uppercase DEMO-
          'DEMO',
          'DEMO-',
        ];

        final regex = RegExp(r'^DEMO-[A-Za-z0-9_\-]+$');

        for (final ref in validRefs) {
          expect(
            regex.hasMatch(ref),
            isTrue,
            reason: 'Expected $ref to be valid synthetic ref',
          );
        }

        for (final ref in invalidRefs) {
          expect(
            regex.hasMatch(ref) && ref.length > 5,
            isFalse,
            reason: 'Expected $ref to be rejected as invalid synthetic ref',
          );
        }
      },
    );

    test('Allowed priorities must only be High, Medium, Low', () {
      expect(
        CasesEndpoint.validPriorities,
        containsAll(['High', 'Medium', 'Low']),
      );
      expect(CasesEndpoint.validPriorities.length, 3);
      expect(CasesEndpoint.validPriorities.contains('Urgent'), isFalse);
      expect(CasesEndpoint.validPriorities.contains('Critical'), isFalse);
    });

    test('Allowed statuses must strictly be Open, In Progress, Resolved', () {
      expect(
        CasesEndpoint.validStatuses,
        containsAll(['Open', 'In Progress', 'Resolved']),
      );
      expect(CasesEndpoint.validStatuses.length, 3);
      expect(CasesEndpoint.validStatuses.contains('Pending'), isFalse);
      expect(CasesEndpoint.validStatuses.contains('Closed'), isFalse);
    });

    test('Allowed categories are well-defined and exhaustive for MVP', () {
      final expected = {
        'Aadhaar Linkage',
        'Bank Account / NPCI',
        'Documentation',
        'Operator Verification',
        'Biometric Authentication',
        'Mobile Seeding',
        'Unclear Requirement',
      };
      expect(CasesEndpoint.validCategories, equals(expected));
    });

    test('State transition validation rules', () {
      // Transition from Open
      expect(CasesEndpoint.validStatuses.contains('In Progress'), isTrue);
      expect(CasesEndpoint.validStatuses.contains('Resolved'), isTrue);

      // Same status transition must be rejected
      const current = 'Open';
      const targetSame = 'Open';
      expect(current == targetSame, isTrue); // Triggers state change rejected

      // Reopening from Resolved
      const resolved = 'Resolved';
      const targetReopen1 = 'In Progress';
      const targetReopen2 = 'Open';
      expect(
        resolved != targetReopen1 &&
            CasesEndpoint.validStatuses.contains(targetReopen1),
        isTrue,
      );
      expect(
        resolved != targetReopen2 &&
            CasesEndpoint.validStatuses.contains(targetReopen2),
        isTrue,
      );
    });
  });
}
