import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';
import 'add_khatian_page.dart';
import 'backup_restore_page.dart';
import 'calculator_page.dart';
import 'khatian_details_page.dart';
import 'land_formulas_page.dart';
import 'login_page.dart';
import 'onboarding_page.dart';
import 'pdf_export_page.dart';
import 'profile_page.dart';
import 'property_overview_page.dart';
import 'search_filter_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // Track the selected bottom navigation bar tab
  String _activeUserName = '';
  String _activeUsername = '';
  String _activeUserEmail = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadActiveUserSession();
  }

  Future<void> _loadActiveUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('auth_is_logged_in') ?? false;
    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      if (loggedIn) {
        _activeUserName = prefs.getString('auth_full_name') ?? '';
        _activeUsername = prefs.getString('auth_username') ?? '';
        _activeUserEmail = prefs.getString('auth_email') ?? '';
      } else {
        _activeUserName = '';
        _activeUsername = '';
        _activeUserEmail = '';
      }
    });
  }

  void _openSidebarDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.help_outline_rounded, color: kPrimaryDeepIndigo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tr('সাহায্য ও নির্দেশিকা (Help & Guide)', 'Help & User Guide'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr(
                  '১. সাইন ইন ও প্রোফাইল:\nসাইন ইন পেজে গিয়ে আপনার ইউজারনেম ও পাসওয়ার্ড দিয়ে লগইন করলে আপনার ব্যক্তিগত খতিয়ান ও প্রোফাইল দেখতে পাবেন।\n\n'
                  '২. খতিয়ান সংরক্ষণ:\nনিচের কমলা রঙের "নতুন খতিয়ান" বাটনে ট্যাপ করে বিভাগ, জেলা, উপজেলা/সার্কেল, মালিকানার ধরন (নিজস্ব বা উত্তরাধিকার), খতিয়ান নং ও দাগ নং সেভ করুন।\n\n'
                  '৩. ভূমি উন্নয়ন কর (খাজনা) চেকবক্স:\nড্যাশবোর্ড বা খতিয়ান বিস্তারিত পেজে প্রতিটি খতিয়ানের পাশে চেকবক্সে টিক দিয়ে খাজনা পরিশোধ হয়েছে কিনা চিহ্নিত করে রাখুন।\n\n'
                  '৪. ক্যালকুলেটর ও সূত্রাবলী:\nবাংলাদেশের সরকারি আদর্শ এককে জমি রূপান্তর করুন এবং সব সূত্র খুঁজুন।',
                  '1. Sign In & Profile:\nSign in with your username and password on the Sign In page to access your profile and saved records.\n\n'
                  '2. Add Khatian Records:\nTap the orange "Add Khatian" button to save Division, District, Upazila/Circle, Ownership Type (Own or Inheritance), Khatian No, and Dag No.\n\n'
                  '3. Land Tax (Khajna) Checkbox:\nUse the checkbox on each Khatian card in the Dashboard or Details page to track whether land tax has been paid.\n\n'
                  '4. Smart Calculator & Formulas:\nConvert across 27 Bangladesh land units and browse all official formulas.',
                ),
                style: const TextStyle(fontSize: 13.5, height: 1.45),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: kSecondarySunsetOrange,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr('বুঝেছি', 'Got It')),
          ),
        ],
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryDeepIndigo.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.landscape_rounded,
                color: kPrimaryDeepIndigo,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bhumi Calc',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Text(
          tr(
            'Bhumi Calc হলো বাংলাদেশের আদর্শ এককে জমি পরিমাপ, খতিয়ান সংরক্ষণ এবং সম্পত্তির পূর্ণাঙ্গ হিসাব বিশ্লেষণের একটি স্মার্ট অ্যাপ্লিকেশন।\n\n'
            '• অফলাইন SQLite ডাটাবেস স্টোরেজ\n'
            '• ২৭টি ভূমি পরিমাপ একক ও প্লট ক্যালকুলেটর\n'
            '• সরকারি ভূমি পরিমাপের সম্পূর্ণ সূত্রাবলী\n'
            '• পাই-চার্ট ও খাজনা পরিশোধ ট্র্যাকার',
            'Bhumi Calc is a smart Bangladesh land measurement calculator, Khatian archive, and property portfolio analyzer built with Flutter & SQLite.\n\n'
            '• Offline SQLite database storage\n'
            '• 27 land units & Length × Width plot calculator\n'
            '• Complete official Bangladesh land formulas\n'
            '• Interactive Pie Chart & Land Tax tracker',
          ),
          style: const TextStyle(fontSize: 13.5, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr('বন্ধ করুন', 'Close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, _) {
        final theme = Theme.of(context);

        final List<Widget> pages = [
          KhatianDashboardView(
            key: ValueKey('dashboard_${_isLoggedIn}_$_activeUsername'),
            activeUserName: _activeUserName,
            activeUsername: _activeUsername,
            isLoggedIn: _isLoggedIn,
            onOpenDrawer: _openSidebarDrawer,
            onSwitchTab: (idx) => setState(() => _currentIndex = idx),
            onUserChanged: _loadActiveUserSession,
          ),
          PropertyOverviewPage(
            key: ValueKey('overview_${_isLoggedIn}_$_activeUsername'),
            onOpenDrawer: _openSidebarDrawer,
          ),
          CalculatorPage(
            onOpenDrawer: _openSidebarDrawer,
          ),
          LandFormulasPage(
            onOpenDrawer: _openSidebarDrawer,
          ),
        ];

        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildAppDrawer(context, theme, currentLang),
          body: pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            indicatorColor: kSecondarySunsetOrange.withValues(alpha: 0.22),
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(
                  Icons.dashboard_rounded,
                  color: kPrimaryDeepIndigo,
                ),
                label: tr('ড্যাশবোর্ড', 'Dashboard'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.pie_chart_outline_rounded),
                selectedIcon: const Icon(
                  Icons.pie_chart_rounded,
                  color: kPrimaryDeepIndigo,
                ),
                label: tr('সম্পত্তি হিসাব', 'Overview'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.calculate_outlined),
                selectedIcon: const Icon(
                  Icons.calculate_rounded,
                  color: kPrimaryDeepIndigo,
                ),
                label: tr('ক্যালকুলেটর', 'Calculator'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                selectedIcon: const Icon(
                  Icons.menu_book_rounded,
                  color: kPrimaryDeepIndigo,
                ),
                label: tr('সূত্রাবলী', 'Formulas'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppDrawer(
    BuildContext context,
    ThemeData theme,
    String currentLang,
  ) {
    return Drawer(
      child: ValueListenableBuilder<String>(
        valueListenable: languageNotifier,
        builder: (context, langVal, _) {
          return Column(
            children: [
              // Deep Indigo Sidebar Header with Account Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                  bottom: 18,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryDeepIndigo,
                      Color(0xFF1A237E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: kSecondarySunsetOrange,
                          child: Text(
                            _isLoggedIn && _activeUserName.isNotEmpty
                                ? _activeUserName[0].toUpperCase()
                                : 'B',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isLoggedIn
                                    ? _activeUserName
                                    : tr('গেস্ট ইউজার (Guest)', 'Guest User'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isLoggedIn
                                    ? '@$_activeUsername • $_activeUserEmail'
                                    : tr(
                                        'অ্যাকাউন্টে ঢুকতে সাইন ইন করুন',
                                        'Sign in to access your account',
                                      ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: kSecondarySunsetOrange,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              if (_isLoggedIn) {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ProfilePage(),
                                  ),
                                );
                              } else {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              }
                              await _loadActiveUserSession();
                            },
                            icon: Icon(
                              _isLoggedIn
                                  ? Icons.person_outline_rounded
                                  : Icons.login_rounded,
                              size: 16,
                            ),
                            label: Text(
                              _isLoggedIn
                                  ? tr('প্রোফাইল দেখুন', 'View Profile')
                                  : tr('সাইন ইন করুন (Sign In)', 'Sign In'),
                              style: const TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sidebar Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_rounded,
                        color: kPrimaryDeepIndigo,
                      ),
                      title: Text(
                        tr('অ্যাকাউন্ট ও প্রোফাইল', 'Account & Profile'),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                        await _loadActiveUserSession();
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.dashboard_rounded,
                        color: kPrimaryDeepIndigo,
                      ),
                      title: Text(
                        tr('ড্যাশবোর্ড ও আমার খতিয়ান', 'Dashboard & Khatians'),
                      ),
                      selected: _currentIndex == 0,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => _currentIndex = 0);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.pie_chart_rounded,
                        color: kPrimaryDeepIndigo,
                      ),
                      title: Text(
                        tr(
                          'সম্পত্তি ওভারভিউ ও চার্ট',
                          'Property Overview & Chart',
                        ),
                      ),
                      selected: _currentIndex == 1,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => _currentIndex = 1);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.calculate_rounded,
                        color: kSecondarySunsetOrange,
                      ),
                      title: Text(
                        tr(
                          'স্মার্ট ভূমি ক্যালকুলেটর',
                          'Smart Land Calculator',
                        ),
                      ),
                      selected: _currentIndex == 2,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => _currentIndex = 2);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.menu_book_rounded,
                        color: kPrimaryDeepIndigo,
                      ),
                      title: Text(
                        tr(
                          'ভূমি পরিমাপের আদর্শ সূত্রাবলী',
                          'Official Land Formulas',
                        ),
                      ),
                      selected: _currentIndex == 3,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => _currentIndex = 3);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search_rounded),
                      title: Text(
                        tr('খতিয়ান অনুসন্ধান ও ফিল্টার', 'Search & Filter'),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SearchFilterPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf_outlined),
                      title: Text(
                        tr('পিডিএফ রিপোর্ট ও সামারি', 'PDF Report & Export'),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PdfExportPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.cloud_sync_outlined),
                      title: Text(tr('ব্যাকআপ ও রিস্টোর', 'Backup & Restore')),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BackupRestorePage(),
                          ),
                        );
                      },
                    ),

                    const Divider(),

                    // Instant Language Switcher inside Sidebar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.translate_rounded,
                                size: 20,
                                color: kSecondarySunsetOrange,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                tr(
                                  'ভাষা পরিবর্তন (Language)',
                                  'Language Mode',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'bn',
                                  label: Text('বাংলা'),
                                ),
                                ButtonSegment(
                                  value: 'en',
                                  label: Text('English'),
                                ),
                              ],
                              selected: {langVal},
                              onSelectionChanged: (sel) {
                                languageNotifier.value = sel.first;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    // Settings
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: Text(tr('সেটিংস (Settings)', 'Settings')),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(
                              onDataChanged: _loadActiveUserSession,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                    ),

                    // Help & Guide
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded),
                      title: Text(tr('সাহায্য ও গাইড (Help)', 'Help & Support')),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showHelpDialog(context);
                      },
                    ),

                    // Onboarding Tour
                    ListTile(
                      leading: const Icon(Icons.auto_stories_outlined),
                      title: Text(tr('অ্যাপ পরিচিতি (Onboarding)', 'App Tour')),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingPage(),
                          ),
                        );
                      },
                    ),

                    // About Bhumi Calc App
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: Text(
                        tr('Bhumi Calc সম্পর্কে (About)', 'About Bhumi Calc'),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showAboutAppDialog(context);
                      },
                    ),

                    const Divider(),

                    if (_isLoggedIn)
                      ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          tr('লগআউট করুন (Log Out)', 'Log Out'),
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await LoginPage.clearSessionFromPrefs();
                          await _loadActiveUserSession();
                        },
                      )
                    else
                      ListTile(
                        leading: const Icon(
                          Icons.login_rounded,
                          color: kSecondarySunsetOrange,
                        ),
                        title: Text(
                          tr('সাইন ইন করুন (Sign In)', 'Sign In to Account'),
                          style: const TextStyle(
                            color: kSecondarySunsetOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                          await _loadActiveUserSession();
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class KhatianDashboardView extends StatefulWidget {
  final String activeUserName;
  final String activeUsername;
  final bool isLoggedIn;
  final VoidCallback onOpenDrawer;
  final ValueChanged<int> onSwitchTab;
  final VoidCallback onUserChanged;

  const KhatianDashboardView({
    super.key,
    required this.activeUserName,
    required this.activeUsername,
    required this.isLoggedIn,
    required this.onOpenDrawer,
    required this.onSwitchTab,
    required this.onUserChanged,
  });

  @override
  State<KhatianDashboardView> createState() => _KhatianDashboardViewState();
}

class _KhatianDashboardViewState extends State<KhatianDashboardView> {
  List<KhatianRecord> _khatianList = [];
  bool _isLoading = true;
  String _selectedTypeFilter = 'All';

  static const List<String> _filterTypes = [
    'All',
    'CS',
    'RS',
    'SA',
    'BRS',
    'BDS',
    'Kharij',
  ];

  @override
  void initState() {
    super.initState();
    _loadKhatians();
  }

  Future<void> _loadKhatians() async {
    final data = await DatabaseHelper().getAllKhatians();
    if (!mounted) return;
    setState(() {
      _khatianList = data;
      _isLoading = false;
    });
  }

  Future<void> _toggleTaxStatus(KhatianRecord rec, bool paid) async {
    final updated = rec.copyWith(isTaxPaid: paid);
    await DatabaseHelper().updateKhatian(updated);
    await _loadKhatians();
  }

  List<KhatianRecord> get _filteredRecords {
    if (_selectedTypeFilter == 'All') return _khatianList;
    return _khatianList
        .where((r) => r.khatianType == _selectedTypeFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, _, _) {
        final theme = Theme.of(context);

        // Total Land Area calculation across all records
        double totalDecimals = 0;
        for (int i = 0; i < _khatianList.length; i++) {
          totalDecimals += _khatianList[i].totalLandArea;
        }
        final int fullBighas = (totalDecimals / 33.0).floor();
        final double remDecimals = totalDecimals - (fullBighas * 33.0);
        final double totalAcres = totalDecimals / 100.0;
        final double totalKathas = totalDecimals / 1.65;
        final int taxPaidCount = _khatianList.where((r) => r.isTaxPaid).length;

        final displayedRecords = _filteredRecords;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: tr('সাইডবার মেনু', 'Open Menu'),
              onPressed: widget.onOpenDrawer,
            ),
            title: Text(tr('আমার খতিয়ান (Bhumi Calc)', 'Bhumi Calc Dashboard')),
            actions: [
              // Quick Language Toggle Button in AppBar
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () {
                  languageNotifier.value =
                      languageNotifier.value == 'bn' ? 'en' : 'bn';
                },
                icon: const Icon(
                  Icons.translate_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  languageNotifier.value == 'bn' ? 'EN' : 'বাংলা',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: tr('অনুসন্ধান', 'Search'),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchFilterPage()),
                  );
                  _loadKhatians();
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_pin_circle_rounded),
                tooltip: tr('প্রোফাইল', 'Profile'),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(records: _khatianList),
                    ),
                  );
                  widget.onUserChanged();
                  _loadKhatians();
                },
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadKhatians,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
                    children: [
                      // 1. User Welcome & Sign-In Status Banner
                      Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    kPrimaryDeepIndigo.withValues(alpha: 0.12),
                                child: Icon(
                                  widget.isLoggedIn
                                      ? Icons.verified_user_rounded
                                      : Icons.person_outline_rounded,
                                  color: kPrimaryDeepIndigo,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.isLoggedIn
                                          ? tr(
                                              'স্বাগতম, ${widget.activeUserName}',
                                              'Welcome, ${widget.activeUserName}',
                                            )
                                          : tr(
                                              'স্বাগতম! (লগইন করা নেই)',
                                              'Welcome! (Not Signed In)',
                                            ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.isLoggedIn
                                          ? '@${widget.activeUsername} • ${tr('সক্রিয় প্রোফাইল', 'Active Profile')}'
                                          : tr(
                                              'আপনার অ্যাকাউন্টে প্রবেশ করতে সাইন ইন করুন',
                                              'Sign in to access your saved account',
                                            ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!widget.isLoggedIn)
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: kSecondarySunsetOrange,
                                    foregroundColor: Colors.white,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );
                                    widget.onUserChanged();
                                    _loadKhatians();
                                  },
                                  child: Text(tr('সাইন ইন', 'Sign In')),
                                )
                              else
                                FilledButton.tonalIcon(
                                  onPressed: () => widget.onSwitchTab(1),
                                  icon: const Icon(
                                    Icons.pie_chart_rounded,
                                    size: 16,
                                  ),
                                  label: Text(tr('চার্ট', 'Overview')),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 2. Dashboard Total Property Summary Card (Deep Indigo Header)
                      InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => widget.onSwitchTab(1),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                kPrimaryDeepIndigo,
                                Color(0xFF1A237E),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    kPrimaryDeepIndigo.withValues(alpha: 0.28),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tr(
                                      'মোট সংরক্ষিত সম্পত্তির পরিমাণ',
                                      'Total Saved Land Portfolio',
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kSecondarySunsetOrange,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      '${_khatianList.length} ${tr('খতিয়ান', 'Records')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${totalDecimals.toStringAsFixed(2)} ${tr('শতাংশ (Decimal)', 'Decimal')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildHeroChip(
                                    '$fullBighas ${tr('বিঘা', 'Bigha')} ${remDecimals.toStringAsFixed(1)} ${tr('শতাংশ', 'Dec')}',
                                  ),
                                  _buildHeroChip(
                                    '${totalAcres.toStringAsFixed(2)} ${tr('একর', 'Acre')}',
                                  ),
                                  _buildHeroChip(
                                    '${totalKathas.toStringAsFixed(1)} ${tr('কাঠা', 'Katha')}',
                                  ),
                                  _buildHeroChip(
                                    tr(
                                      'খাজনা পরিশোধ: $taxPaidCount/${_khatianList.length}',
                                      'Tax Paid: $taxPaidCount/${_khatianList.length}',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. Quick Action Tools Grid
                      Row(
                        children: [
                          _buildQuickActionCard(
                            context,
                            icon: Icons.pie_chart_rounded,
                            label: tr('সম্পত্তি হিসাব', 'Overview'),
                            color: kPrimaryDeepIndigo,
                            onTap: () => widget.onSwitchTab(1),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionCard(
                            context,
                            icon: Icons.calculate_rounded,
                            label: tr('ক্যালকুলেটর', 'Calculator'),
                            color: kSecondarySunsetOrange,
                            onTap: () => widget.onSwitchTab(2),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionCard(
                            context,
                            icon: Icons.menu_book_rounded,
                            label: tr('সব সূত্রাবলী', 'Formulas'),
                            color: Colors.teal.shade700,
                            onTap: () => widget.onSwitchTab(3),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionCard(
                            context,
                            icon: Icons.picture_as_pdf_rounded,
                            label: tr('পিডিএফ রিপোর্ট', 'PDF Report'),
                            color: Colors.purple,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PdfExportPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // 4. Filter Chips by Khatian Type
                      Text(
                        tr(
                          'খতিয়ান তালিকা ও খাজনা স্ট্যাটাস (Khatian Records)',
                          'Khatian Records & Tax Status',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filterTypes.map((type) {
                            final isSelected = _selectedTypeFilter == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  type == 'All'
                                      ? tr(
                                          'সব (${_khatianList.length})',
                                          'All (${_khatianList.length})',
                                        )
                                      : type,
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => _selectedTypeFilter = type);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 5. Khatian Records List with Tax Paid Checkbox
                      if (displayedRecords.isEmpty)
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.folder_open_rounded,
                                  size: 48,
                                  color: kPrimaryDeepIndigo,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  tr(
                                    'কোনো খতিয়ান পাওয়া যায়নি। নতুন খতিয়ান যোগ করুন।',
                                    'No Khatian records found. Add a new Khatian!',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...displayedRecords.map((record) {
                          final locationText = [
                            if (record.upazila.isNotEmpty) record.upazila,
                            if (record.district.isNotEmpty) record.district,
                            record.mouza,
                          ].join(', ');

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        KhatianDetailsPage(record: record),
                                  ),
                                );
                                _loadKhatians();
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  12,
                                  14,
                                  8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: kPrimaryDeepIndigo
                                              .withValues(alpha: 0.12),
                                          child: Text(
                                            record.khatianType,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryDeepIndigo,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${tr('দাগ নং', 'Dag')}: ${record.dagNo} | ${tr('খতিয়ান', 'Khatian')}: ${record.khatianNo}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.5,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                locationText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kSecondarySunsetOrange
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${record.totalLandArea} ${tr('শতক', 'Dec')}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: kSecondarySunsetOrange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider(height: 1),
                                    // Bottom Row: Ownership Badge + Tax Paid Checkbox
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              record.ownershipType.contains(
                                                    'উত্তরাধিকার',
                                                  )
                                                  ? Icons
                                                      .family_restroom_rounded
                                                  : Icons.person_pin_rounded,
                                              size: 15,
                                              color: kPrimaryDeepIndigo,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              record.ownershipType,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: kPrimaryDeepIndigo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () => _toggleTaxStatus(
                                            record,
                                            !record.isTaxPaid,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                activeColor:
                                                    Colors.green.shade700,
                                                value: record.isTaxPaid,
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    _toggleTaxStatus(
                                                      record,
                                                      val,
                                                    );
                                                  }
                                                },
                                              ),
                                              Text(
                                                record.isTaxPaid
                                                    ? tr(
                                                        'খাজনা পরিশোধিত',
                                                        'Tax Paid',
                                                      )
                                                    : tr(
                                                        'খাজনা বাকি',
                                                        'Tax Unpaid',
                                                      ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: record.isTaxPaid
                                                      ? Colors.green.shade700
                                                      : kSecondarySunsetOrange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kSecondarySunsetOrange,
            foregroundColor: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddKhatianPage()),
              );
              _loadKhatians(); // Refresh the list after adding new data
            },
            icon: const Icon(Icons.add),
            label: Text(
              tr('নতুন খতিয়ান', 'Add Khatian'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '⚬ $text',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
