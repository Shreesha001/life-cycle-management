import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/todo/screens/add_task_screen.dart';
import 'package:merge_app/features/todo/screens/profile_screen.dart';
import 'package:merge_app/features/todo/screens/task_settings_screen.dart';
import 'package:merge_app/features/todo/widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> _toggleTask(String taskId, bool isCompleted) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('todo')
          .doc(taskId)
          .update({'isCompleted': !isCompleted});
    }
  }

  Future<void> _deleteSelectedTasks() async {
    if (showConfirmation) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Confirm Deletion', style: GoogleFonts.poppins()),
              content: Text(
                'Are you sure you want to delete selected tasks?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel', style: GoogleFonts.poppins()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(color: errorColor),
                  ),
                ),
              ],
            ),
      );
      if (shouldDelete != true) return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('todo')
              .where('isCompleted', isEqualTo: true)
              .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected tasks deleted', style: GoogleFonts.poppins()),
          backgroundColor: secondaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Text('Please log in', style: GoogleFonts.poppins()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
        title: Text('ToDo', style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [_buildActionBar(context), _buildTaskList(user.uid)],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ), // Rectangular with slightly rounded corners
            ),
            padding: EdgeInsets.zero, // Ensures icon is centered
            elevation: 4,
          ),
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: _deleteSelectedTasks,
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
                MaterialPageRoute(builder: (_) => const TaskSettingsScreen()),
              ).then((_) => _loadSettings()),
          icon: const Icon(Icons.menu, color: secondaryColor, size: 30),
        ),
      ],
    );
  }

  Widget _buildTaskList(String uid) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('todo')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: secondaryColor),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading tasks',
                style: GoogleFonts.poppins(color: textPrimaryColor),
              ),
            );
          }
          final tasks =
              snapshot.data?.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data.containsKey('isCompleted') &&
                    data.containsKey('title') &&
                    data.containsKey('description') &&
                    data.containsKey('dueDate') &&
                    data.containsKey('createdAt');
              }).toList() ??
              [];
          final visibleTasks =
              tasks
                  .where((task) => showCompleted || !task['isCompleted'])
                  .toList();

          if (sortOption == 'newlyAdded') {
            visibleTasks.sort(
              (a, b) => b['createdAt'].compareTo(a['createdAt']),
            );
          } else if (sortOption == 'dueEarliest') {
            visibleTasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));
          } else {
            visibleTasks.sort((a, b) => b['dueDate'].compareTo(a['dueDate']));
          }

          if (visibleTasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  '"Write it down, Make\nit happen-Start With\na list."',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: visibleTasks.length,
            itemBuilder: (context, index) {
              final task = visibleTasks[index];
              return Dismissible(
                key: Key(task.id),
                background: Container(
                  color: errorColor,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: whiteColor),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss:
                    showConfirmation
                        ? (direction) async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Confirm Deletion',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this task?',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.poppins(
                                          color: errorColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          return shouldDelete;
                        }
                        : null,
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('todo')
                      .doc(task.id)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Task deleted',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: secondaryColor,
                    ),
                  );
                },
                child: HomeCard(
                  taskId: task.id,
                  title: task['title'],
                  description: task['description'],
                  dueDate: (task['dueDate'] as Timestamp).toDate(),
                  isCompleted: task['isCompleted'],
                  showConfirmation: showConfirmation,
                  onChanged:
                      (value) => _toggleTask(task.id, task['isCompleted']),
                  isHighPriority: null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
