import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Help & Support',
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
              'Support Options',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSupportTile(
              context,
              title: 'FAQs',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('FAQs (TBD)', style: GoogleFonts.poppins()),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
            _buildSupportTile(
              context,
              title: 'Contact Support',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Contact Support (TBD)',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
            _buildSupportTile(
              context,
              title: 'Report a Bug',
              onTap:
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Report a Bug (TBD)',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile(
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
