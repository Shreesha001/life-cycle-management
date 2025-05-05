import 'package:flutter/material.dart';
import 'package:merge_app/features/vehicle_manager/core/theme/theme.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_maintainance_screen.dart';

class VehicleMaintainanceMainScreen extends StatelessWidget {
  const VehicleMaintainanceMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = List.generate(
      5,
      (index) => {
        'vehicle': 'Vehicle $index',
        'date': 'May 0${index + 1}, 2025',
        'service': 'Oil Change',
      },
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Maintenance Records'),
      ),
      body: ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final entry = dummyData[index];
          return ListTile(
            leading: const Icon(Icons.build),
            title: Text(entry['vehicle']!),
            subtitle: Text('${entry['date']} • ${entry['service']}'),
            onTap: () {
              // Navigate to detailed maintenance screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleMaintenanceScreen(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehicleMaintenanceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
