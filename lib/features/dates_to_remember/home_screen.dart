// lib/features/dates_to_remember/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/dates_to_remember/add_event_screen.dart';
import 'package:merge_app/features/dates_to_remember/event_screen.dart';
import 'package:merge_app/features/dates_to_remember/event_service.dart';
import 'package:merge_app/features/dates_to_remember/notification_service.dart';
import 'package:merge_app/features/dates_to_remember/setting_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const EventsScreen(),
    const AddEventScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventService>(create: (_) => EventService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
      ],
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Event'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
