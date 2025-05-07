import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/add_period_lifecycle_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/homepage_period_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/period_premium_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/period_setting_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/period_statistics_screen.dart';

// Dummy screen widgets — replace with your actual screens

class PeriodDashboardScreen extends StatefulWidget {
  const PeriodDashboardScreen({super.key});

  @override
  State<PeriodDashboardScreen> createState() => _PeriodHomeScreenState();
}

class _PeriodHomeScreenState extends State<PeriodDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomepagePeriodScreen(),
    PeriodStatisticsScreen(),
    AddPeriodLifecycleScreen(),
    PeriodPremiumScreen(),
    PeriodSettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _currentIndex > 1
                ? _currentIndex
                : (_currentIndex == 2 ? 0 : _currentIndex),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.pink),
            label: 'Add',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Premium'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
