import 'dart:async';

import 'package:flutter/material.dart';

import '../routes.dart';

/// Splash screen that automatically navigates to the login screen after 2 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        Routes.login,
      ); // Replace route so back button doesn't return to splash
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(flex: 3),
          Image.asset('assets/images/tallykhata_logo1.png', width: 220),
          const Spacer(flex: 1),
          Image.asset('assets/images/tallykhata_logo2.jpg', width: 170),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Image.asset(
              'assets/images/tallykhata_logo3.jpg',
              width: 120,
            ),
          ),
        ],
      ),
    ),
  );
}
