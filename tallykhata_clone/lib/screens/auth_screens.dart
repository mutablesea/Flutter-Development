import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Onboarding carousel (PageView) with phone number login/registration input.
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
    (
      'QR কোড-এ পেমেন্ট নিন বিকাশ, রকেট সহ সকল ব্যাংক অ্যাপ থেকে।',
      'assets/images/tallykhata_logo5.jpg',
      Color(0xFFFDF0ED),
    ),
    (
      'ট্রান্সফার করুন নগদ, রকেট বা ব্যাংক একাউন্টে।',
      'assets/images/tallykhata_logo6.jpg',
      Color(0xFFFEF3E8),
    ),
    (
      'টালিখাতায় লেনদেন ১০০% নিরাপদ।',
      'assets/images/tallykhata_logo7.jpg',
      Color(0xFFEDFAEE),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-advance carousel slides every 3 seconds
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
          // Top onboarding carousel
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageCtrl, itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => Container(
                color: _slides[i].$3,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        _slides[i].$2,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                      child: Text(
                        _slides[i].$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
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
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    children: [
                      TextSpan(text: 'রেজিস্ট্রেশন করতে আপনার '),
                      TextSpan(
                        text: 'NID দিয়ে নিবন্ধিত মোবাইল নম্বর',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(text: ' ব্যবহার করুন।'),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              PrimaryButton('পরবর্তী',
                  onPressed: valid
                      ? () {
                          userPhoneNotifier.value = _phone;
                          Navigator.pushReplacementNamed(context, Routes.businessName);
                        }
                      : null),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    TextSpan(
                      text:
                          'পরবর্তীতে যাওয়ার নির্দেশের মাধ্যমে আপনি টালিখাতার ',
                    ),
                    TextSpan(
                      text: 'শর্তাবলীতে',
                      style: TextStyle(
                        color: kRed,
                        decoration: TextDecoration.underline,
                        decorationColor: kRed,
                      ),
                    ),
                    TextSpan(text: ' সম্মতি প্রদান করছেন।'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Screen for entering the business name during registration.
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
                  onPressed: _name.isEmpty
                      ? null
                      : () {
                          businessNameNotifier.value = _name;
                          Navigator.pushReplacementNamed(context, Routes.welcome);
                        }),
            ]),
          ),
        ),
      );
}

/// Welcome congratulation screen that automatically navigates to the QR introduction screen.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.qrIntro);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

/// TallyPay QR introduction screen. Shows a back button when opened from the home screen ([fromHome] = true).
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
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'টালিপে QR একাউন্ট আবেদন',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '২টি সহজ ধাপে টালিপে QR একাউন্ট-এর আবেদন করুন',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        child: Icon(Icons.person_outline),
                      ),
                      title: Text('NID ও সেলফি'),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        child: Icon(Icons.storefront_outlined),
                      ),
                      title: Text('ব্যবসার ছবি ও তথ্য'),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'NID এবং ব্যবসার ছবি থাকলে ২ মিনিটে QR পাবেন।',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => fromHome
                      ? Navigator.pop(context)
                      : Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                          (r) => false,
                        ), // Clear navigation stack so back button doesn't return to login
                  child: const Text(
                    'টালিখাতা ব্যবহার করবো',
                    style: TextStyle(
                      color: kRed,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              PrimaryButton('টালিপে QR একাউন্ট খুলুন', onPressed: () {}),
              const SizedBox(height: 10),
              const Center(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                    children: [
                      TextSpan(
                        text:
                            'টালিপে QR একাউন্ট খোলার মাধ্যমে আপনি টালিপে QR\nএকাউন্ট-এর ',
                      ),
                      TextSpan(
                        text: 'শর্তাবলীতে',
                        style: TextStyle(
                          color: kRed,
                          decoration: TextDecoration.underline,
                          decorationColor: kRed,
                        ),
                      ),
                      TextSpan(text: ' সম্মতি প্রদান করছেন।'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        ),
      );
}
