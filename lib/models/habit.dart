import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  List<DateTime> completionDates;

  Habit({
    required this.name,
    this.isCompleted = false,
    List<DateTime>? completionDates,
  }) : completionDates = completionDates ?? [];
}
