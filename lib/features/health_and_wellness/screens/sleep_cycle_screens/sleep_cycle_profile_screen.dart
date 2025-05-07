import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SleepCycleProfileScreen extends StatelessWidget {
  const SleepCycleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081C2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.cyanAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOfferBanner(),
          const SizedBox(height: 20),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Settings'),
          _buildSettingTile(Icons.flag, 'Sleep Goal', trailingText: 'Not set'),
          _buildSettingTile(
            Icons.music_note,
            'Sound',
            trailingText: 'Warm breeze',
          ),
          _buildSettingTile(
            Icons.schedule,
            'Wake up phase',
            trailingText: '30 min',
          ),
          _buildSettingTile(Icons.watch, 'Watch'),
          _buildSettingTile(Icons.school, 'Sleep school'),
          _buildSettingTile(
            Icons.insert_chart,
            'Weekly summary',
            trailingText: 'On',
          ),
          _buildSettingTile(Icons.more_horiz, 'More'),
          const SizedBox(height: 24),
          _buildSectionTitle('Premium'),
          _buildSettingTile(Icons.cloud, 'Online backup', trailingText: 'On'),
          _buildSettingTile(CupertinoIcons.drop, 'Sleep aid'),
          _buildSettingTile(
            Icons.edit_note,
            'Sleep notes',
            trailingText: 'Off',
          ),
          _buildSettingTile(
            Icons.emoji_emotions,
            'Wake up mood',
            trailingText: 'Off',
          ),
          _buildSettingTile(Icons.wb_cloudy, 'Weather', trailingText: 'Off'),
          _buildSettingTile(
            Icons.bedroom_baby,
            "Who's snoring",
            trailingText: 'Off',
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Help'),
          _buildSettingTile(Icons.help_outline, 'Help'),
        ],
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2C44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.card_giftcard, color: Colors.white70),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have a limited offer waiting for you!',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white24.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.nightlight_round, 'Nights', '-'),
          _buildStatItem(Icons.bedtime, 'Avg. Quality', '-'),
          _buildStatItem(Icons.access_time, 'Avg. time', '-'),
          _buildStatItem(
            Icons.backup,
            'Backup',
            'Off',
            iconColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? Colors.white54, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    String? trailingText,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing:
          trailingText != null
              ? Text(
                trailingText,
                style: const TextStyle(color: Colors.white60),
              )
              : const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white24,
              ),
      onTap: () {},
    );
  }
}
