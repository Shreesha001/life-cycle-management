import 'package:flutter/material.dart';
import 'package:merge_app/features/todo/screens/task_details_screen.dart';
import 'package:merge_app/features/todo/utils/colors.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final DateTime? dueDate; // New field

  const HomeCard({
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onChanged,
    this.dueDate, // Optional
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => TaskDetailScreen(
                  title: title,
                  description: description,
                  dueDate: dueDate,
                ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: primarylightColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onChanged(!isChecked);
                  },
                  child: Container(
                    width: 55.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: isChecked ? secondaryColor : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: isChecked ? Colors.black : Colors.transparent,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          decoration:
                              isChecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          decoration:
                              isChecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      if (dueDate != null) ...[
                        const SizedBox(height: 6.0),
                        Text(
                          getRemainingTime(),
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
