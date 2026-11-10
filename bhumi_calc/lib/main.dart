import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const BhumiCalcApp());
}

class BhumiCalcApp extends StatelessWidget {
  const BhumiCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhumi Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
