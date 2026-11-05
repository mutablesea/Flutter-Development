import 'package:flutter/material.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onClearCompleted;
  final VoidCallback? onResetDefaults;
  final int completedTasksCount;
  final int totalTasksCount;

  const SettingsPage({
    super.key,
    this.onClearCompleted,
    this.onResetDefaults,
    this.completedTasksCount = 0,
    this.totalTasksCount = 0,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Local state for common setting preferences
  bool _confirmBeforeDelete = true;
  bool _dailyReminders = true;
  bool _completionCelebration = true;
  String _defaultPriority = 'Medium';

  void _showClearCompletedDialog() {
    if (widget.completedTasksCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No completed tasks to clear.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Completed Tasks?'),
        content: Text(
          'This will permanently delete ${widget.completedTasksCount} completed task(s).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onClearCompleted?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completed tasks cleared.')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Tasks?'),
        content: const Text(
          'This will restore sample starter tasks and overwrite current items.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onResetDefaults?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tasks reset to default.')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDefaultPriorityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Default Priority',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                ...['Low', 'Medium', 'High'].map((p) => ListTile(
                      leading: Icon(
                        Icons.flag,
                        color: p == 'High'
                            ? Colors.red
                            : p == 'Medium'
                                ? Colors.orange
                                : Colors.blue,
                      ),
                      title: Text(p),
                      trailing: _defaultPriority == p
                          ? const Icon(Icons.check, color: Colors.deepPurple)
                          : null,
                      onTap: () {
                        setState(() => _defaultPriority = p);
                        Navigator.of(ctx).pop();
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, currentMode, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            children: [
              // Appearance Section
              _buildSectionHeader('Appearance', Icons.palette_outlined),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Theme Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose between System default, Light, or Dark theme.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto),
                            label: Text('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode),
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {currentMode},
                        onSelectionChanged: (newSelection) {
                          themeModeNotifier.value = newSelection.first;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            currentMode == ThemeMode.system
                                ? Icons.brightness_auto
                                : currentMode == ThemeMode.light
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currentMode == ThemeMode.system
                                ? 'Currently synced with device theme'
                                : currentMode == ThemeMode.light
                                    ? 'Light theme active'
                                    : 'Dark theme active',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Task Preferences Section
              _buildSectionHeader('Task Preferences', Icons.tune),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.flag_outlined),
                      title: const Text('Default Priority'),
                      subtitle: Text('New tasks start as $_defaultPriority'),
                      trailing: Chip(
                        label: Text(_defaultPriority),
                        backgroundColor: _defaultPriority == 'High'
                            ? Colors.red.withValues(alpha: 0.15)
                            : _defaultPriority == 'Medium'
                                ? Colors.orange.withValues(alpha: 0.15)
                                : Colors.blue.withValues(alpha: 0.15),
                      ),
                      onTap: _showDefaultPriorityPicker,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.delete_sweep_outlined),
                      title: const Text('Confirm Before Delete'),
                      subtitle:
                          const Text('Show a confirmation snackbar on delete'),
                      value: _confirmBeforeDelete,
                      onChanged: (val) {
                        setState(() => _confirmBeforeDelete = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Notifications Section
              _buildSectionHeader('Notifications', Icons.notifications_outlined),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.alarm),
                      title: const Text('Daily Reminders'),
                      subtitle:
                          const Text('Get notified of pending tasks daily'),
                      value: _dailyReminders,
                      onChanged: (val) {
                        setState(() => _dailyReminders = val);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.celebration_outlined),
                      title: const Text('Completion Feedback'),
                      subtitle: const Text('Haptic feedback on task check'),
                      value: _completionCelebration,
                      onChanged: (val) {
                        setState(() => _completionCelebration = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Data & Storage Section
              _buildSectionHeader('Data Management', Icons.storage_outlined),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.check_circle_outline,
                          color: Colors.green),
                      title: const Text('Clear Completed Tasks'),
                      subtitle: Text(
                          '${widget.completedTasksCount} completed task(s) recorded'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: _showClearCompletedDialog,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.restart_alt,
                          color: Colors.redAccent),
                      title: const Text('Reset All Tasks'),
                      subtitle: const Text('Restore default sample tasks'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: _showResetDialog,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // About Section
              _buildSectionHeader('About', Icons.info_outline),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.check_box_rounded,
                          color: Colors.deepPurple),
                      title: Text('Task Flow'),
                      subtitle: Text('Version 1.2.0 • Built with Flutter'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Open Source Licenses'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName: 'Task Flow',
                          applicationVersion: '1.2.0',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

