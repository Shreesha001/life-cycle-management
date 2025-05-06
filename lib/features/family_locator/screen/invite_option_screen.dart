import 'package:flutter/material.dart';

class InviteOption extends StatelessWidget {
  final IconData icon;
  final String label;

  InviteOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 16),
          Text(label),
        ],
      ),
    );
  }
}

class MyDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(child: Text("S")),
            accountName: Text("Shreesha"),
            accountEmail: null,
          ),
          ListTile(title: Text("Find my family"), selected: true, onTap: () {}),
          ListTile(title: Text("Share location with my family"), onTap: () {}),
          ListTile(title: Text("Settings"), onTap: () {}),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Version 1.0.7\nSimple Design",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
