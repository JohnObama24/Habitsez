import 'package:flutter/foundation.dart';
import 'package:habitsez/models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(name: 'Touch a grass'),
    Habit(name: 'Drink 2 liters of water'),
  ];

  List<Habit> get habits => _habits;

  void addHabit(String name) {
    _habits.add(Habit(name: name));
    notifyListeners();
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
}
