import 'package:merge_app/features/document_management/core/constants/app_constants.dart';
import 'package:merge_app/features/document_management/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableButton({required this.text, required this.onPressed, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: AppConstants.spacing16,
          horizontal: AppConstants.spacing24,
        ),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.spacing8),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: AppColors.backgroundColor)),
    );
  }
}

class ReusableInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const ReusableInputField({
    required this.controller,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
