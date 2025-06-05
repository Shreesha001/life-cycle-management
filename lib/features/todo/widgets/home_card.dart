import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:merge_app/core/colors.dart';

class HomeCard extends StatelessWidget {
  final String taskId;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;
  final bool showConfirmation;
  final ValueChanged<bool?> onChanged;
  final bool? isHighPriority;

  const HomeCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    required this.showConfirmation,
    required this.onChanged,
    required this.isHighPriority,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15), // Light outline
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Subtle shadow
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Task Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
  text: TextSpan(
    style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryColor,
    ),
    children: [
      TextSpan(text: title),
      if (isHighPriority == true)
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
  ),
),

                  const SizedBox(height: 4),
                  Text(
                    'Until ${DateFormat('d MMM').format(dueDate)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Circular checkbox
            GestureDetector(
              onTap: () {
                onChanged(!isCompleted);
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? secondaryColor : Colors.grey,
                    width: 2,
                  ),
                  color: isCompleted ? secondaryColor : Colors.transparent,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
