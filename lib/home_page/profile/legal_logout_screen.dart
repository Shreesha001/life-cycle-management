import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/auth_screens/login_screen.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';

class LegalLogoutScreen extends StatelessWidget {
  const LegalLogoutScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Legal & Logout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: whiteColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legal & Account',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildLegalTile(
              context,
              title: 'Privacy Policy',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Privacy Policy (TBD)',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
            _buildLegalTile(
              context,
              title: 'Terms & Conditions',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Terms & Conditions (TBD)',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
            _buildLegalTile(
              context,
              title: 'Delete Account',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Delete Account (TBD)',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: whiteColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Logout', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: secondaryColor, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: whiteColor.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
