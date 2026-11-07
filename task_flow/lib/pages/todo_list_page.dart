import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import 'add_todo_page.dart';
import 'calendar_page.dart';
import 'categories_page.dart';
import 'onboarding_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'splash_page.dart';
import 'stats_page.dart';
import 'task_details_page.dart';
import 'trash_page.dart';

// Re-export TodoItem so existing imports pointing to todo_list_page continue working seamlessly
export '../models/todo_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Local state holding tasks with varying priorities
  final List<TodoItem> _tasks = [
    TodoItem(
      title: 'Learn Dart fundamentals',
      isDone: true,
      priority: 'High',
      category: 'Study',
    ),
    TodoItem(
      title: 'Build multi-page UI in Flutter',
      isDone: false,
      priority: 'High',
      category: 'Work',
    ),
    TodoItem(
      title: 'Design rounded task cards & filters',
      isDone: false,
      priority: 'Medium',
      category: 'Work',
    ),
    TodoItem(
      title: 'Review settings and dark mode theme',
      isDone: false,
      priority: 'Low',
      category: 'General',
    ),
  ];

  // Tasks moved to Trash Bin
  final List<TodoItem> _trashedTasks = [];

  // Active home filter
  String _selectedPriorityFilter = 'All'; // 'All', 'High', 'Medium', 'Low'
  String _selectedStatusFilter = 'All'; // 'All', 'Active', 'Completed'

  List<TodoItem> get _filteredTasks {
    return _tasks.where((task) {
      final matchesStatus = switch (_selectedStatusFilter) {
        'Active' => !task.isDone,
        'Completed' => task.isDone,
        _ => true,
      };

      final matchesPriority = switch (_selectedPriorityFilter) {
        'High' => task.priority == 'High',
        'Medium' => task.priority == 'Medium',
        'Low' => task.priority == 'Low',
        _ => true,
      };

      return matchesStatus && matchesPriority;
    }).toList();
  }

  Future<void> _navigateAndAddTask() async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );

    if (result is TodoItem) {
      setState(() {
        _tasks.add(result);
      });
    } else if (result is String && result.isNotEmpty) {
      setState(() {
        _tasks.add(TodoItem(title: result));
      });
    }
  }

  void _deleteTask(TodoItem task) {
    final taskIndex = _tasks.indexOf(task);
    if (taskIndex == -1) return;

    final removedTask = _tasks[taskIndex];
    removedTask.deletedAt = DateTime.now();
    setState(() {
      _tasks.removeAt(taskIndex);
      _trashedTasks.insert(0, removedTask);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${removedTask.title}" to Trash'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _trashedTasks.remove(removedTask);
              removedTask.deletedAt = null;
              _tasks.insert(taskIndex, removedTask);
            });
          },
        ),
      ),
    );
  }

  void _openCalendarPage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => CalendarPage(
              tasks: _tasks,
              onAddTask: (newTask) => setState(() => _tasks.add(newTask)),
              onTasksUpdated: () => setState(() {}),
            ),
          ),
        )
        .then((_) => setState(() {}));
  }

  void _openCategoriesPage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => CategoriesPage(
              tasks: _tasks,
              onAddTask: (newTask) => setState(() => _tasks.add(newTask)),
              onTasksUpdated: () => setState(() {}),
            ),
          ),
        )
        .then((_) => setState(() {}));
  }

  void _openTrashPage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => TrashPage(
              trashedTasks: _trashedTasks,
              onRestoreTask: (task) {
                setState(() {
                  task.deletedAt = null;
                  _tasks.add(task);
                });
              },
              onDeletePermanently: (_) => setState(() {}),
              onRestoreAll: () {
                setState(() {
                  for (final t in _trashedTasks) {
                    t.deletedAt = null;
                    _tasks.add(t);
                  }
                  _trashedTasks.clear();
                });
              },
              onEmptyTrash: () {
                setState(() => _trashedTasks.clear());
              },
            ),
          ),
        )
        .then((_) => setState(() {}));
  }

  void _openSearchPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(
          tasks: _tasks,
          onToggleTask: (_) => setState(() {}),
          onDeleteTask: (index) {
            if (index >= 0 && index < _tasks.length) {
              _deleteTask(_tasks[index]);
            }
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _openSettingsPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          completedTasksCount: _tasks.where((t) => t.isDone).length,
          totalTasksCount: _tasks.length,
          onClearCompleted: () {
            setState(() {
              _tasks.removeWhere((t) => t.isDone);
            });
          },
          onResetDefaults: () {
            setState(() {
              _tasks.clear();
              _tasks.addAll([
                TodoItem(
                  title: 'Learn Dart fundamentals',
                  isDone: true,
                  priority: 'High',
                ),
                TodoItem(
                  title: 'Build multi-page UI in Flutter',
                  isDone: false,
                  priority: 'High',
                ),
                TodoItem(
                  title: 'Design rounded task cards & filters',
                  isDone: false,
                  priority: 'Medium',
                ),
                TodoItem(
                  title: 'Review settings and dark mode theme',
                  isDone: false,
                  priority: 'Low',
                ),
              ]);
            });
          },
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.isDone).length;
    final progress = total == 0 ? 0.0 : completed / total;
    final displayedTasks = _filteredTasks;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Task Flow',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Smart Workspace',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.checklist_rounded),
                title: const Text('All Tasks'),
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text('Calendar Schedule'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openCalendarPage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Categories'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openCategoriesPage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Trash Bin'),
                trailing: _trashedTasks.isNotEmpty
                    ? Badge.count(count: _trashedTasks.length)
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  _openTrashPage();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.auto_graph_rounded),
                title: const Text('Onboarding Guide'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OnboardingPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.slideshow_rounded),
                title: const Text('Preview Splash Screen'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SplashPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Task Flow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Calendar Schedule',
            onPressed: _openCalendarPage,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search & Filters',
            onPressed: _openSearchPage,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Productivity Stats',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StatsPage(tasks: _tasks),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: _openSettingsPage,
          ),
        ],
      ),
      body: Column(
        children: [
          // Greeting & Daily Progress Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$completed of $total tasks completed',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: theme.colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Priority & Status Filters Bar on Home Page
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                // Status chips
                ...['All', 'Active', 'Completed'].map((status) {
                  final isSelected = _selectedStatusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedStatusFilter = status);
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(width: 6),
                Container(
                  height: 20,
                  width: 1,
                  color: theme.dividerColor,
                ),
                const SizedBox(width: 8),
                // Priority chips
                ...['High', 'Medium', 'Low'].map((priority) {
                  final isSelected = _selectedPriorityFilter == priority;
                  final pColor = _getPriorityColor(priority);
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      avatar: Icon(Icons.flag, size: 14, color: pColor),
                      label: Text(priority),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedPriorityFilter = selected ? priority : 'All';
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Task List with Round Cards
          Expanded(
            child: displayedTasks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _tasks.isEmpty
                                ? 'No tasks yet!'
                                : 'No matching tasks found',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tasks.isEmpty
                                ? 'Tap the + button below to create your first task.'
                                : 'Try changing your filter settings above.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (_selectedPriorityFilter != 'All' ||
                              _selectedStatusFilter != 'All') ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _selectedPriorityFilter = 'All';
                                  _selectedStatusFilter = 'All';
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset Filters'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: displayedTasks.length,
                    itemBuilder: (context, index) {
                      final task = displayedTasks[index];
                      final pColor = _getPriorityColor(task.priority);

                      return Dismissible(
                        key: ValueKey('${task.title}_${task.createdAt?.millisecondsSinceEpoch ?? index}'),
                        direction: DismissDirection.endToStart,
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
                        onDismissed: (_) => _deleteTask(task),
                        child: Card(
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: task.isDone
                                  ? Colors.transparent
                                  : pColor.withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              final updated =
                                  await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailsPage(task: task),
                                ),
                              );
                              if (updated == true) {
                                setState(() {});
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  // Rounded Checkbox
                                  Checkbox(
                                    value: task.isDone,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        task.isDone = value ?? false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),

                                  // Task Title & Priority Indicator
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            decoration: task.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            color: task.isDone
                                                ? theme.colorScheme.outline
                                                : theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            // Priority Badge
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: pColor.withValues(
                                                    alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.flag,
                                                      size: 12, color: pColor),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${task.priority} Priority',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: pColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Quick Priority Menu / Actions
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    tooltip: 'Task options',
                                    onSelected: (val) {
                                      if (val == 'Delete') {
                                        _deleteTask(task);
                                      } else {
                                        setState(() {
                                          task.priority = val;
                                        });
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        enabled: false,
                                        child: Text(
                                          'Change Priority:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      ...['Low', 'Medium', 'High'].map(
                                        (p) => PopupMenuItem(
                                          value: p,
                                          child: Row(
                                            children: [
                                              Icon(Icons.flag,
                                                  size: 16,
                                                  color: _getPriorityColor(p)),
                                              const SizedBox(width: 8),
                                              Text(p),
                                              if (task.priority == p) ...[
                                                const Spacer(),
                                                const Icon(Icons.check,
                                                    size: 16),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      const PopupMenuItem(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline,
                                                size: 16, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete Task',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateAndAddTask,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}
