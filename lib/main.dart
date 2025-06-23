// main.dart
import 'package:flutter/material.dart';
import 'package:habitsez/providers/habit_provider.dart';
import 'package:habitsez/screens/splash_screen.dart'; // Import splash screen
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:habitsez/models/habit.dart';
import 'services/notification_service.dart' show NotificationService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');
  await NotificationService().init();
  await NotificationService().scheduleDaily8pmReminder();

  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: const Habitsez(),
    ),
  );
}

class Habitsez extends StatelessWidget {
  const Habitsez({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitsez',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          const SplashScreen(), 
    );
  }
}
