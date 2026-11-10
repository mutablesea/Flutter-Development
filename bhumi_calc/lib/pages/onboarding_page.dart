import 'package:flutter/material.dart';

import '../main.dart';
import 'home_page.dart';

class OnboardingSlide {
  final String badgeBn;
  final String badgeEn;
  final String titleBn;
  final String titleEn;
  final String descBn;
  final String descEn;
  final IconData icon;
  final Color accentColor;
  final List<String> highlightsBn;
  final List<String> highlightsEn;

  const OnboardingSlide({
    required this.badgeBn,
    required this.badgeEn,
    required this.titleBn,
    required this.titleEn,
    required this.descBn,
    required this.descEn,
    required this.icon,
    required this.accentColor,
    required this.highlightsBn,
    required this.highlightsEn,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingSlide> _slides = [
    OnboardingSlide(
      badgeBn: 'ডিজিটাল খতিয়ান সংরক্ষণ',
      badgeEn: 'DIGITAL KHATIAN ARCHIVE',
      titleBn: 'সব খতিয়ান ও দলিল এক জায়গায়',
      titleEn: 'Organize All Khatian & Land Records',
      descBn:
          'CS, RS, SA, BRS, BDS এবং নামজারি (Kharij) খতিয়ানের তথ্য ও মূল কাগজের স্ক্যান কপি নিরাপদে অফলাইনে সংরক্ষণ করুন।',
      descEn:
          'Save CS, RS, SA, BRS, BDS, and Kharij records with scanned document photos securely offline.',
      icon: Icons.folder_special_rounded,
      accentColor: kPrimaryDeepIndigo,
      highlightsBn: [
        'খতিয়ান ও দাগ নম্বর অনুযায়ী দ্রুত সার্চ',
        'ক্যামেরা বা গ্যালারি থেকে মূল দলিলের ছবি সংযুক্তি',
        'এক ক্লিকে পিডিএফ রিপোর্ট ও ব্যাকআপ সুবিধা',
      ],
      highlightsEn: [
        'Instant search by Khatian & Dag number',
        'Attach original document scans from camera or gallery',
        'One-tap PDF summary report & JSON backup',
      ],
    ),
    OnboardingSlide(
      badgeBn: 'স্মার্ট ক্যালকুলেটর ও সূত্রাবলী',
      badgeEn: 'SMART CALCULATOR & FORMULAS',
      titleBn: 'বাংলাদেশের আদর্শ এককে নির্ভুল ভূমি পরিমাপ',
      titleEn: 'Accurate Bangladesh Land Unit Conversion',
      descBn:
          'শতাংশ, কাঠা, বিঘা, একর, কানি, গণ্ডা, কড়া, ক্রান্তি, তিল, বর্গফুট, বর্গহাত, বর্গগজ, বর্গলিংক ও হেক্টরের পূর্ণাঙ্গ হিসাব।',
      descEn:
          'Convert across Decimal, Katha, Bigha, Acre, Kani, Gonda, Kora, Kranti, Til, Sq. Ft, Bargo Hat, Square Link, and Hectare.',
      icon: Icons.calculate_rounded,
      accentColor: kSecondarySunsetOrange,
      highlightsBn: [
        'একক কনভার্টার এবং দৈর্ঘ্য × প্রস্থ প্লট ক্যালকুলেটর',
        'সরকারি আদর্শ এককের সম্পূর্ণ সূত্রাবলী তালিকা',
        '৮ হাত নল ও প্রচলিত উভয় কানি-গণ্ডার হিসাব',
      ],
      highlightsEn: [
        'Instant unit converter & Length × Width plot calculator',
        'Complete reference of official Bangladesh land formulas',
        'Supports both 8-Hat Nol and standard Kani-Gonda scales',
      ],
    ),
    OnboardingSlide(
      badgeBn: 'সম্পত্তির ওভারভিউ ও চার্ট',
      badgeEn: 'PROPERTY OVERVIEW & CHARTS',
      titleBn: 'এক নজরে আপনার মোট সম্পত্তির বিশ্লেষণ',
      titleEn: 'Visualize Your Complete Land Portfolio',
      descBn:
          'আপনার মোট জমি কত বিঘা, কত কাঠা বা কত একর এবং কোন খতিয়ানে কতটুকু আছে তা পাই-চার্ট ও স্মার্ট কার্ডে দেখুন।',
      descEn:
          'See your total land broken down into Bigha, Katha, and Acre with an interactive Khatian distribution Pie Chart.',
      icon: Icons.pie_chart_rounded,
      accentColor: kPrimaryDeepIndigo,
      highlightsBn: [
        'মোট জমির স্বয়ংক্রিয় যোগফল ও স্মার্ট কনভার্সন',
        'CS, BRS, RS ও নামজারি অনুযায়ী পাই-চার্ট ভিউ',
        'বাংলা ও ইংরেজি ভাষা পরিবর্তনের সুবিধা',
      ],
      highlightsEn: [
        'Automatic total land calculation & smart conversion',
        'Interactive Pie Chart by CS, BRS, RS & Kharij records',
        'Live Bangla & English language switching',
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastSlide = _currentIndex == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr(
                      'ধাপ ${_currentIndex + 1} / ${_slides.length}',
                      'Step ${_currentIndex + 1} of ${_slides.length}',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      tr('এড়িয়ে যান (Skip)', 'Skip'),
                      style: const TextStyle(
                        color: kPrimaryDeepIndigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  final highlights = languageNotifier.value == 'bn'
                      ? slide.highlightsBn
                      : slide.highlightsEn;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slide.accentColor.withValues(alpha: 0.12),
                            border: Border.all(
                              color: slide.accentColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: slide.accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: slide.accentColor.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                slide.icon,
                                size: 52,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: slide.accentColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tr(slide.badgeBn, slide.badgeEn),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: slide.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          tr(slide.titleBn, slide.titleEn),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tr(slide.descBn, slide.descEn),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.45,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: theme.dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: highlights.map((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: slide.accentColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isSelected = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kSecondarySunsetOrange
                              : theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (_currentIndex > 0) ...[
                        OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(tr('পিছনে', 'Back')),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _nextSlide,
                          style: FilledButton.styleFrom(
                            backgroundColor: kSecondarySunsetOrange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: Icon(
                            isLastSlide
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: Text(
                            isLastSlide
                                ? tr('শুরু করুন', 'Get Started')
                                : tr('পরবর্তী', 'Next'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
