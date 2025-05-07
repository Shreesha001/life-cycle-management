import 'package:flutter/material.dart';
import 'package:merge_app/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskSettingsScreen extends StatefulWidget {
  const TaskSettingsScreen({super.key});

  @override
  State<TaskSettingsScreen> createState() => _TaskSettingsScreenState();
}

class _TaskSettingsScreenState extends State<TaskSettingsScreen> {
  bool showCompleted = true;
  bool showConfirmation = false;
  String sortOption = 'futureToPast'; // default sort option

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load the settings from SharedPreferences
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showCompleted = prefs.getBool('showCompleted') ?? true;
      showConfirmation = prefs.getBool('showConfirmation') ?? false;
      sortOption = prefs.getString('sortOption') ?? 'futureToPast'; // default
    });
  }

  // Save the settings to SharedPreferences
  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showCompleted', showCompleted);
    prefs.setBool('showConfirmation', showConfirmation);
    prefs.setString('sortOption', sortOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: secondaryColor),
        title: const Text(
          'Task Settings',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Task Settings",
              style: TextStyle(
                color: textPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Toggle 1: Show/Hide Completed Tasks
          SwitchListTile(
            title: const Text(
              "Show Completed Tasks",
              style: TextStyle(color: textPrimaryColor),
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

          // Toggle 2: Confirmation popup for task deletion
          SwitchListTile(
            title: const Text(
              "Display a confirmation popup when deleting a task",
              style: TextStyle(color: textPrimaryColor),
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

          // Sort By section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "Sort By",
              style: TextStyle(
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
              "Newly Added",
              style: TextStyle(
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
              "Due Date (Earliest First)",
              style: TextStyle(
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
