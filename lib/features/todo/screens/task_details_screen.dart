import 'package:flutter/material.dart';
import 'package:merge_app/features/todo/utils/colors.dart';

class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final DateTime? dueDate; // NEW

  const TaskDetailScreen({
    super.key,
    required this.title,
    required this.description,
    this.dueDate,
  });

  String getRemainingTime() {
    if (dueDate == null) return '';
    final now = DateTime.now();
    final diff = dueDate!.difference(now);

    if (diff.inDays > 0) {
      return 'Due in ${diff.inDays} days';
    } else if (diff.inHours > 0) {
      return 'Due in ${diff.inHours} hours';
    } else if (diff.inMinutes > 0) {
      return 'Due in ${diff.inMinutes} minutes';
    } else {
      return 'Overdue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: secondaryColor, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: secondaryColor,
              size: 40,
            ),
            onPressed: () {
              // Handle delete
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Timer and Time left
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: secondaryColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  getRemainingTime(), // UPDATED
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.close, color: Colors.black, size: 20),
              ],
            ),
            const Divider(color: Colors.grey),

            const SizedBox(height: 20),

            // User Avatar
            Row(
              children: [
                const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.cyan,
                  child: const Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Shreesha',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            const SizedBox(height: 20),

            // Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes_outlined, color: Colors.black, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),

            const SizedBox(height: 20),

            // Select Photo
            Row(
              children: [
                const Icon(Icons.image_outlined, color: Colors.black, size: 24),
                const SizedBox(width: 10),
                const Text(
                  "Select photo",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),

            // Subtask
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Subtask",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Handle Update
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Update",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
