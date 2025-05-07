import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/health_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/step_counter_more_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/step_counter_report_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/step_counter_screen.dart';

// Import your actual screen widgets below

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;

  // List of your screens
  final List<Widget> _screens = const [
    StepCounterScreen(),
    StepCounterReportScreen(),
    HealthScreen(),
    StepCounterMoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B1E3C),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Today',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'More'),
        ],
      ),
    );
  }
}
