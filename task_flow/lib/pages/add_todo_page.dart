import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late final TextEditingController _controller;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
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
