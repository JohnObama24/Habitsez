import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../models/habit.dart';
import 'add_habit_page.dart';
import 'progress_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Habit>>(
      valueListenable: Hive.box<Habit>('habits').listenable(),
      builder: (context, box, _) {
        final habits = box.values.toList().cast<Habit>();

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Smart Habits',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: Colors.grey[200]),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.track_changes),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProgressPage(),
                    ),
                  );
                },
                tooltip: 'View Progress',
              ),
            ],
          ),
          body: habits.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: () async {
                    // Simulate refresh delay
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return _buildHabitCard(habit, context);
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddHabitPage()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Habit'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.teal.withAlpha(20).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.track_changes, size: 64, color: Colors.teal[400]),
          ),
          const SizedBox(height: 24),
          const Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building better habits today!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddHabitPage()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Habit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Habit habit, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: habit.isCompleted ? Colors.teal : Colors.grey[300]!,
              width: 2,
            ),
            color: habit.isCompleted ? Colors.teal : Colors.transparent,
          ),
          child: habit.isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: habit.isCompleted ? Colors.grey[500] : Colors.black87,
            decoration: habit.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          habit.isCompleted ? 'Completed today' : 'Tap to complete',
          style: TextStyle(
            fontSize: 12,
            color: habit.isCompleted ? Colors.teal[300] : Colors.grey[500],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteDialog(context, habit);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
          ),
        ),
        onTap: () {
          habit.isCompleted = !habit.isCompleted;
          habit.save();
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              habit.delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${habit.name} deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Skeleton Loading Widget
class HabitSkeleton extends StatelessWidget {
  const HabitSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              subtitle: Container(
                height: 12,
                width: 100,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              trailing: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
