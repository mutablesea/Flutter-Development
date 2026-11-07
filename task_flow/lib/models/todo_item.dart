class TodoItem {
  String title;
  bool isDone;
  String priority; // 'Low', 'Medium', 'High'
  String category; // e.g., 'General', 'Work', 'Personal', 'Study', 'Health'
  DateTime? createdAt;
  DateTime? dueDate;
  DateTime? deletedAt;

  TodoItem({
    required this.title,
    this.isDone = false,
    this.priority = 'Medium',
    this.category = 'General',
    DateTime? createdAt,
    this.dueDate,
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TodoItem copyWith({
    String? title,
    bool? isDone,
    String? priority,
    String? category,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? deletedAt,
  }) {
    return TodoItem(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
