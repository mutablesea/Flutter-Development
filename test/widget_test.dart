import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_flow/main.dart';

void main() {
  testWidgets('TaskFlowApp smoke test renders tasks and app bar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskFlowApp());

    // Verify app title is displayed.
    expect(find.text('Task Flow'), findsOneWidget);

    // Verify initial task items are present.
    expect(find.text('Learn Dart fundamentals'), findsOneWidget);
    expect(find.text('Build multi-page UI in Flutter'), findsOneWidget);

    // Verify floating action button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
