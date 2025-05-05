import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'package:merge_app/features/todo/utils/colors.dart';
import 'package:merge_app/features/todo/screens/profile_screen.dart';
import 'package:merge_app/features/todo/screens/task_settings_screen.dart';
import 'package:merge_app/features/todo/widgets/home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCompleted = true;
  String sortOption = 'futureToPast';
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showCompleted = prefs.getBool('showCompleted') ?? true;
      sortOption = prefs.getString('sortOption') ?? 'futureToPast';
    });
  }

  void addTask(String title, String description, DateTime dueDate) {
    setState(() {
      tasks.add({
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'isChecked': false,
      });
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]['isChecked'] = !(tasks[index]['isChecked'] as bool);
    });
  }

  void deleteSelectedTasks() {
    setState(() {
      tasks.removeWhere((task) => task['isChecked'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleTasks =
        tasks.where((t) => showCompleted || !(t['isChecked'] as bool)).toList();

    if (sortOption == 'newlyAdded') {
      visibleTasks.sort((a, b) => tasks.indexOf(b).compareTo(tasks.indexOf(a)));
    } else if (sortOption == 'dueEarliest') {
      visibleTasks.sort((a, b) {
        DateTime da = a['dueDate'];
        DateTime db = b['dueDate'];
        return da.compareTo(db);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("ToDo", style: TextStyle(color: secondaryColor)),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                            'Are you sure you want to delete selected tasks?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (shouldDelete == true) {
                    deleteSelectedTasks();
                  }
                },
                icon: const Icon(
                  Icons.delete_outlined,
                  color: secondaryColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TaskSettingsScreen(),
                      ),
                    ).then((_) => _loadSettings()),
                icon: const Icon(Icons.menu, color: secondaryColor, size: 30),
              ),
            ],
          ),
          Expanded(
            child:
                visibleTasks.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          '"The secret of\ngetting ahead is\ngetting started."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: visibleTasks.length,
                      itemBuilder: (context, index) {
                        final task = visibleTasks[index];
                        final originalIndex = tasks.indexOf(task);
                        return HomeCard(
                          title: task['title'],
                          description: task['description'],
                          dueDate: task['dueDate'],
                          isChecked: task['isChecked'],
                          onChanged: (_) => toggleTask(originalIndex),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(onAddTask: addTask),
                ),
              ),
          backgroundColor: secondaryColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
