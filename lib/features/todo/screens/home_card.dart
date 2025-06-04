import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';

class HomeCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isHighPriority;
  final bool showConfirmation;
  final ValueChanged<bool?>? onChanged;

  const HomeCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.isHighPriority,
    required this.showConfirmation,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          activeColor: secondaryColor,
          onChanged: onChanged,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted ? Colors.grey : textPrimaryColor,
                ),
              ),
            ),
            if (isHighPriority)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'High',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: GoogleFonts.poppins(
                color: isCompleted ? Colors.grey : textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
              style: GoogleFonts.poppins(
                color: isHighPriority ? errorColor : textPrimaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
