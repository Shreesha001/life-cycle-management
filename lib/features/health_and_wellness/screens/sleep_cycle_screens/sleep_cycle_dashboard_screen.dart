import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_homepage_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_journal_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_profile_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_program_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_statics_screen.dart';

class SleepCycleDashboardScreen extends StatefulWidget {
  const SleepCycleDashboardScreen({super.key});

  @override
  State<SleepCycleDashboardScreen> createState() =>
      _SleepCycleDashboardScreenState();
}

class _SleepCycleDashboardScreenState extends State<SleepCycleDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SleepCycleHomepageScreen(),
    SleepCycleProgramScreen(),
    SleepCycleJournalScreen(),
    SleepCycleStaticsScreen(),
    SleepCycleProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03192E),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF03192E),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white54,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.nightlight_round),
          label: "Sleep",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Programs"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "Journal"),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: "Statistics",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
