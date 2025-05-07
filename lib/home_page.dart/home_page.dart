import 'package:flutter/material.dart';
import 'package:merge_app/features/dates_to_remember/responsive/mobile_screen_layout.dart';
import 'package:merge_app/features/document_management/screens/document_screen.dart';
import 'package:merge_app/features/family_locator/screen/family_app_home_screen.dart';
import 'package:merge_app/features/finance_tracker/screens/homePage/homepage_screen.dart';
import 'package:merge_app/features/my_diary/screens/dairy_home_page.dart';
import 'package:merge_app/features/password_manager/screens/password_dashboard_screen.dart';
import 'package:merge_app/features/todo/screens/home_screen.dart' as todo;
import 'package:merge_app/features/vehicle_manager/screens/vehicle_dasboard_bottom_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Family Locator',
      'subtitle': '2 members',
      'details': 'Active now',
      'icon': Icons.location_on,
      'color': Colors.orangeAccent,
      'screen': FamilyAppHomeScreen(),
    },
    {
      'title': 'My Diary',
      'subtitle': '5 entries',
      'details': 'Updated today',
      'icon': Icons.book,
      'color': Colors.purpleAccent,
      'screen': DiaryHomePage(),
    },
    {
      'title': 'Dates to Remember',
      'subtitle': '3 dates',
      'details': 'Next: Anniversary',
      'icon': Icons.calendar_today,
      'color': Colors.greenAccent,
      'screen': MobileScreenLayout(),
    },
    {
      'title': 'To-Do',
      'subtitle': '7 tasks',
      'details': '2 overdue',
      'icon': Icons.check_circle,
      'color': Colors.blueAccent,
      'screen': todo.HomeScreen(),
    },
    {
      'title': 'Document Management',
      'subtitle': '12 files',
      'details': 'Last added: Today',
      'icon': Icons.folder,
      'color': Colors.tealAccent,
      'screen': DocumentScreen(),
    },
    {
      'title': 'Password Manager',
      'subtitle': '15 passwords',
      'details': 'All secure',
      'icon': Icons.lock,
      'color': Colors.redAccent,
      'screen': PasswordDashboardScreen(),
    },
    {
      'title': 'Finance Tracker',
      'subtitle': 'Budget updated',
      'details': 'This month',
      'icon': Icons.attach_money,
      'color': Colors.orange,
      'screen': HomepageScreen(),
    },
    {
      'title': 'Vehicle Manager',
      'subtitle': '2 vehicles',
      'details': 'Next service: 15 May',
      'icon': Icons.directions_car,
      'color': Colors.indigoAccent,
      'screen': VehicleDasboardBottomScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text('The Johnsons'), Icon(Icons.arrow_drop_down)],
        ),
        actions: [CircleAvatar(child: Icon(Icons.person)), SizedBox(width: 10)],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wed 6 Jan',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                eventItem(
                  'Swimming Lesson Nina',
                  '10:30 - 12:30',
                  Colors.orange,
                ),
                eventItem('Girl Cinema', '02:30 - 04:30', Colors.pink),
                eventItem("Dinner at Granny's", '07:30 - 09:00', Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
              ),
              itemCount: features.length,
              itemBuilder:
                  (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => features[index]['screen'],
                        ),
                      );
                    },
                    child: featureCard(features[index]),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventItem(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 4, height: 30, color: color),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget featureCard(Map<String, dynamic> feature) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            feature['title'],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            feature['subtitle'],
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          Text(
            feature['details'],
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: feature['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(feature['icon'], size: 18, color: feature['color']),
            ),
          ),
        ],
      ),
    );
  }
}
