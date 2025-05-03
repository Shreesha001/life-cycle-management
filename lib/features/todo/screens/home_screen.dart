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
  String sortOption = 'futureToPast'; // will be loaded from prefs
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
    // 1. Filter by completed flag
    final visibleTasks =
        tasks.where((t) => showCompleted || !(t['isChecked'] as bool)).toList();

    // 2. Sort by selected option
    if (sortOption == 'newlyAdded') {
      // Newest first: larger original index means added later
      visibleTasks.sort((a, b) => tasks.indexOf(b).compareTo(tasks.indexOf(a)));
    } else if (sortOption == 'dueEarliest') {
      // Earliest due date first
      visibleTasks.sort((a, b) {
        DateTime da = a['dueDate'];
        DateTime db = b['dueDate'];
        return da.compareTo(db);
      });
    }
    // else: futureToPast or any other, keep original insertion order

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("ToDo", style: TextStyle(color: secondaryColor)),
      ),
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             onPressed: () {},
      //             icon: const Icon(Icons.home, size: 30, color: secondaryColor),
      //           ),
      //           const SizedBox(height: 4),
      //           Container(
      //             width: 70,
      //             height: 30,
      //             decoration: BoxDecoration(
      //               color: primarylightColor,
      //               borderRadius: BorderRadius.circular(30),
      //             ),
      //             child: TextButton(
      //               onPressed: () {},
      //               style: TextButton.styleFrom(padding: EdgeInsets.zero),
      //               child: const Text(
      //                 "Tasks",
      //                 style: TextStyle(color: textPrimaryColor, fontSize: 16),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             onPressed:
      //                 () => Navigator.push(
      //                   context,
      //                   MaterialPageRoute(builder: (_) => ProfileScreen()),
      //                 ),
      //             icon: const Icon(Icons.face, size: 30, color: secondaryColor),
      //           ),
      //           IconButton(
      //             onPressed: () {},
      //             icon: const Icon(
      //               Icons.calendar_month,
      //               size: 30,
      //               color: secondaryColor,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   centerTitle: true,
      //   toolbarHeight: 90,
      // ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: deleteSelectedTasks,
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
            child: ListView.builder(
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
