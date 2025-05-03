import 'package:flutter/material.dart';
import 'package:merge_app/features/todo/utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Dark background
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),

          // Profile Section
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.cyan,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Shreesha',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Verified',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // User Settings Section
          sectionTitle('User Settings'),
          settingTile('Nickname'),
          settingTile('Icon'),
          settingTile('Social Login'),
          settingTileWithTrailingIcon(
            'Theme Color',
            trailingIcon: Icons.circle,
            iconColor: Colors.orange,
          ),

          const SizedBox(height: 8),

          // Support Section
          sectionTitle('Support'),
          settingTile('How to Use'),
          settingTile('FAQ & Help Center'),
          settingTile('Send Feedback'),
          settingTile('Contact Us'),

          const SizedBox(height: 8),

          // About
          settingTile('About This App'),

          const SizedBox(height: 8),

          // Sign Out and Delete Account buttons
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for section titles
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget for normal settings row
  Widget settingTile(String title) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ), // Added padding
          tileColor: tileColor,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white,
          ),
          onTap: () {
            // Handle tap
          },
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
          thickness: 0.5,
          indent: 12,
          endIndent: 12,
        ), // Nice small divider
      ],
    );
  }

  // Widget for settings with trailing icon
  Widget settingTileWithTrailingIcon(
    String title, {
    required IconData trailingIcon,
    Color? iconColor,
  }) {
    return Column(
      children: [
        ListTile(
          dense: true,
          tileColor: tileColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ), // Added padding
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: Icon(
            trailingIcon,
            size: 24,
            color: iconColor ?? Colors.white,
          ),
          onTap: () {
            // Handle tap
          },
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
          thickness: 0.5,
          indent: 12,
          endIndent: 12,
        ), // Divider after tile
      ],
    );
  }
}
