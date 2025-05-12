import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/core/colors.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool showConfirmation;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    this.dueDate,
    required this.showConfirmation,
  });

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _dueDate = widget.dueDate;
    _dueDateController = TextEditingController(
      text:
          _dueDate != null
              ? "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"
              : '',
    );
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
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

  Future<void> _updateTask() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields', style: GoogleFonts.poppins()),
          backgroundColor: errorColor,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('todo')
            .doc(widget.taskId)
            .update({
              'title': _titleController.text.trim(),
              'description': _descriptionController.text.trim(),
              'dueDate': Timestamp.fromDate(_dueDate!),
            });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Task updated successfully',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: secondaryColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating task: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteTask() async {
    if (widget.showConfirmation) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
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
      if (shouldDelete != true) return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('todo')
            .doc(widget.taskId)
            .delete();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task deleted', style: GoogleFonts.poppins()),
            backgroundColor: secondaryColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting task: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: errorColor,
          ),
        );
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: secondaryColor, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: secondaryColor,
              size: 40,
            ),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: whiteColor,
              ),
              style: GoogleFonts.poppins(
                color: textPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _pickDueDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dueDateController,
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  style: GoogleFonts.poppins(
                    color: textPrimaryColor,
                    fontSize: 16,
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: whiteColor,
              ),
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
              maxLines: 4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _updateTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Update',
            style: GoogleFonts.poppins(
              color: whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
