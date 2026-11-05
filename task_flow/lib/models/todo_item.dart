class TodoItem {
  String title;
  bool isDone;
  String priority; // 'Low', 'Medium', 'High'
  DateTime? createdAt;

  TodoItem({
    required this.title,
    this.isDone = false,
    this.priority = 'Medium',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TodoItem copyWith({
    String? title,
    bool? isDone,
    String? priority,
    DateTime? createdAt,
  }) {
    return TodoItem(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

