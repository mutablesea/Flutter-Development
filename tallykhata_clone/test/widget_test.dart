import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tallykhata_clone/main.dart';
import 'package:tallykhata_clone/screens/splash_screen.dart';
import 'package:tallykhata_clone/screens/auth_screens.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('TallyApp launches two-stage SplashScreen and navigates to LoginScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TallyApp());

    // Stage 1: Icon splash renders with 1 image (tallykhata_logo.png)
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Advance 1.2s -> transitions to Stage 2 (full splash with 3 images)
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(Image), findsNWidgets(3));

    // Advance past 3.2s total -> navigates to LoginScreen
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('রেজিস্ট্রেশন/লগইন করুন'), findsOneWidget);
  });
}
