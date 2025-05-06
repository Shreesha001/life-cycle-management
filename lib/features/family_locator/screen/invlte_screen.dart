import 'package:merge_app/features/family_locator/screen/invite_option_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteScreen extends StatelessWidget {
  final String inviteCode = "FNEXJ2EZ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text("Add your family")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose an app to send your invitation"),
            SizedBox(height: 16),
            InviteOption(icon: Icons.contacts, label: 'Contacts'),
            InviteOption(icon: Icons.face, label: 'Whatsapp'),
            InviteOption(icon: Icons.phone, label: 'Phone'),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text("Choose other apps"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            Spacer(),
            Text("Or just copy the code to your family"),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      inviteCode,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied to clipboard")),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: Colors.green),
                        SizedBox(width: 4),
                        Text("Copy", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
