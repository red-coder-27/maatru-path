import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maatru_path_client/maatru_path_client.dart';
import 'package:maatru_path_flutter/client.dart';
import 'package:maatru_path_flutter/screens/case_dashboard_screen.dart';
import 'package:maatru_path_flutter/screens/create_case_screen.dart';
import 'package:maatru_path_flutter/theme/app_theme.dart';
import 'package:maatru_path_flutter/widgets/priority_badge.dart';
import 'package:maatru_path_flutter/widgets/privacy_banner.dart';
import 'package:maatru_path_flutter/widgets/status_badge.dart';
import 'package:maatru_path_flutter/widgets/timeline_item.dart';

void main() {
  setUpAll(() {
    try {
      client = Client('http://localhost:8080/');
    } catch (_) {}
  });

  group('PrivacyBanner Component Tests', () {
    testWidgets('renders synthetic demo privacy notice and scope disclaimer', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrivacyBanner(),
          ),
        ),
      );

      expect(find.byType(PrivacyBanner), findsOneWidget);
      expect(
        find.textContaining(
          'DEMO NOTICE: MaatruPath is a community worker blocker companion',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Real Aadhaar, bank credentials, or beneficiary PII are never collected',
        ),
        findsOneWidget,
      );
    });
  });

  group('StatusBadge & PriorityBadge Component Tests', () {
    testWidgets('renders badges with proper text values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBadge(status: 'Open'),
                StatusBadge(status: 'In Progress'),
                StatusBadge(status: 'Resolved'),
                PriorityBadge(priority: 'High'),
                PriorityBadge(priority: 'Medium'),
                PriorityBadge(priority: 'Low'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Open'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
      expect(find.text('High Priority'), findsOneWidget);
      expect(find.text('Medium Priority'), findsOneWidget);
      expect(find.text('Low Priority'), findsOneWidget);
    });
  });

  group('TimelineItem Component Tests', () {
    testWidgets('renders chronological action log node and note text', (
      tester,
    ) async {
      final log = CaseActionLog(
        id: 1,
        caseId: 42,
        actionType: 'created',
        previousStatus: null,
        newStatus: 'Open',
        note: 'Case initiated with blocker category: Aadhaar Linkage',
        createdAt: DateTime(2026, 10, 13, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme(),
          home: Scaffold(
            body: TimelineItem(
              log: log,
              isFirst: true,
              isLast: true,
            ),
          ),
        ),
      );

      expect(find.text('Case Initiated'), findsOneWidget);
      expect(
        find.textContaining('Case initiated with blocker category'),
        findsOneWidget,
      );
      expect(find.textContaining('2026-10-13'), findsOneWidget);
    });
  });

  group('CreateCaseScreen Validation & Demo Template Tests', () {
    testWidgets(
      'validates required fields and enforces DEMO- synthetic reference',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CreateCaseScreen(),
          ),
        );

        // Verify screen elements
        expect(find.text('Register Blocker Case'), findsOneWidget);
        final saveButton = find.text('Save Case to Serverpod');
        expect(saveButton, findsOneWidget);

        // Tap submit with empty fields
        await tester.ensureVisible(saveButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Check validation error
        expect(
          find.text('Applicant reference cannot be blank'),
          findsOneWidget,
        );

        // Enter an invalid non-synthetic reference
        final refField = find.byType(TextFormField).first;
        await tester.enterText(refField, '123456789012'); // Real PII attempt
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        expect(
          find.text('Must start with DEMO- (e.g., DEMO-001)'),
          findsOneWidget,
        );

        // Click on a demo template chip
        final templateChip = find.text('DEMO: Aadhaar Mismatch');
        expect(templateChip, findsOneWidget);
        await tester.tap(templateChip);
        await tester.pumpAndSettle();

        // Verify fields prefilled
        expect(find.text('DEMO-PMMVY-001'), findsOneWidget);
        expect(find.text('PMMVY'), findsOneWidget);
        expect(
          find.textContaining('Demographic name spelling mismatch'),
          findsOneWidget,
        );
      },
    );
  });

  group('CaseDashboardScreen Layout & Constraint Tests', () {
    testWidgets(
      'renders cleanly on desktop without unbounded width layout assertion',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CaseDashboardScreen(),
          ),
        );

        await tester.pump();

        // Verify branding and actions
        expect(find.text('MaatruPath'), findsOneWidget);
        expect(find.text('New Case'), findsOneWidget);

        // Verify that the dropdowns and textfield in filter bar are rendered without error
        expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));
        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      },
    );

    testWidgets(
      'renders cleanly on compact mobile screen without layout error',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CaseDashboardScreen(),
          ),
        );

        await tester.pump();

        expect(find.text('MaatruPath'), findsOneWidget);
        expect(find.text('New'), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));
      },
    );

    testWidgets(
      'tapping New Case navigates to Register Blocker Case screen',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CaseDashboardScreen(),
          ),
        );

        await tester.pump();

        final newCaseButton = find.text('New Case');
        expect(newCaseButton, findsOneWidget);
        await tester.tap(newCaseButton);
        await tester.pumpAndSettle();

        expect(find.byType(CreateCaseScreen), findsOneWidget);
        expect(find.text('Register Blocker Case'), findsOneWidget);
      },
    );

    testWidgets(
      'filter dropdowns can be selected without layout errors',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme(),
            home: const CaseDashboardScreen(),
          ),
        );

        await tester.pump();

        // Tap the status dropdown
        final statusDropdown = find.text('All Statuses');
        expect(statusDropdown, findsOneWidget);
        await tester.tap(statusDropdown);
        await tester.pumpAndSettle();

        // Select 'Open'
        final openOption = find.text('Open').hitTestable();
        expect(openOption, findsOneWidget);
        await tester.tap(openOption);
        await tester.pumpAndSettle();

        // Tap the category dropdown
        final categoryDropdown = find.text('All Categories');
        expect(categoryDropdown, findsOneWidget);
        await tester.tap(categoryDropdown);
        await tester.pumpAndSettle();

        // Select 'Aadhaar Linkage'
        final aadhaarOption = find.text('Aadhaar Linkage').hitTestable();
        expect(aadhaarOption, findsOneWidget);
        await tester.tap(aadhaarOption);
        await tester.pumpAndSettle();

        // Ensure everything settled cleanly
        expect(tester.takeException(), isNull);
      },
    );
  });
}
