import 'package:flutter/material.dart';

class StepCounterMoreScreen extends StatelessWidget {
  const StepCounterMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _titleRow("More"),
            const SizedBox(height: 16),
            _achievementCard(),
            const SizedBox(height: 16),
            _listTile(
              Icons.backup,
              "Backup & Restore",
              trailing: const Icon(Icons.sync, color: Colors.white54),
            ),
            _settingTile(
              "Step Goal",
              "6000",
              trailingColor: Colors.greenAccent,
            ),
            _settingTile(
              "Sensitivity",
              "Medium",
              subtitle:
                  "High sensitivity means small movements will be counted as steps",
              trailingColor: Colors.greenAccent,
            ),
            _settingTile(
              "Weight",
              "105.0 kg",
              subtitle: "Calories calculation needs it",
              trailingColor: Colors.greenAccent,
            ),
            _settingTile(
              "More Settings",
              "",
              subtitle: "Gender, Step length, Metric & Imperial Unit",
            ),
            _toggleTile("Drink Water", true),
            _settingTile(
              "Reminder",
              "Off",
              subtitle: "Every day",
              trailingColor: Colors.greenAccent,
            ),
            _settingTile(
              "Language options",
              "English",
              trailingColor: Colors.greenAccent,
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF153A67),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _listTile(
                    Icons.info_outline,
                    "Instructions",
                    trailing: const Text(
                      "•",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  _listTile(Icons.feedback_outlined, "Feedback"),
                  _listTile(Icons.share_outlined, "Share with friends"),
                  _listTile(Icons.star_outline, "Request a new feature"),
                  _listTile(Icons.remove_circle_outline, "Remove ads"),
                  _listTile(Icons.privacy_tip_outlined, "Privacy policy"),
                  _listTile(Icons.delete_outline, "Delete all data"),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Version 1.5.41.40A",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
     
    );
  }

  Widget _titleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _achievementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text(
                "ACHIEVEMENTS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            "1 ▸",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile(
    String title,
    String value, {
    String? subtitle,
    Color trailingColor = Colors.white54,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                )
                : null,
        trailing: Text(
          value,
          style: TextStyle(color: trailingColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _toggleTile(String title, bool value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        onChanged: (_) {},
        activeColor: Colors.greenAccent,
      ),
    );
  }

  Widget _listTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing,
    );
  }
}
