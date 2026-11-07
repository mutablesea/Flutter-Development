import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class TrashPage extends StatefulWidget {
  final List<TodoItem>? trashedTasks;
  final ValueChanged<TodoItem>? onRestoreTask;
  final ValueChanged<TodoItem>? onDeletePermanently;
  final VoidCallback? onRestoreAll;
  final VoidCallback? onEmptyTrash;

  const TrashPage({
    super.key,
    this.trashedTasks,
    this.onRestoreTask,
    this.onDeletePermanently,
    this.onRestoreAll,
    this.onEmptyTrash,
  });

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  late List<TodoItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.trashedTasks ??
        [
          TodoItem(
            title: 'Old grocery shopping list',
            priority: 'Low',
            category: 'Personal',
            isDone: true,
            deletedAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          TodoItem(
            title: 'Draft legacy API notes',
            priority: 'Medium',
            category: 'Work',
            deletedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDeletedTime(DateTime? dt) {
    if (dt == null) return 'Deleted recently';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Deleted just now';
    if (diff.inMinutes < 60) return 'Deleted ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Deleted ${diff.inHours}h ago';
    return 'Deleted ${diff.inDays}d ago';
  }

  void _restoreSingle(TodoItem task) {
    setState(() {
      _items.remove(task);
    });
    widget.onRestoreTask?.call(task);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restored "${task.title}"')),
    );
  }

  void _deleteSingleForever(TodoItem task) {
    setState(() {
      _items.remove(task);
    });
    widget.onDeletePermanently?.call(task);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permanently deleted "${task.title}"')),
    );
  }

  void _handleRestoreAll() {
    if (_items.isEmpty) return;
    final count = _items.length;
    if (widget.onRestoreAll != null) {
      widget.onRestoreAll!();
      setState(() {});
    } else {
      setState(() => _items.clear());
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Restored all $count task(s).')),
    );
  }

  void _confirmEmptyTrash() {
    if (_items.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Empty Trash?'),
        content: Text(
          'This will permanently delete ${_items.length} item(s). This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (widget.onEmptyTrash != null) {
                widget.onEmptyTrash!();
                setState(() {});
              } else {
                setState(() => _items.clear());
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trash emptied.')),
              );
            },
            child: const Text('Delete Forever'),
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
        title: const Text('Trash Bin'),
        actions: [
          if (_items.isNotEmpty) ...[
            TextButton.icon(
              onPressed: _handleRestoreAll,
              icon: const Icon(Icons.restore_rounded, size: 18),
              label: const Text('Restore All'),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever_rounded,
                color: theme.colorScheme.error,
              ),
              tooltip: 'Empty Trash',
              onPressed: _confirmEmptyTrash,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Deleted tasks are kept here safely. Restore them anytime or empty the trash to remove forever.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Trashed items list
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_delete_outlined,
                            size: 64,
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.45),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Trash is empty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Any tasks you delete will appear here for easy recovery.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final task = _items[index];
                      final pColor = _getPriorityColor(task.priority);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer
                                      .withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                pColor.withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            task.priority,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: pColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '• ${task.category}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          '• ${_formatDeletedTime(task.deletedAt)}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.restore_rounded,
                                  color: theme.colorScheme.primary,
                                ),
                                tooltip: 'Restore Task',
                                onPressed: () => _restoreSingle(task),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: theme.colorScheme.error,
                                ),
                                tooltip: 'Delete Forever',
                                onPressed: () => _deleteSingleForever(task),
                              ),
                            ],
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

