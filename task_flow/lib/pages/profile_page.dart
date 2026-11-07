import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_item.dart';
import 'login_page.dart';
import 'signup_page.dart';

class ProfilePage extends StatefulWidget {
  final List<TodoItem>? tasks;

  const ProfilePage({super.key, this.tasks});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  String _name = '';
  String _username = '';
  String _email = '';
  String _role = 'Productive Creator • Task Flow Member';
  int _dailyGoal = 5;
  int _selectedAvatarIndex = 0;

  static const List<IconData> _avatarIcons = [
    Icons.person_rounded,
    Icons.rocket_launch_rounded,
    Icons.psychology_rounded,
    Icons.code_rounded,
    Icons.auto_awesome_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('auth_is_logged_in') ?? false;

    if (!mounted) return;
    setState(() {
      _isLoggedIn = loggedIn;
      if (loggedIn) {
        _name = prefs.getString('auth_full_name') ?? '';
        _username = prefs.getString('auth_username') ?? '';
        _email = prefs.getString('auth_email') ?? '';
        _role = prefs.getString('auth_role') ??
            'Productive Creator • Task Flow Member';
        _dailyGoal = prefs.getInt('auth_daily_goal') ?? 5;
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
    await prefs.setInt('auth_daily_goal', _dailyGoal);
    await prefs.setInt('auth_avatar_index', _selectedAvatarIndex);
  }

  Future<void> _handleLogout() async {
    await LoginPage.clearSessionFromPrefs();
    if (!mounted) return;
    await _loadUserFromPrefs();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully.')),
    );
  }

  Future<void> _openLoginPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    await _loadUserFromPrefs();
  }

  Future<void> _openSignupPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupPage()),
    );
    await _loadUserFromPrefs();
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final usernameCtrl = TextEditingController(text: _username);
    final emailCtrl = TextEditingController(text: _email);
    final roleCtrl = TextEditingController(text: _role);
    int tempGoal = _dailyGoal;
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
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
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
                    const Text(
                      'Choose Avatar Icon',
                      style: TextStyle(
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
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                              child: Icon(
                                _avatarIcons[index],
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
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
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: roleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Bio / Headline',
                        prefixIcon: Icon(Icons.work_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Task Goal',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$tempGoal tasks / day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: tempGoal.toDouble(),
                      min: 1,
                      max: 15,
                      divisions: 14,
                      label: '$tempGoal',
                      onChanged: (val) {
                        setModalState(() => tempGoal = val.round());
                      },
                    ),
                    const SizedBox(height: 12),
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
                            _dailyGoal = tempGoal;
                            _selectedAvatarIndex = tempAvatar;
                          });
                          await _saveProfileChangesToPrefs();
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile saved locally!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save Changes'),
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
        appBar: AppBar(title: const Text('My Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If not logged in yet, show prompt to Log In first
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person_off_outlined,
                    size: 44,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Active User Profile',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please log in to your account first to view your profile, daily goals, and achievements.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _openLoginPage,
                    icon: const Icon(Icons.login_rounded),
                    label: const Text(
                      'Log In to Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _openSignupPage,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Create New Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final taskList = widget.tasks ?? [];
    final totalTasks = taskList.isEmpty ? 12 : taskList.length;
    final completedTasks =
        taskList.isEmpty ? 8 : taskList.where((t) => t.isDone).length;
    final completionRate =
        totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();
    final goalProgress = (completedTasks / _dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: _showEditProfileDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
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
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          _avatarIcons[_selectedAvatarIndex],
                          size: 46,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      InkWell(
                        onTap: _showEditProfileDialog,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primary,
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Stats Row
          Row(
            children: [
              _buildMetricTile(
                context,
                icon: Icons.check_circle_outline_rounded,
                label: 'Completed',
                value: '$completedTasks',
                color: Colors.green,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                value: '7 Days',
                color: Colors.deepOrange,
              ),
              const SizedBox(width: 10),
              _buildMetricTile(
                context,
                icon: Icons.insights_rounded,
                label: 'Success',
                value: '$completionRate%',
                color: Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Daily Goal Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.flag_circle_rounded,
                              color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Daily Goal Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$completedTasks / $_dailyGoal tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: goalProgress,
                      minHeight: 9,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    goalProgress >= 1.0
                        ? 'Awesome! You reached your daily goal today.'
                        : 'Complete ${(_dailyGoal - completedTasks).clamp(1, _dailyGoal)} more task(s) to hit your daily target.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Achievements Section
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Achievements & Badges',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: const [
              _AchievementBadge(
                title: 'Early Bird',
                subtitle: 'Morning planner',
                icon: Icons.wb_sunny_rounded,
                color: Colors.amber,
                unlocked: true,
              ),
              _AchievementBadge(
                title: 'Task Master',
                subtitle: '10+ tasks done',
                icon: Icons.emoji_events_rounded,
                color: Colors.deepPurple,
                unlocked: true,
              ),
              _AchievementBadge(
                title: 'Focus Pro',
                subtitle: '5 Pomodoro sessions',
                icon: Icons.timer_rounded,
                color: Colors.teal,
                unlocked: true,
              ),
              _AchievementBadge(
                title: 'Zero Inbox',
                subtitle: 'Clear all tasks',
                icon: Icons.verified_rounded,
                color: Colors.blueGrey,
                unlocked: false,
              ),
            ],
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: _handleLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              minimumSize: const Size(double.infinity, 46),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool unlocked;

  const _AchievementBadge({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: unlocked
            ? color.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? color.withValues(alpha: 0.35)
              : theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                unlocked ? color : theme.colorScheme.outlineVariant,
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: unlocked
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
