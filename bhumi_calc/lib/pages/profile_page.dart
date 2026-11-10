import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../main.dart';
import '../models/khatian_record.dart';
import 'login_page.dart';
import 'signup_page.dart';

class ProfilePage extends StatefulWidget {
  final List<KhatianRecord>? records;

  const ProfilePage({super.key, this.records});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  String _name = '';
  String _username = '';
  String _email = '';
  String _role = 'Bhumi Calc Member';
  int _selectedAvatarIndex = 0;
  List<KhatianRecord> _khatianList = [];

  static const List<IconData> _avatarIcons = [
    Icons.person_rounded,
    Icons.landscape_rounded,
    Icons.account_balance_rounded,
    Icons.verified_user_rounded,
    Icons.auto_awesome_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileAndData();
  }

  Future<void> _loadProfileAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('auth_is_logged_in') ?? false;
    final dbRecords = await DatabaseHelper().getAllKhatians();

    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      _khatianList = dbRecords;
      if (loggedIn) {
        _name = prefs.getString('auth_full_name') ?? '';
        _username = prefs.getString('auth_username') ?? '';
        _email = prefs.getString('auth_email') ?? '';
        _role = prefs.getString('auth_role') ?? 'Bhumi Calc Member';
        _selectedAvatarIndex = prefs.getInt('auth_avatar_index') ?? 0;
      } else {
        _name = '';
        _username = '';
        _email = '';
      }
      _isLoading = false;
    });
  }

  Future<void> _saveProfileChangesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_full_name', _name);
    await prefs.setString('auth_username', _username);
    await prefs.setString('auth_email', _email);
    await prefs.setString('auth_role', _role);
    await prefs.setInt('auth_avatar_index', _selectedAvatarIndex);
  }

  Future<void> _handleLogout() async {
    await LoginPage.clearSessionFromPrefs();
    if (!mounted) return;
    await _loadProfileAndData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('সফলভাবে লগআউট হয়েছে।', 'Logged out successfully.')),
      ),
    );
  }

  Future<void> _openLoginPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    await _loadProfileAndData();
  }

  Future<void> _openSignupPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupPage()),
    );
    await _loadProfileAndData();
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final usernameCtrl = TextEditingController(text: _username);
    final emailCtrl = TextEditingController(text: _email);
    final roleCtrl = TextEditingController(text: _role);
    int tempAvatar = _selectedAvatarIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr('প্রোফাইল সম্পাদনা', 'Edit Profile'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr('অ্যাভাটার আইকন বেছে নিন', 'Choose Avatar Icon'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(_avatarIcons.length, (index) {
                        final isSelected = tempAvatar == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () =>
                                setModalState(() => tempAvatar = index),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: isSelected
                                  ? kPrimaryDeepIndigo
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                              child: Icon(
                                _avatarIcons[index],
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: tr('পূর্ণ নাম', 'Full Name'),
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameCtrl,
                      decoration: InputDecoration(
                        labelText: tr('ইউজারনেম', 'Username'),
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        labelText: tr('ইমেইল', 'Email Address'),
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: roleCtrl,
                      decoration: InputDecoration(
                        labelText: tr('পদবি / পরিচয়', 'Role / Headline'),
                        prefixIcon: const Icon(Icons.work_outline),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () async {
                          setState(() {
                            if (nameCtrl.text.trim().isNotEmpty) {
                              _name = nameCtrl.text.trim();
                            }
                            if (usernameCtrl.text.trim().isNotEmpty) {
                              _username =
                                  usernameCtrl.text.trim().replaceAll('@', '');
                            }
                            if (emailCtrl.text.trim().isNotEmpty) {
                              _email = emailCtrl.text.trim();
                            }
                            if (roleCtrl.text.trim().isNotEmpty) {
                              _role = roleCtrl.text.trim();
                            }
                            _selectedAvatarIndex = tempAvatar;
                          });
                          await _saveProfileChangesToPrefs();
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: kSecondarySunsetOrange,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.save_outlined),
                        label: Text(tr('পরিবর্তন সেভ করুন', 'Save Changes')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(tr('আমার প্রোফাইল', 'My Profile'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If not logged in yet, show prompt to Sign In first
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text(tr('আমার প্রোফাইল', 'My Profile')),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: kPrimaryDeepIndigo.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.person_off_outlined,
                    size: 46,
                    color: kPrimaryDeepIndigo,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  tr('কোনো অ্যাকাউন্ট লগইন করা নেই', 'No Active User Profile'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr(
                    'আপনার প্রোফাইল এবং ব্যক্তিগত খতিয়ানের তথ্য দেখতে অনুগ্রহ করে প্রথমে সাইন ইন করুন।',
                    'Please sign in to your account first to view your profile and personal Khatian portfolio.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _openLoginPage,
                    style: FilledButton.styleFrom(
                      backgroundColor: kSecondarySunsetOrange,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      tr('সাইন ইন করুন (Sign In)', 'Sign In to Account'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _openSignupPage,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      tr('নতুন অ্যাকাউন্ট তৈরি করুন', 'Create New Account'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Calculate land statistics for the signed-in user
    double totalDecimals = 0;
    for (final rec in _khatianList) {
      totalDecimals += rec.totalLandArea;
    }
    final double totalBigha = totalDecimals / 33.0;
    final double totalAcre = totalDecimals / 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('আমার প্রোফাইল', 'My Profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: tr('সম্পাদনা', 'Edit Profile'),
            onPressed: _showEditProfileDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: tr('লগআউট', 'Log Out'),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Signed-In User Header Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor:
                            kPrimaryDeepIndigo.withValues(alpha: 0.14),
                        child: Icon(
                          _avatarIcons[_selectedAvatarIndex],
                          size: 46,
                          color: kPrimaryDeepIndigo,
                        ),
                      ),
                      InkWell(
                        onTap: _showEditProfileDialog,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: kSecondarySunsetOrange,
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@$_username • $_email',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryDeepIndigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _role,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryDeepIndigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Land Portfolio Summary Row
          Row(
            children: [
              _buildMetricTile(
                context,
                icon: Icons.folder_copy_outlined,
                label: tr('মোট খতিয়ান', 'Khatians'),
                value: '${_khatianList.length}',
                color: kPrimaryDeepIndigo,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                icon: Icons.square_foot_rounded,
                label: tr('মোট শতাংশ', 'Decimals'),
                value: totalDecimals.toStringAsFixed(1),
                color: kSecondarySunsetOrange,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                icon: Icons.landscape_outlined,
                label: tr('বিঘা / একর', 'Bigha / Acre'),
                value:
                    '${totalBigha.toStringAsFixed(1)}B / ${totalAcre.toStringAsFixed(2)}A',
                color: Colors.teal.shade700,
              ),
            ],
          ),

          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: _handleLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              minimumSize: const Size(double.infinity, 48),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: Text(tr('লগআউট করুন (Log Out)', 'Log Out')),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
