import 'dart:async';
import 'package:flutter/material.dart';

import '../models/todo_item.dart';

enum PomodoroMode {
  focus('Focus Session', 25 * 60, Colors.deepPurple, Icons.bolt_rounded),
  shortBreak('Short Break', 5 * 60, Colors.teal, Icons.coffee_rounded),
  longBreak('Long Break', 15 * 60, Colors.indigo, Icons.self_improvement_rounded);

  final String label;
  final int defaultSeconds;
  final Color color;
  final IconData icon;

  const PomodoroMode(
    this.label,
    this.defaultSeconds,
    this.color,
    this.icon,
  );
}

class PomodoroPage extends StatefulWidget {
  final List<TodoItem>? tasks;

  const PomodoroPage({super.key, this.tasks});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  PomodoroMode _mode = PomodoroMode.focus;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;

  int _completedCycles = 2;
  int _totalFocusMinutes = 50;
  String _selectedTaskTitle = 'Build multi-page UI in Flutter';

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _mode.defaultSeconds;
    if (widget.tasks != null && widget.tasks!.isNotEmpty) {
      final firstActive = widget.tasks!.firstWhere(
        (t) => !t.isDone,
        orElse: () => widget.tasks!.first,
      );
      _selectedTaskTitle = firstActive.title;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _switchMode(PomodoroMode newMode) {
    _timer?.cancel();
    setState(() {
      _mode = newMode;
      _remainingSeconds = newMode.defaultSeconds;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
          _onSessionCompleted();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _mode.defaultSeconds;
    });
  }

  void _onSessionCompleted() {
    setState(() {
      _isRunning = false;
      if (_mode == PomodoroMode.focus) {
        _completedCycles++;
        _totalFocusMinutes += 25;
        _mode = (_completedCycles % 4 == 0)
            ? PomodoroMode.longBreak
            : PomodoroMode.shortBreak;
      } else {
        _mode = PomodoroMode.focus;
      }
      _remainingSeconds = _mode.defaultSeconds;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session complete! Switched to ${_mode.label}.'),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _pickFocusTask() {
    final taskOptions = widget.tasks?.map((t) => t.title).toList() ??
        [
          'Build multi-page UI in Flutter',
          'Review settings and dark mode theme',
          'Prepare sprint release notes',
          'Deep work coding block',
        ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Task to Focus On',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...taskOptions.map((title) {
                  return ListTile(
                    leading: Icon(
                      Icons.radio_button_checked_rounded,
                      color: title == _selectedTaskTitle
                          ? _mode.color
                          : Colors.grey,
                    ),
                    title: Text(title),
                    onTap: () {
                      setState(() => _selectedTaskTitle = title);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        1.0 - (_remainingSeconds / _mode.defaultSeconds).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Focus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            tooltip: 'Skip Session',
            onPressed: _onSessionCompleted,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mode Selector
            SegmentedButton<PomodoroMode>(
              segments: PomodoroMode.values
                  .map(
                    (m) => ButtonSegment<PomodoroMode>(
                      value: m,
                      icon: Icon(m.icon, size: 16),
                      label: Text(
                        m == PomodoroMode.focus
                            ? 'Focus'
                            : m == PomodoroMode.shortBreak
                                ? 'Short'
                                : 'Long',
                      ),
                    ),
                  )
                  .toList(),
              selected: {_mode},
              onSelectionChanged: (selection) => _switchMode(selection.first),
            ),

            const SizedBox(height: 20),

            // Current Focus Task Card
            Card(
              elevation: 0,
              color: _mode.color.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: _mode.color.withValues(alpha: 0.3)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _mode.color,
                  child: Icon(_mode.icon, color: Colors.white, size: 20),
                ),
                title: const Text(
                  'Focusing on',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _selectedTaskTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: TextButton(
                  onPressed: _pickFocusTask,
                  child: const Text('Change'),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Circular Timer Ring
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    height: 230,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      color: _mode.color,
                      backgroundColor: _mode.color.withValues(alpha: 0.15),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _mode.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _mode.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _mode.color,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isRunning ? 'Stay focused...' : 'Ready to start',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Timer Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(110, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 14),
                FilledButton.icon(
                  onPressed: _toggleTimer,
                  style: FilledButton.styleFrom(
                    backgroundColor: _mode.color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(
                    _isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    _isRunning ? 'Pause' : 'Start Timer',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Today's Focus Summary
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, color: _mode.color),
                          const SizedBox(height: 6),
                          Text(
                            '$_completedCycles',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cycles Completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              color: Colors.orange),
                          const SizedBox(height: 6),
                          Text(
                            '$_totalFocusMinutes min',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Focus Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
