import 'package:flutter/material.dart';

import 'pages/splash_page.dart';

// Global notifier controlling theme mode across the app (System, Light, Dark)
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

// Global notifier controlling app language ('bn' for Bangla, 'en' for English)
final ValueNotifier<String> languageNotifier = ValueNotifier<String>('bn');

// Helper function to return Bangla or English text based on current language mode
String tr(String bnText, String enText) {
  return languageNotifier.value == 'bn' ? bnText : enText;
}

// Official Brand Colors
const Color kPrimaryDeepIndigo = Color(0xFF283593); // #283593 Deep Indigo
const Color kSecondarySunsetOrange = Color(0xFFFF7043); // #FF7043 Sunset Orange
const Color kBackgroundLightAsh = Color(0xFFECEFF1); // #ECEFF1 Light Ash

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BhumiCalcApp());
}

class BhumiCalcApp extends StatelessWidget {
  const BhumiCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: kPrimaryDeepIndigo,
      primary: kPrimaryDeepIndigo,
      secondary: kSecondarySunsetOrange,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: kPrimaryDeepIndigo,
      primary: const Color(0xFF5C6BC0),
      secondary: kSecondarySunsetOrange,
      brightness: Brightness.dark,
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: languageNotifier,
          builder: (context, currentLang, _) {
            return MaterialApp(
              title: 'Bhumi Calc',
              debugShowCheckedModeBanner: false,
              themeMode: currentMode,
              theme: ThemeData(
                colorScheme: lightScheme,
                scaffoldBackgroundColor: kBackgroundLightAsh,
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: kPrimaryDeepIndigo,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  actionsIconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                floatingActionButtonTheme:
                    const FloatingActionButtonThemeData(
                  backgroundColor: kSecondarySunsetOrange,
                  foregroundColor: Colors.white,
                ),
                cardTheme: const CardThemeData(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: darkScheme,
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: kPrimaryDeepIndigo,
                  foregroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
                  actionsIconTheme: IconThemeData(color: Colors.white),
                ),
                floatingActionButtonTheme:
                    const FloatingActionButtonThemeData(
                  backgroundColor: kSecondarySunsetOrange,
                  foregroundColor: Colors.white,
                ),
                cardTheme: const CardThemeData(
                  surfaceTintColor: Colors.transparent,
                ),
              ),
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
}
