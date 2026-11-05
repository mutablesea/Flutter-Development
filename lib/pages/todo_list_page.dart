import 'package:flutter/material.dart';

// Relative import: both files live in the same 'pages/' folder
// First page
import 'add_todo_page.dart';

class TodoItem {
  final String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Local state holding our list of todos
  final List<TodoItem> _tasks = [
    TodoItem(title: 'Learn Dart fundamentals', isDone: true),
    TodoItem(title: 'Build multi-page UI in Flutter'),
  ];

  Future<void> _navigateAndAddTask() async {
    // Await the value returned from Navigator.pop() on the Add page
    final newTaskTitle = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );

    // If the user submitted a valid task, append it to state
    if (newTaskTitle != null && newTaskTitle.isNotEmpty) {
      setState(() {
        _tasks.add(TodoItem(title: newTaskTitle));
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Flow')),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet. Tap + to add one!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (bool? value) {
                      setState(() {
                        task.isDone = value ?? false;
                      });
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.isDone ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
