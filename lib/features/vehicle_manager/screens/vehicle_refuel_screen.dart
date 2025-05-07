import 'package:flutter/material.dart';
import 'package:merge_app/core/theme/theme.dart';

class VehicleRefuelScreen extends StatefulWidget {
  const VehicleRefuelScreen({super.key});

  @override
  State<VehicleRefuelScreen> createState() => _VehicleRefuelScreenState();
}

class _VehicleRefuelScreenState extends State<VehicleRefuelScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController avgSpeedController = TextEditingController();
  final TextEditingController efficiencyController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isFullTank = true;
  bool missedPreviousRefuel = false;
  bool showMore = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
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

  void _saveData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving is disabled in demo mode.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Refuel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveData, // Only right-side save button
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.directions_car),
                  SizedBox(width: 8),
                  Expanded(child: Text('Fghdfg')),
                ],
              ),
              const SizedBox(height: 12),

              // Date & Time Pickers
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(selectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Location & Odometer
              _buildTextField(
                'Location',
                locationController,
                icon: Icons.location_on,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'Odometer',
                odometerController,
                icon: Icons.speed,
              ),
              const SizedBox(height: 12),

              // Amount & Full Tank Toggle
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Amount',
                      amountController,
                      icon: Icons.local_gas_station,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const Text('Full tank'),
                      Checkbox(
                        value: isFullTank,
                        onChanged: (val) => setState(() => isFullTank = val!),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price & Total
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Price',
                      priceController,
                      icon: Icons.attach_money,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField('Total (\$)', totalController),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Missed refuel checkbox
              Row(
                children: [
                  const Text('Missed previous refuel'),
                  Checkbox(
                    value: missedPreviousRefuel,
                    onChanged:
                        (val) => setState(() => missedPreviousRefuel = val!),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Expandable more section
              ListTile(
                title: const Text('MORE'),
                trailing: Icon(
                  showMore ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () => setState(() => showMore = !showMore),
              ),
              if (showMore) ...[
                const SizedBox(height: 8),
                const Text(
                  'Trip computer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Average speed',
                  avgSpeedController,
                  icon: Icons.speed,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Efficiency',
                  efficiencyController,
                  icon: Icons.water_drop,
                ),
                const SizedBox(height: 12),
                _buildTextField('Notes', notesController, icon: Icons.notes),
                const SizedBox(height: 16),

                // Attachments
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attachments',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 16),
                    Icon(Icons.add),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              const Divider(color: Colors.grey, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
