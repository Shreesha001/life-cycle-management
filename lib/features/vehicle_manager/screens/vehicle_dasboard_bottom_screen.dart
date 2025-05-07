import 'package:flutter/material.dart';
import 'package:merge_app/core/theme/theme.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_document_screen.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_fastag_screen.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_homePage_screen.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_maintainance_main_screen.dart';
import 'package:merge_app/features/vehicle_manager/screens/vehicle_refuel_main_screen.dart';
// Assuming you have AppColors defined

class VehicleDasboardBottomScreen extends StatefulWidget {
  const VehicleDasboardBottomScreen({super.key});

  @override
  State<VehicleDasboardBottomScreen> createState() =>
      _VehicleDasboardBottomScreenState();
}

class _VehicleDasboardBottomScreenState
    extends State<VehicleDasboardBottomScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    VehicleHomepageScreen(),
    VehicleDocumentScreen(),
    VehicleMaintainanceMainScreen(),
    VehicleRefuelMainScreen(),
    VehicleFastagScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: "Documents",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Maintenance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: "Petrol",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Fastag"),
        ],
      ),
    );
  }
}
