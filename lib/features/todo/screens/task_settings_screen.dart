import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';

class TaskSettingsScreen extends StatefulWidget {
  const TaskSettingsScreen({super.key});

  @override
  _TaskSettingsScreenState createState() => _TaskSettingsScreenState();
}

class _TaskSettingsScreenState extends State<TaskSettingsScreen> {
  bool showCompleted = true;
  bool showConfirmation = false;
  String sortOption = 'futureToPast';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('todo_settings')
              .doc('settings')
              .get();
      if (doc.exists) {
        setState(() {
          showCompleted = doc.data()!['showCompleted'] ?? true;
          showConfirmation = doc.data()!['showConfirmation'] ?? false;
          sortOption = doc.data()!['sortOption'] ?? 'futureToPast';
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('todo_settings')
            .doc('settings')
            .set({
              'showCompleted': showCompleted,
              'showConfirmation': showConfirmation,
              'sortOption': sortOption,
            });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving settings: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: secondaryColor),
        title: Text(
          'Task Settings',
          style: GoogleFonts.poppins(color: secondaryColor),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Task Settings',
              style: GoogleFonts.poppins(
                color: textPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: Text(
              'Show Completed Tasks',
              style: GoogleFonts.poppins(color: textPrimaryColor),
            ),
            value: showCompleted,
            onChanged: (val) {
              setState(() => showCompleted = val);
              _saveSettings();
            },
            activeColor: secondaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => Colors.grey,
            ),
          ),
          SwitchListTile(
            title: Text(
              'Display a confirmation popup when deleting a task',
              style: GoogleFonts.poppins(color: textPrimaryColor),
            ),
            value: showConfirmation,
            onChanged: (val) {
              setState(() => showConfirmation = val);
              _saveSettings();
            },
            activeColor: secondaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => Colors.grey,
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Sort By',
              style: GoogleFonts.poppins(
                color: textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.fiber_new,
              color:
                  sortOption == 'newlyAdded'
                      ? secondaryColor
                      : textPrimaryColor,
            ),
            title: Text(
              'Newly Added',
              style: GoogleFonts.poppins(
                color:
                    sortOption == 'newlyAdded'
                        ? secondaryColor
                        : textPrimaryColor,
              ),
            ),
            onTap: () {
              setState(() => sortOption = 'newlyAdded');
              _saveSettings();
            },
            trailing:
                sortOption == 'newlyAdded'
                    ? const Icon(Icons.check, color: secondaryColor)
                    : null,
          ),
          ListTile(
            leading: Icon(
              Icons.date_range,
              color:
                  sortOption == 'dueEarliest'
                      ? secondaryColor
                      : textPrimaryColor,
            ),
            title: Text(
              'Due Date (Earliest First)',
              style: GoogleFonts.poppins(
                color:
                    sortOption == 'dueEarliest'
                        ? secondaryColor
                        : textPrimaryColor,
              ),
            ),
            onTap: () {
              setState(() => sortOption = 'dueEarliest');
              _saveSettings();
            },
            trailing:
                sortOption == 'dueEarliest'
                    ? const Icon(Icons.check, color: secondaryColor)
                    : null,
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
