import 'package:flutter/material.dart';

class RoutineStep {
  String title;
  bool isCompleted;

  RoutineStep({required this.title, this.isCompleted = false});
}

class RoutineItem {
  final String id;
  String title;
  String timeWindow;
  IconData icon;
  Color color;
  List<RoutineStep> steps;

  RoutineItem({
    required this.id,
    required this.title,
    required this.timeWindow,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({super.key});

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  final List<RoutineItem> _routines = [
    RoutineItem(
      id: 'r1',
      title: 'Morning Kickoff Routine',
      timeWindow: '07:00 AM – 08:30 AM',
      icon: Icons.wb_sunny_rounded,
      color: Colors.orange,
      steps: [
        RoutineStep(title: 'Drink a glass of water', isCompleted: true),
        RoutineStep(title: '15 min stretching & mobility', isCompleted: true),
        RoutineStep(
          title: 'Review Today\'s Top 3 High Priority Tasks',
          isCompleted: false,
        ),
      ],
    ),
    RoutineItem(
      id: 'r2',
      title: 'Deep Work Coding Block',
      timeWindow: '10:00 AM – 12:30 PM',
      icon: Icons.code_rounded,
      color: Colors.deepPurple,
      steps: [
        RoutineStep(title: 'Silence notifications & open IDE', isCompleted: true),
        RoutineStep(title: 'Run 2 Pomodoro focus cycles', isCompleted: false),
        RoutineStep(title: 'Commit & push clean changes to Git', isCompleted: false),
      ],
    ),
    RoutineItem(
      id: 'r3',
      title: 'Evening Wind-Down',
      timeWindow: '09:30 PM – 10:30 PM',
      icon: Icons.nights_stay_rounded,
      color: Colors.indigo,
      steps: [
        RoutineStep(title: 'Clear completed tasks from queue', isCompleted: false),
        RoutineStep(title: 'Plan tomorrow\'s calendar schedule', isCompleted: false),
        RoutineStep(title: 'Read 10 pages before sleep', isCompleted: false),
      ],
    ),
  ];

  void _resetAllRoutines() {
    setState(() {
      for (final r in _routines) {
        for (final s in r.steps) {
          s.isCompleted = false;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All daily routines reset for a fresh start!')),
    );
  }

  void _showAddStepDialog(RoutineItem routine) {
    final stepCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Step to ${routine.title}'),
        content: TextField(
          controller: stepCtrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Step Description',
            hintText: 'e.g., 10 minutes meditation',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = stepCtrl.text.trim();
              if (text.isEmpty) return;
              setState(() {
                routine.steps.add(RoutineStep(title: text));
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Step'),
          ),
        ],
      ),
    );
  }

  void _showCreateRoutineSheet() {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '06:00 PM – 07:00 PM');
    final firstStepCtrl = TextEditingController();
    Color chosenColor = Colors.teal;

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
                    'Create New Routine',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      hintText: 'e.g., Afternoon Fitness Routine',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Time Window',
                      prefixIcon: Icon(Icons.schedule_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: firstStepCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'First Routine Step',
                      hintText: 'e.g., Warm up for 5 minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    children: [
                      Colors.teal,
                      Colors.orange,
                      Colors.deepPurple,
                      Colors.indigo,
                      Colors.pink,
                    ].map((c) {
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
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) return;
                        final firstStep = firstStepCtrl.text.trim();
                        setState(() {
                          _routines.add(
                            RoutineItem(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              title: title,
                              timeWindow: timeCtrl.text.trim().isEmpty
                                  ? 'Anytime'
                                  : timeCtrl.text.trim(),
                              icon: Icons.repeat_rounded,
                              color: chosenColor,
                              steps: [
                                if (firstStep.isNotEmpty)
                                  RoutineStep(title: firstStep)
                                else
                                  RoutineStep(title: 'Complete routine check-in'),
                              ],
                            ),
                          );
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Routine'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSteps =
        _routines.fold<int>(0, (sum, r) => sum + r.steps.length);
    final completedSteps = _routines.fold<int>(
      0,
      (sum, r) => sum + r.steps.where((s) => s.isCompleted).length,
    );
    final overallProgress =
        totalSteps == 0 ? 0.0 : completedSteps / totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Routines'),
        actions: [
          TextButton.icon(
            onPressed: _resetAllRoutines,
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Reset Day'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // Overall Daily Routine Progress Banner
          Card(
            elevation: 0,
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Routine Flow',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$completedSteps / $totalSteps steps done',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: overallProgress,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Routine Cards
          ..._routines.map((routine) {
            final doneCount =
                routine.steps.where((s) => s.isCompleted).length;
            final progress = routine.steps.isEmpty
                ? 0.0
                : doneCount / routine.steps.length;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: routine.color.withValues(alpha: 0.3),
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
                              routine.color.withValues(alpha: 0.15),
                          child: Icon(routine.icon, color: routine.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routine.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                routine.timeWindow,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_task_rounded, size: 20),
                          tooltip: 'Add Step',
                          onPressed: () => _showAddStepDialog(routine),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        color: routine.color,
                        backgroundColor:
                            routine.color.withValues(alpha: 0.15),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...routine.steps.map((step) {
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: routine.color,
                        value: step.isCompleted,
                        onChanged: (val) {
                          setState(() => step.isCompleted = val ?? false);
                        },
                        title: Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: step.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateRoutineSheet,
        icon: const Icon(Icons.add),
        label: const Text('New Routine'),
      ),
    );
  }
}

