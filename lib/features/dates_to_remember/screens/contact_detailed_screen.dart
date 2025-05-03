import 'package:flutter/material.dart';

class ContactDetailScreen extends StatelessWidget {
  final String name;

  const ContactDetailScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, size: 28),
                  onPressed: () {
                    Navigator.pop(context); // This will close the screen
                  },
                ),
                Icon(Icons.edit, size: 24),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://i.imgur.com/BoN9kdC.png',
                  ),
                  radius: 32,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Today is their birthday 🎉",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 32),
            _buildInfo("BIRTHDATE", "Jan. 19, 1774"),
            SizedBox(height: 16),
            _buildInfo("AGE", "247 years old"),
            SizedBox(height: 16),
            _buildInfo("PHONE NUMBER", "(905) 123-1234"),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.call, color: Colors.white),
                    label: Text("Call", style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.textsms, color: Colors.blue),
                    label: Text("Text", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
