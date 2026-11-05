import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import 'task_details_page.dart';

class SearchPage extends StatefulWidget {
  final List<TodoItem> tasks;
  final Function(TodoItem task)? onToggleTask;
  final Function(int index)? onDeleteTask;

  const SearchPage({
    super.key,
    required this.tasks,
    this.onToggleTask,
    this.onDeleteTask,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All'; // 'All', 'Active', 'Completed'
  String _selectedPriority = 'All'; // 'All', 'High', 'Medium', 'Low'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TodoItem> get _filteredTasks {
    return widget.tasks.where((task) {
      // 1. Text filter
      final matchesQuery = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Status filter
      final matchesStatus = switch (_selectedStatus) {
        'Active' => !task.isDone,
        'Completed' => task.isDone,
        _ => true,
      };

      // 3. Priority filter
      final matchesPriority = switch (_selectedPriority) {
        'High' => task.priority == 'High',
        'Medium' => task.priority == 'Medium',
        'Low' => task.priority == 'Low',
        _ => true,
      };

      return matchesQuery && matchesStatus && matchesPriority;
    }).toList();
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
    final results = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            setState(() => _searchQuery = val.trim());
          },
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Status filters
                  const Text(
                    'Status: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  ...['All', 'Active', 'Completed'].map((status) {
                    final isSelected = _selectedStatus == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedStatus = status);
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  Container(
                    height: 24,
                    width: 1,
                    color: theme.dividerColor,
                  ),
                  const SizedBox(width: 12),
                  // Priority filters
                  const Text(
                    'Priority: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  ...['All', 'High', 'Medium', 'Low'].map((priority) {
                    final isSelected = _selectedPriority == priority;
                    final pColor = priority == 'All'
                        ? theme.colorScheme.primary
                        : _getPriorityColor(priority);

                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        avatar: priority != 'All'
                            ? Icon(Icons.flag, size: 14, color: pColor)
                            : null,
                        label: Text(priority),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedPriority = priority);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Results Count & Reset row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${results.length} ${results.length == 1 ? "task" : "tasks"} found',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (_searchQuery.isNotEmpty ||
                    _selectedStatus != 'All' ||
                    _selectedPriority != 'All')
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _selectedStatus = 'All';
                        _selectedPriority = 'All';
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Text(
                        'Reset Filters',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: theme.colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No matching tasks found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try adjusting your keywords or filters',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemBuilder: (context, index) {
                      final task = results[index];
                      final pColor = _getPriorityColor(task.priority);

                      return Card(
                        elevation: 1.5,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: task.isDone
                                ? Colors.transparent
                                : pColor.withValues(alpha: 0.25),
                            width: 1,
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
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: task.isDone,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      task.isDone = val ?? false;
                                    });
                                    widget.onToggleTask?.call(task);
                                  },
                                ),
                                const SizedBox(width: 8),
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
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: pColor.withValues(alpha: 0.12),
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
                                                fontWeight: FontWeight.bold,
                                                color: pColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

