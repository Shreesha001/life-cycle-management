import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';
import 'package:merge_app/home_page/profile/account_security_screen.dart';
import 'package:merge_app/home_page/profile/ai_personalization_screen.dart';
import 'package:merge_app/home_page/profile/family_access_screen.dart';
import 'package:merge_app/home_page/profile/help_support_screen.dart';
import 'package:merge_app/home_page/profile/legal_logout_screen.dart';
import 'package:merge_app/home_page/profile/lifestyle_preferences_screen.dart';
import 'package:merge_app/home_page/profile/notifications_screen.dart';
import 'package:merge_app/home_page/profile/user_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              primarylightColor,
              primaryColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: Icons.person,
                      title: 'User Profile',
                      subtitle: 'Edit name, email, photo, and more',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfileScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.family_restroom,
                      title: 'Family & Shared Access',
                      subtitle: 'Manage family members and permissions',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FamilyAccessScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Set notification frequency and preferences',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.favorite,
                      title: 'Lifestyle Preferences & Settings',
                      subtitle: 'Personalize interests, health, finance, meals',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const LifestylePreferencesScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.security,
                      title: 'Account & Security',
                      subtitle: 'Manage password, biometric, 2FA',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const AccountSecurityScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.smart_toy,
                      title: 'AI & Personalization Tools',
                      subtitle: 'Configure AI assistant and recommendations',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const AIPersonalizationScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'FAQs, contact support, report bugs',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.gavel,
                      title: 'Legal & Logout',
                      subtitle: 'Privacy policy, terms, logout',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LegalLogoutScreen(),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Icon(Icons.settings, color: Colors.black, size: 28),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                whiteColor.withOpacity(0.9),
                primarylightColor.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(icon, color: primaryColor),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textSecondaryColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: secondaryColor,
              size: 16,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      ),
    );
  }
}
