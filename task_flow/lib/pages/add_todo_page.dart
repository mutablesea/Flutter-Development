import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import 'categories_page.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late final TextEditingController _controller;
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'General';

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    CategoriesPage.loadCustomCategoriesFromPrefs().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitTask() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      // Pop the screen and return the newly created TodoItem
      final newItem = TodoItem(
        title: text,
        priority: _selectedPriority,
        category: _selectedCategory,
      );
      Navigator.of(context).pop(newItem);
    }
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

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g., Prepare quarterly presentation',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitTask(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Priority',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Assign importance to help organize your day',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'Low',
                  icon: Icon(Icons.flag, size: 16, color: _getPriorityColor('Low')),
                  label: const Text('Low'),
                ),
                ButtonSegment(
                  value: 'Medium',
                  icon: Icon(Icons.flag, size: 16, color: _getPriorityColor('Medium')),
                  label: const Text('Medium'),
                ),
                ButtonSegment(
                  value: 'High',
                  icon: Icon(Icons.flag, size: 16, color: _getPriorityColor('High')),
                  label: const Text('High'),
                ),
              ],
              selected: {_selectedPriority},
              onSelectionChanged: (newSelection) {
                setState(() => _selectedPriority = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ...CategoriesPage.sharedCategories.map((catConfig) {
                  final cat = catConfig.name;
                  return ChoiceChip(
                    avatar: Icon(
                      catConfig.icon,
                      size: 15,
                      color: catConfig.color,
                    ),
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  );
                }),
                ActionChip(
                  avatar: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('+ New Category'),
                  onPressed: () async {
                    final newCatCtrl = TextEditingController();
                    final createdName = await showDialog<String>(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Add New Category'),
                        content: TextField(
                          controller: newCatCtrl,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                            hintText: 'e.g., Shopping, Fitness',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              final val = newCatCtrl.text.trim();
                              if (val.isNotEmpty) {
                                Navigator.of(dialogCtx).pop(val);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                    if (createdName != null && createdName.isNotEmpty) {
                      await CategoriesPage.addSharedCategory(
                        CategoryConfig(
                          name: createdName,
                          icon: Icons.folder_special_rounded,
                          color: Colors.indigo,
                        ),
                      );
                      setState(() => _selectedCategory = createdName);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitTask,
                icon: const Icon(Icons.add_task),
                label: const Text(
                  'Save Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
