import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class BackupSnapshot {
  final String id;
  final String label;
  final String timestamp;
  final int taskCount;
  final String sizeKb;

  const BackupSnapshot({
    required this.id,
    required this.label,
    required this.timestamp,
    required this.taskCount,
    required this.sizeKb,
  });
}

class BackupSyncPage extends StatefulWidget {
  final List<TodoItem>? tasks;

  const BackupSyncPage({super.key, this.tasks});

  @override
  State<BackupSyncPage> createState() => _BackupSyncPageState();
}

class _BackupSyncPageState extends State<BackupSyncPage> {
  bool _isSyncing = false;
  bool _autoSync = true;
  bool _wifiOnly = true;
  bool _includeCompleted = true;
  String _lastSyncText = 'Today at 11:45 AM';

  final List<BackupSnapshot> _snapshots = [
    const BackupSnapshot(
      id: 'b1',
      label: 'Automatic Daily Backup',
      timestamp: 'Today, 11:45 AM',
      taskCount: 14,
      sizeKb: '18.4 KB',
    ),
    const BackupSnapshot(
      id: 'b2',
      label: 'Pre-Sprint Manual Snapshot',
      timestamp: 'Yesterday, 08:20 PM',
      taskCount: 11,
      sizeKb: '14.2 KB',
    ),
  ];

  Future<void> _triggerSyncNow() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    final taskLen = widget.tasks?.length ?? 4;
    setState(() {
      _isSyncing = false;
      _lastSyncText = 'Just now';
      _snapshots.insert(
        0,
        BackupSnapshot(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: 'Manual Cloud Sync',
          timestamp: 'Just now',
          taskCount: taskLen,
          sizeKb: '${(taskLen * 1.4).toStringAsFixed(1)} KB',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cloud backup & sync completed!')),
    );
  }

  void _showExportPreviewDialog() {
    final sampleTasks = widget.tasks ?? [];
    final previewLines = sampleTasks.isEmpty
        ? '[\n  {"title": "Learn Dart fundamentals", "priority": "High", "isDone": true}\n]'
        : '[\n${sampleTasks.take(3).map((t) => '  {"title": "${t.title}", "priority": "${t.priority}", "isDone": ${t.isDone}}').join(',\n')}\n]';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export JSON Backup'),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SelectableText(
            previewLines,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup JSON exported locally.')),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Save File'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Sync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code_rounded),
            tooltip: 'Export JSON',
            onPressed: _showExportPreviewDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cloud Status Banner Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      _isSyncing
                          ? Icons.sync_rounded
                          : Icons.cloud_done_rounded,
                      size: 34,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isSyncing
                        ? 'Syncing your workspace...'
                        : 'Workspace Backed Up',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last synced: $_lastSyncText',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isSyncing)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton.icon(
                        onPressed: _triggerSyncNow,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Sync & Backup Now'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sync Settings Card
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Sync Preferences',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.autorenew_rounded),
                  title: const Text('Auto Cloud Sync'),
                  subtitle:
                      const Text('Automatically sync changes in background'),
                  value: _autoSync,
                  onChanged: (val) => setState(() => _autoSync = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.wifi_rounded),
                  title: const Text('Sync over Wi-Fi Only'),
                  subtitle: const Text('Save mobile data when on cellular'),
                  value: _wifiOnly,
                  onChanged: (val) => setState(() => _wifiOnly = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.task_alt_rounded),
                  title: const Text('Include Completed Tasks'),
                  subtitle:
                      const Text('Keep completed task history in backups'),
                  value: _includeCompleted,
                  onChanged: (val) => setState(() => _includeCompleted = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Snapshots History
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'Recent Backup Snapshots',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: _showExportPreviewDialog,
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('Export JSON'),
              ),
            ],
          ),
          ..._snapshots.map((snap) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
                  child: Icon(
                    Icons.history_rounded,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  snap.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${snap.timestamp} • ${snap.taskCount} tasks (${snap.sizeKb})',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Restored snapshot: "${snap.label}"'),
                      ),
                    );
                  },
                  child: const Text('Restore'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

