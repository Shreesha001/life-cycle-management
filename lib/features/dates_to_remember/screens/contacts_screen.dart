import 'package:merge_app/features/dates_to_remember/screens/add_contact_screen.dart';
import 'package:merge_app/features/dates_to_remember/screens/contact_detailed_screen.dart';
import 'package:merge_app/core/colors.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactsScreen()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Add contacts", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contacts",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: "Search contacts",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ), // Default black border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ), // On focus
                ),
              ),
            ),

            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildContactTile(
                    "Albert Lee",
                    "Jan. 8 in 354 days",
                    initials: "A.L.",
                    context: context,
                  ),
                  _buildContactTile(
                    "Cara Smith",
                    "Feb. 29 in 41 days",
                    avatarUrl: "https://i.imgur.com/BoN9kdC.png",
                    context: context,
                  ),
                  _buildContactTile(
                    "Jeffrey Li",
                    "Dec. 5 in 320 days",
                    initials: "J.L.",
                    context: context,
                  ),
                  _buildContactTile(
                    "John Appleseed",
                    "🎉 Jan. 19 today",
                    avatarUrl: "https://i.imgur.com/BoN9kdC.png",
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    String name,
    String subtitle, {
    String? initials,
    String? avatarUrl,
    required BuildContext context,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading:
          avatarUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
              : CircleAvatar(child: Text(initials ?? "")),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
        onPressed: () {
          // show modal or set reminder
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ContactDetailScreen(name: name)),
        );
      },
    );
  }
}
