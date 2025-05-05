import 'package:flutter/material.dart';
import 'package:merge_app/features/password_manager/core/theme/theme.dart';

class AddNewPasswordScreen extends StatefulWidget {
  const AddNewPasswordScreen({super.key});

  @override
  State<AddNewPasswordScreen> createState() => _AddNewPasswordScreenState();
}

class _AddNewPasswordScreenState extends State<AddNewPasswordScreen> {
  final TextEditingController siteController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Add new password",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Site"),
            _buildTextField(controller: siteController, hint: "example.com"),
            const SizedBox(height: 16),
            _buildLabel("Username"),
            _buildTextField(controller: usernameController),
            const SizedBox(height: 16),
            _buildLabel("Password"),
            _buildTextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryColor,
                ),
                onPressed:
                    () => setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    }),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Make sure you're saving your current password for this site",
              style: TextStyle(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            _buildLabel("Note"),
            _buildTextField(controller: noteController, maxLines: 5),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.secondaryColor,
                    ), // Border color
                    foregroundColor: AppColors.primaryColor, // Text/icon color
                  ),
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Save logic goes here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    foregroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: Colors.grey.shade800,
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                    ), // Optional border
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
  }) => TextField(
    controller: controller,
    obscureText: obscureText,
    maxLines: maxLines,
    style: const TextStyle(color: AppColors.primaryColor),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.primaryColor.withOpacity(0.3)),
      filled: true,
      fillColor: AppColors.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      suffixIcon: suffixIcon,
    ),
  );
}
