import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  late final TextEditingController _controller;

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
      // Pop the screen and return the string back to the caller
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'e.g., Buy groceries',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitTask(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submitTask,
                icon: const Icon(Icons.add),
                label: const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
