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

  testWidgets('TallyApp launches SplashScreen and navigates to LoginScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TallyApp());

    // Verify SplashScreen renders with the TallyKhata images
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(3));

    // Advance 2 seconds to trigger navigation to LoginScreen
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('রেজিস্ট্রেশন/লগইন করুন'), findsOneWidget);
  });
}
