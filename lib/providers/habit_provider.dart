import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:habitsez/models/habit.dart';
import 'package:habitsez/services/notification_service.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(name: 'Touch a grass'),
    Habit(name: 'Drink 2 liters of water'),
  ];

  late Timer _habitCheckTimer;

  HabitProvider() {
    
    _habitCheckTimer = Timer.periodic(const Duration(minutes: 30), (timer) async {
      if (hasIncompleteHabitsToday()) {
        await NotificationService().showReminderNotification();
      }
    });
  }

  List<Habit> get habits => _habits;

  void addHabit(String name) {
    _habits.add(Habit(name: name));
    notifyListeners();
  }

  bool hasIncompleteHabitsToday() {
    final today = DateTime.now();
    return _habits.any((habit) {
      final doneToday = habit.completionDates.any((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);
      return !doneToday;
    });
  }

  int get GetCurrentStreak {
    final today = DateTime.now();
    int streak = 0;

    DateTime dateToCek = DateTime(today.year, today.month, today.day);

    while (true) {
      bool found = _habits.any((habit) {
        return habit.completionDates.any((date) {
          final d = DateTime(date.year, date.month, date.day);
          return d == dateToCek;
        });
      });

      if (found) {
        streak++;
        dateToCek = dateToCek.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  void toogleHabit(Habit habit) {
    habit.isCompleted = !habit.isCompleted;

    final today = DateTime.now();

    if (habit.isCompleted) {
      habit.completionDates.add(today);
    } else {
      habit.completionDates.removeWhere((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);
    }

    notifyListeners();
  }

  Map<String, double> get weeklySummary {
    final Map<String, double> summary = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (var habit in _habits) {
      for (var date in habit.completionDates) {
        if (date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            date.isBefore(now.add(const Duration(days: 1)))) {
          final weekday = _weekdayToString(date.weekday);
          summary[weekday] = (summary[weekday] ?? 0) + 1;
        }
      }
    }

    return summary;
  }

  String _weekdayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _habitCheckTimer.cancel(); // 🧼 Stop timer saat provider dibuang
    super.dispose();
  }
}
