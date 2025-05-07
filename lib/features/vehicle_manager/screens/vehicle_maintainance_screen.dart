import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  const VehicleMaintenanceScreen({super.key});

  @override
  State<VehicleMaintenanceScreen> createState() =>
      _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  bool showMore = false;
  String selectedServiceType = 'Other service';

  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),

          child: Text('Maintenance'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppConstants.spacing8),
            child: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRow(Icons.directions_car, 'Vehicle', 'Fghdfg'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildDateField()),
                const SizedBox(width: 10),
                Expanded(child: _buildTimeField()),
              ],
            ),
            const SizedBox(height: 10),
            _buildInputField(
              Icons.location_on,
              'Location',
              suffixIcon: Icons.search,
            ),
            const SizedBox(height: 10),
            _buildInputField(Icons.speed, 'Odometer'),
            const SizedBox(height: 10),
            _buildDropdownField(Icons.build, 'Service type', [
              'Other service',
              'Oil Change',
              'Tire Rotation',
              'Brake Inspection',
            ]),
            const SizedBox(height: 10),
            _buildPlusButton(),
            const SizedBox(height: 10),
            _buildInputField(Icons.currency_exchange, 'Cost'),
            const SizedBox(height: 10),

            // More Section Toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  showMore = !showMore;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MORE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(showMore ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Conditionally show Notes and Attachments
            if (showMore) ...[
              _buildInputField(Icons.notes, 'Notes', maxLines: 3),
              const SizedBox(height: 10),
              _buildAttachmentSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.calendar_today),
        labelText: 'Date',
        hintText: 'May 3, 2025',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.access_time),
        labelText: 'Time',
        hintText: '4:15 PM',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String label, {
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownField(
    IconData icon,
    String label,
    List<String> options,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedServiceType,
          isExpanded: true,
          items:
              options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedServiceType = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () {
          // Add additional service logic
        },
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attachments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt, size: 30),
              onPressed: _pickImageFromCamera,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 30),
              onPressed: () {
                // Optionally add gallery picker here
              },
            ),
          ],
        ),
        if (_capturedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.file(
              _capturedImage!,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
