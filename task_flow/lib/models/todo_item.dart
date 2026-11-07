class TodoItem {
  String title;
  bool isDone;
  String priority; // 'Low', 'Medium', 'High'
  String category; // e.g., 'General', 'Work', 'Personal', 'Study', 'Health'
  List<String> tags;
  DateTime? createdAt;
  DateTime? dueDate;
  DateTime? deletedAt;

  TodoItem({
    required this.title,
    this.isDone = false,
    this.priority = 'Medium',
    this.category = 'General',
    List<String>? tags,
    DateTime? createdAt,
    this.dueDate,
    this.deletedAt,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  TodoItem copyWith({
    String? title,
    bool? isDone,
    String? priority,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? deletedAt,
  }) {
    return TodoItem(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? List<String>.from(this.tags),
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
