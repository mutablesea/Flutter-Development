import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home_page.dart';
import 'signup_page.dart';

class DemoUserAccount {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String role;

  const DemoUserAccount({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // Built-in local accounts (Mutant Freeman & Neon Saab) verified on sign-in
  static const List<DemoUserAccount> builtInAccounts = [
    DemoUserAccount(
      fullName: 'Mutant Freeman',
      username: 'mutant',
      email: 'mutant@gmail.com',
      password: 'mutant1234',
      role: 'Senior Land Surveyor • Bhumi Calc Pro',
    ),
    DemoUserAccount(
      fullName: 'Neon Saab',
      username: 'neon',
      email: 'neon@gmail.com',
      password: 'neon1234',
      role: 'Property Portfolio Owner • Bhumi Calc Member',
    ),
  ];

  static Future<void> saveSessionToPrefs({
    required String fullName,
    required String username,
    required String email,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_is_logged_in', true);
    await prefs.setString('auth_full_name', fullName);
    await prefs.setString('auth_username', username);
    await prefs.setString('auth_email', email);
    if (role != null) {
      await prefs.setString('auth_role', role);
    }
  }

  static Future<void> clearSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_is_logged_in', false);
    await prefs.remove('auth_full_name');
    await prefs.remove('auth_username');
    await prefs.remove('auth_email');
    await prefs.remove('auth_role');
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final inputUser = _usernameController.text.trim().toLowerCase();
    final inputPass = _passwordController.text;

    if (inputUser.isEmpty || inputPass.isEmpty) {
      setState(() {
        _errorMessage = tr(
          'অনুগ্রহ করে ইউজারনেম এবং পাসওয়ার্ড উভয়ই দিন।',
          'Please enter both username and password.',
        );
      });
      return;
    }

    // 1. Check built-in default accounts (mutant / mutant1234 or neon / neon1234)
    final matchedBuiltIn = LoginPage.builtInAccounts.where((acc) {
      return (acc.username.toLowerCase() == inputUser ||
              acc.email.toLowerCase() == inputUser) &&
          acc.password == inputPass;
    });

    String? loggedName;
    String? loggedUsername;
    String? loggedEmail;
    String? loggedRole;

    if (matchedBuiltIn.isNotEmpty) {
      final user = matchedBuiltIn.first;
      loggedName = user.fullName;
      loggedUsername = user.username;
      loggedEmail = user.email;
      loggedRole = user.role;
    } else {
      // 2. Check custom signed-up user stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final regUser = prefs.getString('registered_username')?.toLowerCase();
      final regEmail = prefs.getString('registered_email')?.toLowerCase();
      final regPass = prefs.getString('registered_password');
      final regName = prefs.getString('registered_full_name');

      if (regPass != null &&
          regPass == inputPass &&
          (inputUser == regUser || inputUser == regEmail)) {
        loggedName = regName ?? inputUser;
        loggedUsername = regUser ?? inputUser;
        loggedEmail = regEmail ?? '$inputUser@gmail.com';
        loggedRole = 'Land Owner • Bhumi Calc Member';
      }
    }

    if (loggedName != null && loggedUsername != null && loggedEmail != null) {
      await LoginPage.saveSessionToPrefs(
        fullName: loggedName,
        username: loggedUsername,
        email: loggedEmail,
        role: loggedRole,
      );

      if (!mounted) return;
      setState(() => _errorMessage = null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(
              '$loggedName (@$loggedUsername) হিসেবে সাইন ইন সফল হয়েছে!',
              'Signed in as $loggedName (@$loggedUsername)',
            ),
          ),
        ),
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        _errorMessage = tr(
          'ভুল ইউজারনেম বা পাসওয়ার্ড দেওয়া হয়েছে।',
          'Invalid username or password.',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('সাইন ইন (Sign In)', 'Sign In')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Icon & Header
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryDeepIndigo.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 42,
                    color: kPrimaryDeepIndigo,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr('আপনার অ্যাকাউন্টে সাইন ইন করুন', 'Welcome Back'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tr(
                  'আপনার প্রোফাইল ও খতিয়ান দেখতে ইউজারনেম এবং পাসওয়ার্ড দিয়ে লগইন করুন',
                  'Enter your username and password to access your account',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: tr('ইউজারনেম বা ইমেইল', 'Username or Email'),
                  hintText: tr('আপনার ইউজারনেম লিখুন', 'Enter your username'),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onSubmitted: (_) => _handleLogin(),
                decoration: InputDecoration(
                  labelText: tr('পাসওয়ার্ড', 'Password'),
                  hintText: tr('আপনার পাসওয়ার্ড লিখুন', 'Enter your password'),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() => _rememberMe = val ?? true);
                        },
                      ),
                      Text(
                        tr('মনে রাখুন', 'Remember me'),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tr(
                              'পাসওয়ার্ড ভুলে গেলে সাপোর্টে যোগাযোগ করুন।',
                              'Please contact support if you forgot your password.',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(tr('পাসওয়ার্ড ভুলে গেছেন?', 'Forgot Password?')),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Login Button
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _handleLogin,
                  style: FilledButton.styleFrom(
                    backgroundColor: kSecondarySunsetOrange,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.login_rounded),
                  label: Text(
                    tr('সাইন ইন করুন (Sign In)', 'Sign In'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Navigate to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('কোনো অ্যাকাউন্ট নেই?', "Don't have an account?"),
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      tr('নতুন অ্যাকাউন্ট খুলুন', 'Sign Up'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
