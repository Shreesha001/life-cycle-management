import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/todo/screens/task_details_screen.dart';

class HomeCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final bool showConfirmation;
  final ValueChanged<bool> onChanged;

  const HomeCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.showConfirmation,
    required this.onChanged, required isHighPriority,
  });

  String getRemainingTime() {
    final now = DateTime.now();
    final diff = dueDate.difference(now);

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => TaskDetailScreen(
                    taskId: taskId,
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    showConfirmation: showConfirmation,
                  ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 151, 212, 210),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onChanged(!isCompleted);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 55.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: isCompleted ? secondaryColor : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isCompleted ? secondaryColor : Colors.grey.shade400,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      color: isCompleted ? Colors.black : Colors.transparent,
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
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                          decoration:
                              isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          color: textSecondaryColor,
                          decoration:
                              isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        getRemainingTime(),
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          color: errorColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
