import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_page.dart';
import 'todo_list_page.dart';

class DemoUserAccount {
  final String fullName;
  final String username;
  final String email;
  final String password;

  const DemoUserAccount({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // Built-in local accounts (Mutant Freeman & Neon Saab)
  static const List<DemoUserAccount> builtInAccounts = [
    DemoUserAccount(
      fullName: 'Mutant Freeman',
      username: 'mutant',
      email: 'mutant@gmail.com',
      password: 'mutant1234',
    ),
    DemoUserAccount(
      fullName: 'Neon Saab',
      username: 'neon',
      email: 'neon@gmail.com',
      password: 'neon1234',
    ),
  ];

  static Future<void> saveSessionToPrefs({
    required String fullName,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_is_logged_in', true);
    await prefs.setString('auth_full_name', fullName);
    await prefs.setString('auth_username', username);
    await prefs.setString('auth_email', email);
  }

  static Future<void> clearSessionFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_is_logged_in', false);
    await prefs.remove('auth_full_name');
    await prefs.remove('auth_username');
    await prefs.remove('auth_email');
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
        _errorMessage = 'Please enter both username and password.';
      });
      return;
    }

    // 1. Check built-in local accounts (mutant / mutant1234 or neon / neon1234)
    final matchedBuiltIn = LoginPage.builtInAccounts.where((acc) {
      return (acc.username.toLowerCase() == inputUser ||
              acc.email.toLowerCase() == inputUser) &&
          acc.password == inputPass;
    });

    String? loggedName;
    String? loggedUsername;
    String? loggedEmail;

    if (matchedBuiltIn.isNotEmpty) {
      final user = matchedBuiltIn.first;
      loggedName = user.fullName;
      loggedUsername = user.username;
      loggedEmail = user.email;
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
      }
    }

    if (loggedName != null && loggedUsername != null && loggedEmail != null) {
      await LoginPage.saveSessionToPrefs(
        fullName: loggedName,
        username: loggedUsername,
        email: loggedEmail,
      );

      if (!mounted) return;
      setState(() => _errorMessage = null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in as $loggedName (@$loggedUsername)'),
        ),
      );

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TodoListPage()),
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Invalid username or password.';
      });
    }
  }

  void _handleGoogleContinue() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Continue with Google is currently disabled in demo mode.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo & Welcome
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'figures/task_flow_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.lock_person_rounded,
                      size: 38,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to view your profile & sync tasks locally',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
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
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                onSubmitted: (_) => _handleLogin(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
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
                      const Text('Remember me', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please contact support if you forgot your password.',
                          ),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Login Button
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: _handleLogin,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Divider with OR
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // Continue with Google Button (Demo non-functional as requested)
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _handleGoogleContinue,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Navigate to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
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
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
