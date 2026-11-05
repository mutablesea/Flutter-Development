import 'package:flutter/material.dart';

import 'todo_list_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final TodoItem task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late final TextEditingController _titleController;
  late String _priority;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _priority = widget.task.priority;
    _isDone = widget.task.isDone;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedTitle = _titleController.text.trim();
    if (updatedTitle.isNotEmpty) {
      widget.task.title = updatedTitle;
      widget.task.priority = _priority;
      widget.task.isDone = _isDone;
      Navigator.of(context).pop(true); // Return true to trigger state refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveChanges),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Priority Level',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Low', label: Text('Low')),
                ButtonSegment(value: 'Medium', label: Text('Medium')),
                ButtonSegment(value: 'High', label: Text('High')),
              ],
              selected: {_priority},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _priority = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Mark as Completed'),
              value: _isDone,
              onChanged: (val) {
                setState(() {
                  _isDone = val;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Update Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
