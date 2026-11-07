import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class TagModel {
  String name;
  Color color;

  TagModel({required this.name, required this.color});
}

class TagsManagePage extends StatefulWidget {
  final List<TodoItem>? tasks;
  final VoidCallback? onTasksUpdated;

  const TagsManagePage({
    super.key,
    this.tasks,
    this.onTasksUpdated,
  });

  @override
  State<TagsManagePage> createState() => _TagsManagePageState();
}

class _TagsManagePageState extends State<TagsManagePage> {
  final List<TagModel> _tags = [
    TagModel(name: 'urgent', color: Colors.redAccent),
    TagModel(name: 'flutter', color: Colors.blue),
    TagModel(name: 'design', color: Colors.purple),
    TagModel(name: 'deep-work', color: Colors.teal),
    TagModel(name: 'quick', color: Colors.orange),
  ];

  late List<TodoItem> _localTasks;
  String? _selectedFilterTag;

  @override
  void initState() {
    super.initState();
    _localTasks = widget.tasks ??
        [
          TodoItem(
            title: 'Learn Dart fundamentals',
            isDone: true,
            priority: 'High',
            tags: ['flutter', 'deep-work'],
          ),
          TodoItem(
            title: 'Build multi-page UI in Flutter',
            isDone: false,
            priority: 'High',
            tags: ['flutter', 'design', 'urgent'],
          ),
          TodoItem(
            title: 'Review settings and dark mode theme',
            isDone: false,
            priority: 'Low',
            tags: ['quick', 'design'],
          ),
        ];

    // Seed sample tags onto passed tasks if none have tags yet
    if (widget.tasks != null &&
        widget.tasks!.isNotEmpty &&
        widget.tasks!.every((t) => t.tags.isEmpty)) {
      widget.tasks![0].tags.addAll(['flutter']);
      if (widget.tasks!.length > 1) {
        widget.tasks![1].tags.addAll(['urgent', 'design']);
      }
    }
  }

  Color _colorForTag(String tagName) {
    final found = _tags.where((t) => t.name == tagName);
    if (found.isNotEmpty) return found.first.color;
    return Colors.deepPurple;
  }

  int _taskCountForTag(String tagName) {
    return _localTasks.where((t) => t.tags.contains(tagName)).length;
  }

  List<TodoItem> get _filteredTasks {
    if (_selectedFilterTag == null) return _localTasks;
    return _localTasks
        .where((t) => t.tags.contains(_selectedFilterTag))
        .toList();
  }

  void _showCreateOrEditTagDialog({TagModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    Color chosenColor = existing?.color ?? Colors.indigo;

    final palette = [
      Colors.redAccent,
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
      Colors.green,
      Colors.pink,
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existing == null ? 'Create New Tag' : 'Edit Tag'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Tag Name',
                      prefixText: '#',
                      hintText: 'e.g., research',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tag Color',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: palette.map((c) {
                      final isSelected = chosenColor == c;
                      return GestureDetector(
                        onTap: () => setDialogState(() => chosenColor = c),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: c,
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final raw = nameCtrl.text
                        .trim()
                        .replaceAll('#', '')
                        .toLowerCase();
                    if (raw.isEmpty) return;

                    setState(() {
                      if (existing != null) {
                        final oldName = existing.name;
                        existing.name = raw;
                        existing.color = chosenColor;
                        for (final task in _localTasks) {
                          final idx = task.tags.indexOf(oldName);
                          if (idx != -1) {
                            task.tags[idx] = raw;
                          }
                        }
                        if (_selectedFilterTag == oldName) {
                          _selectedFilterTag = raw;
                        }
                      } else if (!_tags.any((t) => t.name == raw)) {
                        _tags.add(TagModel(name: raw, color: chosenColor));
                      }
                    });
                    widget.onTasksUpdated?.call();
                    Navigator.of(ctx).pop();
                  },
                  child: Text(existing == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTag(TagModel tag) {
    setState(() {
      _tags.remove(tag);
      for (final task in _localTasks) {
        task.tags.remove(tag.name);
      }
      if (_selectedFilterTag == tag.name) {
        _selectedFilterTag = null;
      }
    });
    widget.onTasksUpdated?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted tag #${tag.name}')),
    );
  }

  void _showAssignTagsSheet(TodoItem task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags for "${task.title}"',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        final hasTag = task.tags.contains(tag.name);
                        return FilterChip(
                          label: Text('#${tag.name}'),
                          selected: hasTag,
                          selectedColor: tag.color.withValues(alpha: 0.2),
                          checkmarkColor: tag.color,
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                task.tags.add(tag.name);
                              } else {
                                task.tags.remove(tag.name);
                              }
                            });
                            setState(() {});
                            widget.onTasksUpdated?.call();
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Done'),
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
    final displayedTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'New Tag',
            onPressed: () => _showCreateOrEditTagDialog(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags Directory Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Tags (${_tags.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_selectedFilterTag != null)
                  TextButton(
                    onPressed: () => setState(() => _selectedFilterTag = null),
                    child: const Text('Show All Tasks'),
                  ),
              ],
            ),
          ),

          // Tag chips with edit / delete actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedFilterTag == tag.name;
                final count = _taskCountForTag(tag.name);

                return InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: tag.color,
                    radius: 6,
                  ),
                  label: Text(
                    '#${tag.name} ($count)',
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: tag.color.withValues(alpha: 0.2),
                  onPressed: () {
                    setState(() {
                      _selectedFilterTag = isSelected ? null : tag.name;
                    });
                  },
                  onDeleted: () => _deleteTag(tag),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // Tasks & Their Tags
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              _selectedFilterTag == null
                  ? 'All Tasks — Tap a task to assign tags'
                  : 'Tasks tagged with #$_selectedFilterTag',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          Expanded(
            child: displayedTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.label_off_outlined,
                          size: 56,
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.45),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No tasks match this tag',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                    itemCount: displayedTasks.length,
                    itemBuilder: (context, index) {
                      final task = displayedTasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          onTap: () => _showAssignTagsSheet(task),
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: task.tags.isEmpty
                                ? Text(
                                    'No tags assigned • Tap to add',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.outline,
                                    ),
                                  )
                                : Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: task.tags.map((tName) {
                                      final c = _colorForTag(tName);
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: c.withValues(alpha: 0.14),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '#$tName',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: c,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.sell_outlined, size: 20),
                            onPressed: () => _showAssignTagsSheet(task),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOrEditTagDialog(),
        icon: const Icon(Icons.new_label_outlined),
        label: const Text('New Tag'),
      ),
    );
  }
}

