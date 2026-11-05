import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_flow/main.dart';

void main() {
  testWidgets('TaskFlowApp smoke test renders tasks, priorities, and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    // Verify app title and action buttons
    expect(find.text('Task Flow'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Verify overview banner
    expect(find.text('Today\'s Overview'), findsOneWidget);

    // Verify initial task items & priority badges are visible
    expect(find.text('Learn Dart fundamentals'), findsOneWidget);
    expect(find.text('High Priority'), findsWidgets);
    expect(find.text('Medium Priority'), findsWidgets);

    // Verify floating action button
    expect(find.text('New Task'), findsOneWidget);
  });

  testWidgets('Settings page renders theme options: System, Light, and Dark',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    // Tap the settings icon
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings page elements
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    // Verify appearance section
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Task Preferences'), findsOneWidget);
  });

  testWidgets('Search page allows searching and filtering tasks',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());

    // Tap search icon
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify Search page elements
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Status: '), findsOneWidget);
    expect(find.text('Priority: '), findsOneWidget);

    // Enter a search query
    await tester.enterText(find.byType(TextField), 'Dart');
    await tester.pumpAndSettle();

    // Verify filtered search results
    expect(find.text('Learn Dart fundamentals'), findsOneWidget);
    expect(find.text('Build multi-page UI in Flutter'), findsNothing);
  });
}
