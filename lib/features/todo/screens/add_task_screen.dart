import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  DateTime? _dueDate;
  bool _isHighPriority = false;

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
        _dueDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
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
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task added successfully',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding task: $e',
                  style: GoogleFonts.poppins()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'ToDo',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Existing tasks would go here
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              ListTile(
                title: Text("Pay Electricity Bill",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Until 28 May"),
                trailing: Icon(Icons.circle_outlined),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SingleChildScrollView(
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
                          color: Colors.orange,
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
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a title' : null,
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
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a description'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text("Today"),
                            selected: _dueDate != null &&
                                _dueDate!.day == DateTime.now().day,
                            selectedColor: Colors.orange,
                            onSelected: (_) {
                              setState(() {
                                _dueDate = DateTime.now();
                                _dueDateController.text =
                                    "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}";
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text("Tomorrow"),
                            selected: _dueDate != null &&
                                _dueDate!.day ==
                                    DateTime.now().add(const Duration(days: 1)).day,
                            selectedColor: Colors.orange,
                            onSelected: (_) {
                              setState(() {
                                _dueDate =
                                    DateTime.now().add(const Duration(days: 1));
                                _dueDateController.text =
                                    "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}";
                              });
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
                          const Text("High Priority"),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: _isHighPriority,
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
                          backgroundColor: Colors.indigo,
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
            ),
          ),
        ],
      ),
    );
  }
}
