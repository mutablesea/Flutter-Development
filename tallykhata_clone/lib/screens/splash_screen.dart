import 'dart:async';

import 'package:flutter/material.dart';

import '../routes.dart';

/// Two-stage splash screen: displays the small icon first, transitions to the
/// full branded splash screen after 1.2s, and navigates to Login after 3.2s.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _full = false;
  Timer? _t1;
  Timer? _t2;

  @override
  void initState() {
    super.initState();
    _t1 = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _full = true);
    });
    _t2 = Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        Routes.login,
      ); // Replace route so back button doesn't return to splash
    });
  }

  @override
  void dispose() {
    _t1?.cancel();
    _t2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _full
            ? const _FullSplash(key: ValueKey('full'))
            : const _IconSplash(key: ValueKey('icon')),
      ),
    );
  }
}

/// First splash stage: centered TallyKhata icon only.
class _IconSplash extends StatelessWidget {
  const _IconSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/images/tallykhata_logo.png', width: 110),
    );
  }
}

/// Second splash stage: full TallyKhata logo with license and security badges.
class _FullSplash extends StatelessWidget {
  const _FullSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(flex: 5),
          Image.asset('assets/images/tallykhata_logo1.png', width: 220),
          const SizedBox(height: 20),
          Image.asset('assets/images/tallykhata_logo2.jpg', width: 170),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Image.asset(
              'assets/images/tallykhata_logo3.jpg',
              width: 125,
            ),
          ),
        ],
      ),
    );
  }
}
