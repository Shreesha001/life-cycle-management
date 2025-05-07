import 'package:flutter/material.dart';
import 'package:merge_app/core/colors.dart';

class ReminderModal extends StatefulWidget {
  final String name;

  const ReminderModal({Key? key, required this.name}) : super(key: key);

  @override
  State<ReminderModal> createState() => _ReminderModalState();
}

class _ReminderModalState extends State<ReminderModal> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);
  TextEditingController noteController = TextEditingController();
  bool repeatAnnually = true;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notify me',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Date label
            Text('Date', style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 4),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Time label
            Text('Time', style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 4),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  selectedTime.format(context),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Note label
            Text('Note', style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 4),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Repeat annually switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repeat annually', style: TextStyle(fontSize: 16)),
                Switch(
                  value: repeatAnnually,
                  onChanged: (value) => setState(() => repeatAnnually = value),
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ],
            ),

            SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Save logic here
                    Navigator.pop(context);
                  },
                  child: Text('SAVE', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
