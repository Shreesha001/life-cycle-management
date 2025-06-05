import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';
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
      final doc = await FirebaseFirestore.instance
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
        builder: (context) => AlertDialog(
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
      final snapshot = await FirebaseFirestore.instance
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

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => AddTaskBottomSheet(),
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildActionBar(context),
          _buildTaskList(user.uid),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: ElevatedButton(
          onPressed: () => _showAddTaskBottomSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
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
          onPressed: () => Navigator.push(
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
        stream: FirebaseFirestore.instance
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
          final tasks = snapshot.data?.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data.containsKey('isCompleted') &&
                    data.containsKey('title') &&
                    data.containsKey('description') &&
                    data.containsKey('dueDate') &&
                    data.containsKey('createdAt');
              }).toList() ??
              [];
          final visibleTasks =
              tasks.where((task) => showCompleted || !task['isCompleted']).toList();

          if (sortOption == 'newlyAdded') {
            visibleTasks.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
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
                  child: const Icon(Icons.delete, color: whiteColor),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: showConfirmation
                    ? (direction) async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Deletion', style: GoogleFonts.poppins()),
                            content: Text(
                              'Are you sure you want to delete this task?',
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
                      content: Text('Task deleted', style: GoogleFonts.poppins()),
                      backgroundColor: secondaryColor,
                    ),
                  );
                },
                child: HomeCard(
                  taskId: task.id,
                  title: task['title'],
                  dueDate: (task['dueDate'] as Timestamp).toDate(),
                  isCompleted: task['isCompleted'],
                  showConfirmation: showConfirmation,
                  onChanged: (value) => _toggleTask(task.id, task['isCompleted']),
                  isHighPriority: task['isHighPriority'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  DateTime? _dueDate;
  bool _isHighPriority = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('todo')
              .add({
            'title': _titleController.text.trim(),
            'description': _descriptionController.text.trim(),
            'dueDate': Timestamp.fromDate(_dueDate!),
            'isCompleted': false,
            'isHighPriority': _isHighPriority,
            'createdAt': Timestamp.now(),
          });
          Navigator.pop(context); // Close the bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task added successfully', style: GoogleFonts.poppins()),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form
          _titleController.clear();
          _descriptionController.clear();
          _dueDateController.clear();
          setState(() {
            _dueDate = null;
            _isHighPriority = false;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding task: $e', style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add task',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Task description...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      "Today",
                      style: GoogleFonts.poppins(
                        color: _dueDate != null &&
                                _dueDate!.day == DateTime.now().day &&
                                _dueDate!.month == DateTime.now().month &&
                                _dueDate!.year == DateTime.now().year
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _dueDate != null &&
                        _dueDate!.day == DateTime.now().day &&
                        _dueDate!.month == DateTime.now().month &&
                        _dueDate!.year == DateTime.now().year,
                    selectedColor: secondaryColor,
                    backgroundColor: Colors.grey[200],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _dueDate = DateTime.now();
                          _dueDateController.text =
                              "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}";
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      "Tomorrow",
                      style: GoogleFonts.poppins(
                        color: _dueDate != null &&
                                _dueDate!.day ==
                                    DateTime.now().add(const Duration(days: 1)).day &&
                                _dueDate!.month ==
                                    DateTime.now().add(const Duration(days: 1)).month &&
                                _dueDate!.year ==
                                    DateTime.now().add(const Duration(days: 1)).year
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _dueDate != null &&
                        _dueDate!.day ==
                            DateTime.now().add(const Duration(days: 1)).day &&
                        _dueDate!.month ==
                            DateTime.now().add(const Duration(days: 1)).month &&
                        _dueDate!.year ==
                            DateTime.now().add(const Duration(days: 1)).year,
                    selectedColor: secondaryColor,
                    backgroundColor: Colors.grey[200],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _dueDate = DateTime.now().add(const Duration(days: 1));
                          _dueDateController.text =
                              "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}";
                        });
                      }
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDueDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("High Priority", style: GoogleFonts.poppins()),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: _isHighPriority,
                    activeColor: Colors.red,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _isHighPriority = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Task',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}