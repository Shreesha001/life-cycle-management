import 'package:flutter/material.dart';

class PeriodSettingScreen extends StatelessWidget {
  const PeriodSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildPremiumCard(context),
          const SizedBox(height: 20),
          _buildSectionHeader(Icons.water_drop, 'My Cycle'),
          _buildSettingItem('Period prediction'),
          _buildSettingItem('Ovulation and fertility prediction'),
          _buildSettingItem('Pregnancy'),
          const SizedBox(height: 20),
          _buildSectionHeader(Icons.notifications, 'Reminders'),
          _buildSettingItem('Cycle reminders'),
          _buildSettingItem('Medicine reminder'),
          _buildSettingItem('Contraception reminders'),
          _buildSettingItem('Meditation reminder'),
          _buildSettingItem('Daily logging reminder'),
          _buildSettingItem('Tracking reminders'),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.pink, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Get more benefits from the app!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'UPGRADE TO PREMIUM',
                  style: TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.pink),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate or handle setting tap
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}
