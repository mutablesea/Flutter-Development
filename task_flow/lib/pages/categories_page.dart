import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_item.dart';
import 'task_details_page.dart';

class CategoryConfig {
  final String name;
  final IconData icon;
  final Color color;
  final bool isDefault;

  const CategoryConfig({
    required this.name,
    required this.icon,
    required this.color,
    this.isDefault = false,
  });
}

class CategoriesPage extends StatefulWidget {
  final List<TodoItem>? tasks;
  final ValueChanged<TodoItem>? onAddTask;
  final VoidCallback? onTasksUpdated;

  const CategoriesPage({
    super.key,
    this.tasks,
    this.onAddTask,
    this.onTasksUpdated,
  });

  /// Shared list of categories across CalendarPage, CategoriesPage, and AddTodoPage.
  static final List<CategoryConfig> sharedCategories = [
    const CategoryConfig(
      name: 'General',
      icon: Icons.inbox_rounded,
      color: Colors.deepPurple,
      isDefault: true,
    ),
    const CategoryConfig(
      name: 'Work',
      icon: Icons.work_outline_rounded,
      color: Colors.blue,
      isDefault: true,
    ),
    const CategoryConfig(
      name: 'Personal',
      icon: Icons.person_outline_rounded,
      color: Colors.teal,
      isDefault: true,
    ),
    const CategoryConfig(
      name: 'Study',
      icon: Icons.menu_book_rounded,
      color: Colors.orange,
      isDefault: true,
    ),
    const CategoryConfig(
      name: 'Health',
      icon: Icons.favorite_border_rounded,
      color: Colors.pink,
      isDefault: true,
    ),
  ];

  static Future<void> loadCustomCategoriesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList('custom_category_names') ?? [];
    for (final name in savedNames) {
      if (!sharedCategories.any(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      )) {
        sharedCategories.add(
          CategoryConfig(
            name: name,
            icon: Icons.folder_special_rounded,
            color: Colors.indigo,
          ),
        );
      }
    }
  }

  static Future<void> addSharedCategory(CategoryConfig config) async {
    if (!sharedCategories.any(
      (c) => c.name.toLowerCase() == config.name.toLowerCase(),
    )) {
      sharedCategories.add(config);
      final prefs = await SharedPreferences.getInstance();
      final customNames = sharedCategories
          .where((c) => !c.isDefault)
          .map((c) => c.name)
          .toList();
      await prefs.setStringList('custom_category_names', customNames);
    }
  }

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<CategoryConfig> get _categories => CategoriesPage.sharedCategories;

  late List<TodoItem> _localTasks;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _localTasks = widget.tasks ??
        [
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
            title: 'Morning 20m stretching',
            isDone: false,
            priority: 'Low',
            category: 'Health',
          ),
        ];

    // Ensure any custom categories present on tasks exist in _categories
    for (final task in _localTasks) {
      if (!_categories.any((c) => c.name == task.category)) {
        _categories.add(
          CategoryConfig(
            name: task.category,
            icon: Icons.label_outline_rounded,
            color: Colors.indigo,
          ),
        );
      }
    }
    CategoriesPage.loadCustomCategoriesFromPrefs().then((_) {
      if (mounted) setState(() {});
    });
  }

  List<TodoItem> _tasksForCategory(String categoryName) {
    if (categoryName == 'All') return _localTasks;
    return _localTasks.where((t) => t.category == categoryName).toList();
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    Color chosenColor = Colors.indigo;
    IconData chosenIcon = Icons.folder_special_rounded;

    final availableColors = [
      Colors.indigo,
      Colors.green,
      Colors.amber.shade800,
      Colors.redAccent,
      Colors.cyan.shade700,
      Colors.purple,
    ];

    final availableIcons = [
      Icons.folder_special_rounded,
      Icons.shopping_bag_outlined,
      Icons.flight_takeoff_rounded,
      Icons.code_rounded,
      Icons.fitness_center_rounded,
      Icons.savings_outlined,
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Category'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'e.g., Shopping, Finance',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: availableColors.map((color) {
                        final selected = chosenColor == color;
                        return GestureDetector(
                          onTap: () =>
                              setDialogState(() => chosenColor = color),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: color,
                            child: selected
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
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Icon',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableIcons.map((icon) {
                        final selected = chosenIcon == icon;
                        return IconButton.filledTonal(
                          onPressed: () =>
                              setDialogState(() => chosenIcon = icon),
                          style: IconButton.styleFrom(
                            backgroundColor: selected
                                ? chosenColor.withValues(alpha: 0.2)
                                : null,
                          ),
                          icon: Icon(
                            icon,
                            color: selected ? chosenColor : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    if (_categories.any(
                      (c) => c.name.toLowerCase() == name.toLowerCase(),
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category already exists.'),
                        ),
                      );
                      return;
                    }
                    final newCat = CategoryConfig(
                      name: name,
                      icon: chosenIcon,
                      color: chosenColor,
                    );
                    CategoriesPage.addSharedCategory(newCat);
                    setState(() {
                      _selectedCategory = name;
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTaskInCategoryDialog() {
    final titleController = TextEditingController();
    String targetCategory =
        _selectedCategory == 'All' ? 'General' : _selectedCategory;
    String priority = 'Medium';

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
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Task to Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: targetCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.name,
                            child: Row(
                              children: [
                                Icon(c.icon, size: 18, color: c.color),
                                const SizedBox(width: 8),
                                Text(c.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => targetCategory = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Low', label: Text('Low')),
                      ButtonSegment(value: 'Medium', label: Text('Medium')),
                      ButtonSegment(value: 'High', label: Text('High')),
                    ],
                    selected: {priority},
                    onSelectionChanged: (val) {
                      setModalState(() => priority = val.first);
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        final text = titleController.text.trim();
                        if (text.isEmpty) return;
                        final newTask = TodoItem(
                          title: text,
                          priority: priority,
                          category: targetCategory,
                        );
                        setState(() {
                          if (widget.onAddTask != null) {
                            widget.onAddTask!(newTask);
                          } else {
                            _localTasks.add(newTask);
                          }
                        });
                        widget.onTasksUpdated?.call();
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.add_task_rounded),
                      label: const Text('Save Task'),
                    ),
                  ),
                ],
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
    final filteredTasks = _tasksForCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'New Category',
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal Category Cards
          SizedBox(
            height: 132,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final catTasks = _tasksForCategory(cat.name);
                final doneCount = catTasks.where((t) => t.isDone).length;
                final progress =
                    catTasks.isEmpty ? 0.0 : doneCount / catTasks.length;
                final isSelected = _selectedCategory == cat.name;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory =
                          isSelected ? 'All' : cat.name;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 152,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cat.color.withValues(alpha: 0.16)
                          : theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? cat.color
                            : theme.dividerColor.withValues(alpha: 0.25),
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(cat.icon, size: 18, color: cat.color),
                            ),
                            Text(
                              '${catTasks.length}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cat.color,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            color: cat.color,
                            backgroundColor: cat.color.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Filter Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('All (${_localTasks.length})'),
                  selected: _selectedCategory == 'All',
                  onSelected: (_) => setState(() => _selectedCategory = 'All'),
                ),
                const SizedBox(width: 6),
                ..._categories.map((cat) {
                  final count = _tasksForCategory(cat.name).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      avatar: Icon(cat.icon, size: 15, color: cat.color),
                      label: Text('${cat.name} ($count)'),
                      selected: _selectedCategory == cat.name,
                      onSelected: (_) {
                        setState(() => _selectedCategory = cat.name);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Tasks in Selected Category
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: 58,
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.45),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks in "$_selectedCategory"',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Add a new task or switch categories above.',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final catConfig = _categories.firstWhere(
                        (c) => c.name == task.category,
                        orElse: () => _categories.first,
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (val) {
                              setState(() {
                                task.isDone = val ?? false;
                              });
                              widget.onTasksUpdated?.call();
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  catConfig.icon,
                                  size: 13,
                                  color: catConfig.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: catConfig.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '• ${task.priority} Priority',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            tooltip: 'Move to Category',
                            icon: const Icon(Icons.drive_file_move_outline),
                            onSelected: (newCat) {
                              setState(() {
                                task.category = newCat;
                              });
                              widget.onTasksUpdated?.call();
                            },
                            itemBuilder: (_) => _categories
                                .map(
                                  (c) => PopupMenuItem(
                                    value: c.name,
                                    child: Row(
                                      children: [
                                        Icon(c.icon, size: 16, color: c.color),
                                        const SizedBox(width: 8),
                                        Text(c.name),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          onTap: () async {
                            final updated =
                                await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => TaskDetailsPage(task: task),
                              ),
                            );
                            if (updated == true) {
                              setState(() {});
                              widget.onTasksUpdated?.call();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskInCategoryDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
