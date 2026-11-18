import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// SS 0,1 : Splash. 2 sec por login e jabe.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
        () => Navigator.pushReplacementNamed(context, Routes.login)); // back dile splash e ferot ashbe na
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          const Spacer(flex: 3),
          Container(
            width: 110, height: 140,
            decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.menu_book, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 12),
          const Text('টালিখাতা', style: TextStyle(fontSize: 32, color: kRed, fontWeight: FontWeight.bold)),
          const Spacer(flex: 3),
          const Padding(padding: EdgeInsets.only(bottom: 40), child: Text('নিরাপদ ও সহজ')),
        ]),
      );
}

/// SS 2,3,4,5 : Onboarding carousel (PageView) + phone number field + পরবর্তী button
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pageCtrl = PageController();
  int _page = 0;
  String _phone = '';
  Timer? _timer;
  final _slides = const [
    ('QR কোড-এ পেমেন্ট নিন বিকাশ, রকেট সহ সকল ব্যাংক অ্যাপ থেকে।', Color(0xFFFBE0E0)),
    ('ট্রান্সফার করুন নগদ, রকেট বা ব্যাংক একাউন্টে।', Color(0xFFFCE9D9)),
    ('টালিখাতায় লেনদেন ১০০% নিরাপদ।', Color(0xFFDDF5DD)),
  ];

  @override
  void initState() {
    super.initState();
    // auto slide
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageCtrl.hasClients) return;
      _pageCtrl.animateToPage((_page + 1) % _slides.length,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid = _phone.length == 11; // 01XXXXXXXXX
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(children: [
          // upore carousel
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageCtrl, itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => Container(
                color: _slides[i].$2, padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomCenter,
                child: Text(_slides[i].$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < _slides.length; i++)
              Container(
                margin: const EdgeInsets.all(3), width: 6, height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: i == _page ? Colors.black : Colors.grey.shade300),
              ),
          ]),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('রেজিস্ট্রেশন/লগইন করুন', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                AppField('মোবাইল নম্বর', icon: Icons.phone_outlined, keyboard: TextInputType.phone,
                    onChanged: (v) => setState(() => _phone = v)),
                const SizedBox(height: 10),
                const Text('রেজিস্ট্রেশন করতে আপনার NID দিয়ে নিবন্ধিত মোবাইল নম্বর ব্যবহার করুন।',
                    style: TextStyle(color: Colors.grey)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              PrimaryButton('পরবর্তী',
                  onPressed: valid ? () => Navigator.pushReplacementNamed(context, Routes.businessName) : null),
              const SizedBox(height: 8),
              const Text('পরবর্তীতে যাওয়ার নির্দেশের মাধ্যমে আপনি টালিখাতার শর্তাবলীতে সম্মতি প্রদান করছেন।',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// SS 6 : ব্যবসা প্রতিষ্ঠানের নাম দিন
class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({super.key});
  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  String _name = '';
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              const Text('ব্যবসা প্রতিষ্ঠানের নাম দিন', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              AppField('ব্যবসা প্রতিষ্ঠানের নাম', onChanged: (v) => setState(() => _name = v.trim())),
              const Spacer(),
              PrimaryButton('নিশ্চিত',
                  onPressed: _name.isEmpty ? null : () => Navigator.pushReplacementNamed(context, Routes.welcome)),
            ]),
          ),
        ),
      );
}

/// SS 7 : অভিনন্দন! (auto jabe QR intro te)
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, Routes.qrIntro));
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.workspace_premium, size: 80, color: Color(0xFFE0A800)),
            SizedBox(height: 8),
            Text('টালিখাতায় অভিনন্দন!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('আপনি টালিখাতা গোল্ড (৩০ দিন ট্রায়াল) পেয়েছেন।'),
          ]),
        ),
      );
}

/// SS 8,9 : টালিপে QR intro. fromHome=true hole (grid theke "QR কোড") back button thake.
class QrIntroScreen extends StatelessWidget {
  final bool fromHome;
  const QrIntroScreen({super.key, this.fromHome = false});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: fromHome ? backBar(context, 'QR কোড') : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              const Text('টালিপে QR — ব্যবসায়ীদের জন্য\nসেরা বাংলা QR',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFBEFEF), borderRadius: BorderRadius.circular(12)),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('টালিপে QR একাউন্ট আবেদন', style: TextStyle(fontSize: 17)),
                  Text('২টি সহজ ধাপে টালিপে QR একাউন্ট-এর আবেদন করুন', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 12),
                  ListTile(leading: CircleAvatar(child: Icon(Icons.person_outline)), title: Text('NID ও সেলফি')),
                  ListTile(leading: CircleAvatar(child: Icon(Icons.store_outlined)), title: Text('ব্যবসার ছবি ও তথ্য')),
                ]),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => fromHome
                      ? Navigator.pop(context)
                      : Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false), // back e login e ferot jabe na
                  child: const Text('টালিখাতা ব্যবহার করবো', style: TextStyle(color: kRed, fontSize: 16)),
                ),
              ),
              PrimaryButton('টালিপে QR একাউন্ট খুলুন', onPressed: () {}),
            ]),
          ),
        ),
      );
}
