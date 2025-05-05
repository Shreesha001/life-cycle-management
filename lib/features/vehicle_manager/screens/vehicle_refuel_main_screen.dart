import 'package:flutter/material.dart';
import 'package:merge_app/features/vehicle_manager/core/theme/theme.dart';
import 'vehicle_refuel_screen.dart';

class VehicleRefuelMainScreen extends StatefulWidget {
  const VehicleRefuelMainScreen({super.key});

  @override
  State<VehicleRefuelMainScreen> createState() =>
      _VehicleRefuelMainScreenState();
}

class _VehicleRefuelMainScreenState extends State<VehicleRefuelMainScreen> {
  final List<Map<String, dynamic>> refuelEntries = [
    {'vehicle': 'HR26DQ3456', 'date': '2025-04-01', 'total': 2200},
    {'vehicle': 'DL8CAA8756', 'date': '2025-03-15', 'total': 1500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Refuel History'),
      ),
      body:
          refuelEntries.isEmpty
              ? const Center(child: Text('No refuel entries yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: refuelEntries.length,
                itemBuilder: (context, index) {
                  final entry = refuelEntries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_gas_station),
                      title: Text(entry['vehicle']),
                      subtitle: Text(entry['date']),
                      trailing: Text("₹${entry['total']}"),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehicleRefuelScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
