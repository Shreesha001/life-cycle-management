import 'package:flutter/material.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_maintainance_screen.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_refuel_screen.dart';

class VehicleHomepageScreen extends StatelessWidget {
  const VehicleHomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: const Text(
          "Vehicle Manager",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _vehicleSelector(context),
            const SizedBox(height: AppConstants.spacing16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: "This Month",
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(
                            value: "This Month",
                            child: Text("This Month"),
                          ),
                          DropdownMenuItem(
                            value: "Last 6 Months",
                            child: Text("Last 6 Months"),
                          ),
                          DropdownMenuItem(
                            value: "This Year",
                            child: Text("This Year"),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: AppConstants.spacing8),
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacing16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.spacing16,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "\$3,000",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppConstants.spacing4),
                            Text(
                              "Total Spend",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spacing16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacing16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.08),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.spacing16,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Scrollable horizontal content
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Last service: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("12 June 2025"),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.speed,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Reading: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("23,456 KM"),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.build_circle,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Next service at: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("26,000 KM"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing16),

                        // ✅ Add icon outside the scroll view
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => _showAddServiceDialog(context),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Documents Expiry",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text("View Documents", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: AppConstants.spacing8),
            const _ExpiryItem(
              title: "Insurance expiry",
              date: "12 Dec 2026",
              days: 400,
            ),
            const _ExpiryItem(
              title: "PUC expiry",
              date: "12 Dec 2026",
              days: 400,
            ),
            const _ExpiryItem(
              title: "RC expiry",
              date: "12 Dec 2026",
              days: 400,
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _showAddOptionsBottomSheet(context);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: AppColors.primaryColor,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = screenWidth / 3;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _GridOptionCard(
                width: itemWidth - 16,
                icon: Icons.local_gas_station,
                label: 'Petrol',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehicleRefuelScreen(),
                    ),
                  );
                },
              ),
              _GridOptionCard(
                width: itemWidth - 16,
                icon: Icons.build,
                label: 'Maintenance',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehicleMaintenanceScreen(),
                    ),
                  );
                },
              ),
              _GridOptionCard(
                width: itemWidth - 16,
                icon: Icons.note,
                label: 'Note',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Note tapped')));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _vehicleSelector(BuildContext context) {
    return Row(
      children: [
        _VehicleChip(label: "HR26DQ3456", selected: true),
        const SizedBox(width: AppConstants.spacing16),
        _VehicleChip(label: "DL8CAA8756", selected: false),
        const Spacer(),
        InkWell(
          onTap: () => _showAddVehicleBottomSheet(context),
          child: const Icon(
            Icons.add_circle,
            color: AppColors.secondaryColor,
            size: 40,
          ),
        ),
      ],
    );
  }

  void _showAddVehicleBottomSheet(BuildContext context) {
    final _vehicleTypeController = TextEditingController();
    final _vehicleNameController = TextEditingController();
    final _phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Vehicle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _vehicleTypeController,
                decoration: const InputDecoration(labelText: "Vehicle Type"),
              ),
              TextField(
                controller: _vehicleNameController,
                decoration: const InputDecoration(labelText: "Vehicle Name"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final type = _vehicleTypeController.text.trim();
                  final name = _vehicleNameController.text.trim();
                  final phone = _phoneController.text.trim();

                  if (type.isNotEmpty && name.isNotEmpty && phone.isNotEmpty) {
                    // TODO: Add logic to save the vehicle info
                    Navigator.pop(context); // Close bottom sheet
                  }
                },
                child: const Text("Add Vehicle"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final currentKmController = TextEditingController();
    final nextServiceKmController = TextEditingController();
    final serviceNoteController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Add Service Entry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInputField(
                    icon: Icons.speed,
                    hint: 'Current KM Reading',
                    controller: currentKmController,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    icon: Icons.build_circle,
                    hint: 'Next Service At (KM)',
                    controller: nextServiceKmController,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    icon: Icons.note_alt,
                    hint: 'Service Note',
                    controller: serviceNoteController,
                    inputType: TextInputType.text,
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  print(
                    'Current KM: ${currentKmController.text}, '
                    'Next Service: ${nextServiceKmController.text}, '
                    'Note: ${serviceNoteController.text}',
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required TextInputType inputType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _VehicleChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _VehicleChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor:
          selected ? AppColors.primaryColor : AppColors.backgroundColor,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ExpiryItem extends StatelessWidget {
  final String title;
  final String date;
  final int days;

  const _ExpiryItem({
    required this.title,
    required this.date,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "$days days more to expire",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridOptionCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GridOptionCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
