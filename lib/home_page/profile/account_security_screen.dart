import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  _AccountSecurityScreenState createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Account & Security',
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
              'Security Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Change Password', style: GoogleFonts.poppins()),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secondaryColor,
                size: 16,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Change password (TBD)',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: secondaryColor,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: Text('Biometric Login', style: GoogleFonts.poppins()),
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
              activeColor: primaryColor,
              inactiveTrackColor: textSecondaryColor.withOpacity(0.3),
            ),
            SwitchListTile(
              title: Text(
                'Two-Factor Authentication',
                style: GoogleFonts.poppins(),
              ),
              value: _twoFactorEnabled,
              onChanged: (value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
              },
              activeColor: primaryColor,
              inactiveTrackColor: textSecondaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Biometric: $_biometricEnabled, 2FA: $_twoFactorEnabled',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: secondaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Save', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
