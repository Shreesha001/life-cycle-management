import 'package:flutter/material.dart';
import 'package:merge_app/features/finance_tracker/screens/homePage/dashboard.dart';
import 'package:merge_app/features/finance_tracker/screens/homePage/income_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    Dashboard(), // Dashboard screen
    IncomeScreen(), // Income screen
  ];

  // Method to handle screen change when bottom navigation is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped, // Switch screen when an item is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Income',
          ),
        ],
      ),
    );
  }
}
