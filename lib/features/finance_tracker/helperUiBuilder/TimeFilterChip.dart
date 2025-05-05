import 'package:merge_app/features/finance_tracker/core/constants/app_constants.dart';
import 'package:merge_app/features/finance_tracker/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TimeFilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const TimeFilterChip({required this.label, this.selected = false, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
