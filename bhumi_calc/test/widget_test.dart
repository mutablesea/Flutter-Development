import 'package:bhumi_calc/main.dart';
import 'package:bhumi_calc/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'Splash -> Onboarding -> Dashboard, Drawer burger icon, and auth test', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    // Verify built-in accounts exist in LoginPage
    expect(LoginPage.builtInAccounts.length, 2);
    expect(LoginPage.builtInAccounts[0].username, 'mutant');
    expect(LoginPage.builtInAccounts[0].password, 'mutant1234');
    expect(LoginPage.builtInAccounts[1].username, 'neon');
    expect(LoginPage.builtInAccounts[1].password, 'neon1234');

    // 1. Build app -> SplashPage is displayed
    await tester.pumpWidget(const BhumiCalcApp());
    expect(find.text('Bhumi Calc'), findsOneWidget);

    // 2. Advance 2 seconds -> navigates to OnboardingPage
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.textContaining('Skip'), findsOneWidget);

    // 3. Tap Skip on OnboardingPage -> navigates to HomePage
    await tester.tap(find.textContaining('Skip'));
    await tester.pumpAndSettle();

    // 4. Verify unauthenticated user sees 0.00 Decimal (not 150 demo)
    expect(find.textContaining('0.00'), findsWidgets);

    // 5. Tap the burger menu icon -> Sidebar Drawer opens
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  });
}
