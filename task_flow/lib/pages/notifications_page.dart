import 'package:flutter/material.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final String category; // 'Reminder', 'System', 'Achievement'
  final IconData icon;
  final Color color;
  bool isRead;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.category,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _selectedTab = 'All'; // 'All', 'Unread', 'Reminder'
  bool _pushEnabled = true;
  bool _morningDigest = true;
  bool _dueDateAlerts = true;

  final List<AppNotificationItem> _notifications = [
    AppNotificationItem(
      id: 'n1',
      title: 'High Priority Task Due Today',
      body: '"Build multi-page UI in Flutter" is scheduled for today.',
      timeLabel: '10m ago',
      category: 'Reminder',
      icon: Icons.alarm_rounded,
      color: Colors.redAccent,
      isRead: false,
    ),
    AppNotificationItem(
      id: 'n2',
      title: 'Pomodoro Session Completed',
      body: 'Great job! You completed a 25-minute deep work focus block.',
      timeLabel: '1h ago',
      category: 'Achievement',
      icon: Icons.bolt_rounded,
      color: Colors.deepPurple,
      isRead: false,
    ),
    AppNotificationItem(
      id: 'n3',
      title: '7-Day Productivity Streak!',
      body: 'You have completed at least one task every day this week.',
      timeLabel: '3h ago',
      category: 'Achievement',
      icon: Icons.local_fire_department_rounded,
      color: Colors.orange,
      isRead: true,
    ),
    AppNotificationItem(
      id: 'n4',
      title: 'Morning Daily Briefing',
      body: 'You have 3 active tasks and 1 completed task in your queue.',
      timeLabel: 'Yesterday',
      category: 'Reminder',
      icon: Icons.wb_sunny_outlined,
      color: Colors.teal,
      isRead: true,
    ),
  ];

  List<AppNotificationItem> get _filteredList {
    return _notifications.where((item) {
      if (_selectedTab == 'Unread') return !item.isRead;
      if (_selectedTab == 'Reminder') return item.category == 'Reminder';
      return true;
    }).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (final item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read.')),
    );
  }

  void _clearAll() {
    if (_notifications.isEmpty) return;
    setState(() => _notifications.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleared all notifications.')),
    );
  }

  void _showNotificationSettingsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive task & timer alerts'),
                      value: _pushEnabled,
                      onChanged: (val) {
                        setModalState(() => _pushEnabled = val);
                        setState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Morning Daily Digest (8:30 AM)'),
                      subtitle: const Text('Daily summary of scheduled tasks'),
                      value: _morningDigest,
                      onChanged: (val) {
                        setModalState(() => _morningDigest = val);
                        setState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Deadline Reminders'),
                      subtitle:
                          const Text('Alert 30 minutes before task is due'),
                      value: _dueDateAlerts,
                      onChanged: (val) {
                        setModalState(() => _dueDateAlerts = val);
                        setState(() {});
                      },
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
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final items = _filteredList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Notification Settings',
            onPressed: _showNotificationSettingsSheet,
          ),
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear All',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('All (${_notifications.length})'),
                  selected: _selectedTab == 'All',
                  onSelected: (_) => setState(() => _selectedTab = 'All'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Unread ($unreadCount)'),
                  selected: _selectedTab == 'Unread',
                  onSelected: (_) => setState(() => _selectedTab = 'Unread'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Reminders'),
                  selected: _selectedTab == 'Reminder',
                  onSelected: (_) => setState(() => _selectedTab = 'Reminder'),
                ),
              ],
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.45),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'You\'re all caught up!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No notifications in this view.',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final n = items[index];
                      return Dismissible(
                        key: ValueKey(n.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() => _notifications.remove(n));
                        },
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: n.isRead ? 0.5 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: n.isRead
                                  ? Colors.transparent
                                  : n.color.withValues(alpha: 0.35),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: n.color.withValues(alpha: 0.14),
                              child: Icon(n.icon, color: n.color, size: 22),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: TextStyle(
                                      fontWeight: n.isRead
                                          ? FontWeight.w600
                                          : FontWeight.bold,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ),
                                if (!n.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  n.body,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${n.category} • ${n.timeLabel}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() => n.isRead = !n.isRead);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

