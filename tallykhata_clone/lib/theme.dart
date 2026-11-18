import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kRed = Color(0xFFB91C1C);
const kRedLight = Color(0xFFF1C6C6);
const kGoldTop = Color(0xFFE9D39B);
const kGoldBottom = Color(0xFFF7EFD9);
const kGreen = Color(0xFF1B8A2F);

ThemeData appTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kRed, primary: kRed),
    scaffoldBackgroundColor: Colors.white,
  );
  return base.copyWith(
    textTheme: GoogleFonts.hindSiliguriTextTheme(base.textTheme), // Bangla font
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kRed, width: 1.5),
      ),
    ),
  );
}
