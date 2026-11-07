import 'package:flutter/material.dart';

class HabitItem {
  final String id;
  String title;
  String subtitle;
  IconData icon;
  Color color;
  // 7 booleans representing Mon..Sun check-ins for the current week
  List<bool> weekCheckIns;

  HabitItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.weekCheckIns,
  });

  int get completedDaysCount => weekCheckIns.where((done) => done).length;

  int get currentStreak {
    int streak = 0;
    for (int i = weekCheckIns.length - 1; i >= 0; i--) {
      if (weekCheckIns[i]) {
        streak++;
      } else if (streak > 0) {
        break;
      }
    }
    return streak;
  }
}

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  static const List<String> _dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<HabitItem> _habits = [
    HabitItem(
      id: 'h1',
      title: 'Code in Flutter & Dart',
      subtitle: 'At least 45 mins daily',
      icon: Icons.code_rounded,
      color: Colors.deepPurple,
      weekCheckIns: [true, true, true, true, true, false, false],
    ),
    HabitItem(
      id: 'h2',
      title: 'Drink 8 Glasses of Water',
      subtitle: 'Stay hydrated all day',
      icon: Icons.water_drop_outlined,
      color: Colors.blue,
      weekCheckIns: [true, true, false, true, true, true, false],
    ),
    HabitItem(
      id: 'h3',
      title: 'Read 15 Pages',
      subtitle: 'Tech or personal growth book',
      icon: Icons.menu_book_rounded,
      color: Colors.teal,
      weekCheckIns: [true, false, true, true, false, true, false],
    ),
    HabitItem(
      id: 'h4',
      title: '30m Exercise / Walk',
      subtitle: 'Keep body & mind energized',
      icon: Icons.fitness_center_rounded,
      color: Colors.orange,
      weekCheckIns: [false, true, true, true, true, false, false],
    ),
  ];

  int get _todayIndex => (DateTime.now().weekday - 1).clamp(0, 6);

  void _showAddHabitSheet() {
    final titleCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController(text: 'Daily habit goal');
    Color chosenColor = Colors.deepPurple;
    IconData chosenIcon = Icons.track_changes_rounded;

    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.green,
    ];

    final icons = [
      Icons.track_changes_rounded,
      Icons.code_rounded,
      Icons.fitness_center_rounded,
      Icons.menu_book_rounded,
      Icons.self_improvement_rounded,
      Icons.water_drop_outlined,
    ];

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
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Habit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleCtrl,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Habit Name',
                      hintText: 'e.g., Morning Meditation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: subtitleCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Goal / Target Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Accent Color',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: colors.map((c) {
                      return GestureDetector(
                        onTap: () => setModalState(() => chosenColor = c),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: c,
                          child: chosenColor == c
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
                  const SizedBox(height: 14),
                  const Text(
                    'Icon',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: icons.map((ic) {
                      final selected = chosenIcon == ic;
                      return IconButton.filledTonal(
                        onPressed: () => setModalState(() => chosenIcon = ic),
                        style: IconButton.styleFrom(
                          backgroundColor: selected
                              ? chosenColor.withValues(alpha: 0.2)
                              : null,
                        ),
                        icon: Icon(
                          ic,
                          color: selected ? chosenColor : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) return;
                        setState(() {
                          _habits.add(
                            HabitItem(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              title: title,
                              subtitle: subtitleCtrl.text.trim().isEmpty
                                  ? 'Daily check-in'
                                  : subtitleCtrl.text.trim(),
                              icon: chosenIcon,
                              color: chosenColor,
                              weekCheckIns: List<bool>.filled(7, false),
                            ),
                          );
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Start Tracking Habit'),
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

  void _resetWeek() {
    setState(() {
      for (final h in _habits) {
        h.weekCheckIns = List<bool>.filled(7, false);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weekly habit check-ins reset.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayIdx = _todayIndex;
    final completedToday =
        _habits.where((h) => h.weekCheckIns[todayIdx]).length;
    final totalPossibleChecks = _habits.length * 7;
    final totalDoneChecks =
        _habits.fold<int>(0, (sum, h) => sum + h.completedDaysCount);
    final weeklyRate = totalPossibleChecks == 0
        ? 0
        : ((totalDoneChecks / totalPossibleChecks) * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          TextButton.icon(
            onPressed: _resetWeek,
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Reset Week'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // Summary Banner
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  label: 'Today (${_dayLabels[todayIdx]})',
                  value: '$completedToday / ${_habits.length}',
                  icon: Icons.today_rounded,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  label: 'Weekly Rate',
                  value: '$weeklyRate%',
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Habit Cards
          ..._habits.map((habit) {
            final weeklyProgress = habit.completedDaysCount / 7.0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: habit.color.withValues(alpha: 0.3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              habit.color.withValues(alpha: 0.14),
                          child: Icon(habit.icon, color: habit.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                habit.subtitle,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: habit.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 15,
                                color: habit.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${habit.currentStreak}d',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  color: habit.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 7-Day Interactive Check-In Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (dayIndex) {
                        final isDone = habit.weekCheckIns[dayIndex];
                        final isToday = dayIndex == todayIdx;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              habit.weekCheckIns[dayIndex] = !isDone;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                _dayLabels[dayIndex],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isToday
                                      ? habit.color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? habit.color
                                      : habit.color.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isToday
                                        ? habit.color
                                        : habit.color.withValues(alpha: 0.25),
                                    width: isToday ? 1.8 : 1,
                                  ),
                                ),
                                child: Icon(
                                  isDone
                                      ? Icons.check_rounded
                                      : Icons.circle_outlined,
                                  size: isDone ? 20 : 12,
                                  color: isDone
                                      ? Colors.white
                                      : habit.color.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: weeklyProgress,
                              minHeight: 6,
                              color: habit.color,
                              backgroundColor:
                                  habit.color.withValues(alpha: 0.14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${habit.completedDaysCount}/7 days',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHabitSheet,
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

