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
    notifyListeners();
  }

  Map<String, double> get weeklySummary {
    return {
      'Monday': 2,
      'Tuesday': 3,
      'Wednesday': 1,
      'Thursday': 4,
      'Friday': 2,
      'Saturday': 5,
      'Sunday': 3,
    };
  }
}
