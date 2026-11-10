import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim().replaceAll('@', '');
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (name.isEmpty || username.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = tr(
          'অ্যাকাউন্ট তৈরি করতে সবগুলো ঘর পূরণ করুন।',
          'Please fill in all fields to create your account.',
        );
      });
      return;
    }

    if (pass != confirmPass) {
      setState(() {
        _errorMessage = tr(
          'পাসওয়ার্ড দুটি মিলছে না।',
          'Passwords do not match.',
        );
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = tr(
          'অনুগ্রহ করে শর্তাবলীতে সম্মতি দিন।',
          'Please accept the terms to continue.',
        );
      });
      return;
    }

    // Save registered account & active session locally in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_full_name', name);
    await prefs.setString('registered_username', username);
    await prefs.setString('registered_email', email);
    await prefs.setString('registered_password', pass);

    await LoginPage.saveSessionToPrefs(
      fullName: name,
      username: username,
      email: email,
      role: 'Land Portfolio Owner • Bhumi Calc Member',
    );

    if (!mounted) return;
    setState(() => _errorMessage = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tr(
            'অ্যাকাউন্ট তৈরি হয়েছে এবং $name (@$username) হিসেবে লগইন করা হয়েছে!',
            'Account created & logged in as $name (@$username)!',
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('নতুন অ্যাকাউন্ট (Sign Up)', 'Create Account')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 74,
                  height: 74,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 38,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tr('Bhumi Calc-এ যুক্ত হোন', 'Join Bhumi Calc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tr(
                  'আপনার খতিয়ান ও জমির হিসাব সংরক্ষণের জন্য প্রোফাইল তৈরি করুন',
                  'Create your profile to manage Khatian records & land portfolio',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: tr('পূর্ণ নাম (Full Name)', 'Full Name'),
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: tr('ইউজারনেম (Username)', 'Username'),
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: tr('ইমেইল (Email Address)', 'Email Address'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: tr('পাসওয়ার্ড (Password)', 'Password'),
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
              const SizedBox(height: 14),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                onSubmitted: (_) => _handleSignup(),
                decoration: InputDecoration(
                  labelText: tr(
                    'পাসওয়ার্ড নিশ্চিত করুন (Confirm Password)',
                    'Confirm Password',
                  ),
                  prefixIcon: const Icon(Icons.verified_user_outlined),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _agreeToTerms,
                onChanged: (val) {
                  setState(() => _agreeToTerms = val ?? true);
                },
                title: Text(
                  tr(
                    'আমি Bhumi Calc-এর নীতিমালা ও শর্তাবলীতে সম্মত',
                    'I agree to the Bhumi Calc Terms & Privacy Policy',
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _handleSignup,
                  icon: const Icon(Icons.person_add_rounded),
                  label: Text(
                    tr('অ্যাকাউন্ট তৈরি করুন', 'Create Account'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('ইতিমধ্যে অ্যাকাউন্ট আছে?', 'Already have an account?'),
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      tr('লগইন করুন', 'Log In'),
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

