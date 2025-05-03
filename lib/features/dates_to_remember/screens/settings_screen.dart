import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Toggle for dark mode
  bool isNotificationsEnabled = true; // Toggle for notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode Toggle in Row format
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode', style: TextStyle(fontSize: 16)),
                Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    // You can implement theme change logic here
                  },
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Notifications Toggle in Row format
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Notifications', style: TextStyle(fontSize: 16)),
                Switch(
                  value: isNotificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      isNotificationsEnabled = value;
                    });
                    // You can implement notification logic here
                  },
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ],
            ),

            SizedBox(height: 16),

            // General Settings
            Text(
              'General Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Contact Support Option
            ListTile(
              leading: Icon(Icons.support_agent),
              title: Text('Contact Support'),
              onTap: () {
                // Logic to contact support
                print('Contact support tapped');
              },
            ),

            // Terms & Conditions Option
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Terms & Conditions'),
              onTap: () {
                // Logic to open terms and conditions
                print('Terms & Conditions tapped');
              },
            ),

            // Privacy Policy Option
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy Policy'),
              onTap: () {
                // Logic to open privacy policy
                print('Privacy Policy tapped');
              },
            ),

            // Log out Option
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to log out
                print('Log out tapped');
                // Optionally, navigate back or clear session data
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
