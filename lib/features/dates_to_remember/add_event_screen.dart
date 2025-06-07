import 'package:flutter/material.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/dates_to_remember/event_model.dart';
import 'package:merge_app/features/dates_to_remember/event_service.dart';
import 'package:merge_app/features/dates_to_remember/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  bool _enableNotification = false;
  int _notifyBeforeMinutes = 10;
  final List<int> _notificationOptions = [10, 30, 60, 1440];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: primaryColor),
          title: const Text(
            'Add New Event',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Date & Time Picker
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Date & Time: ${_selectedDateTime.toLocal().toString().substring(0, 16)}',
                      style: const TextStyle(color: primaryColor),
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: secondaryColor,
                    ),
                    onTap: () => _selectDateTime(context),
                  ),
                  const Divider(height: 24),

                  // Notification Toggle
                  SwitchListTile(
                    title: const Text('Enable Notification'),
                    value: _enableNotification,
                    activeColor: secondaryColor,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (value) {
                      setState(() => _enableNotification = value);
                    },
                  ),

                  // Notification Options
                  if (_enableNotification)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _notifyBeforeMinutes,
                          decoration: InputDecoration(
                            labelText: 'Notify Before',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items:
                              _notificationOptions
                                  .map(
                                    (minutes) => DropdownMenuItem(
                                      value: minutes,
                                      child: Text(
                                        minutes >= 60
                                            ? '${minutes ~/ 60} hour${minutes ~/ 60 > 1 ? 's' : ''}'
                                            : '$minutes minutes',
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => _notifyBeforeMinutes = value!),
                        ),
                      ],
                    ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final event = EventModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text,
                          description: _descriptionController.text,
                          eventDateTime: _selectedDateTime,
                          notifyBeforeMinutes:
                              _enableNotification ? _notifyBeforeMinutes : 0,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                        );
                        await Provider.of<EventService>(
                          context,
                          listen: false,
                        ).addEvent(event);
                        if (_enableNotification) {
                          await NotificationService().scheduleNotification(
                            event,
                          );
                        }

                        _titleController.clear();
                        _descriptionController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Event added successfully'),
                          ),
                        );

                        Navigator.pop(
                          context,
                        ); // Optional: Close screen after add
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text('Add Event'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
