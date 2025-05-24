import 'package:flutter/material.dart';
import 'package:merge_app/features/dates_to_remember/responsive/mobile_screen_layout.dart';
import 'package:merge_app/features/document_management/screens/document_screen.dart';
import 'package:merge_app/features/family_locator/screen/family_app_home_screen.dart';
import 'package:merge_app/features/finance_tracker/screens/homePage/home_page.dart';
import 'package:merge_app/features/health_and_wellness/screens/homepage_screen.dart';
import 'package:merge_app/features/my_diary/screens/dairy_home_page.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';
import 'package:merge_app/features/password_manager/screens/password_dashboard_screen.dart';
import 'package:merge_app/features/todo/screens/home_screen.dart' as todo;
import 'package:merge_app/features/vehicle_manager/screens/vehicle_dasboard_bottom_screen.dart';
import 'package:merge_app/home_page/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'My Diary',
      'subtitle': '5 entries',
      'details': 'Updated today',
      'icon': Icons.book,
      'color': Colors.purpleAccent,
      'screen': DiaryHomePage(),
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
      'title': 'Family Locator',
      'subtitle': '2 members',
      'details': 'Active now',
      'icon': Icons.location_on,
      'color': Colors.orangeAccent,
      'screen': FamilyAppHomeScreen(),
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
    {
      'title': 'Dates to Remember',
      'subtitle': '3 dates',
      'details': 'Next: Anniversary',
      'icon': Icons.calendar_today,
      'color': Colors.greenAccent,
      'screen': MobileScreenLayout(),
    },
    {
      'title': 'Health & Wellness',
      'subtitle': '3 activities',
      'details': 'Meditation today',
      'icon': Icons.favorite,
      'color': Colors.pinkAccent,
      'screen': HealthAndWellnessHomepageScreen(),
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.04;
    final verticalPadding = size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'The Johnsons',
              style: TextStyle(fontSize: size.width * 0.045),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: Icon(
              Icons.person,
              color: secondaryColor,
              size: size.width * 0.06,
            ),
          ),
          SizedBox(width: size.width * 0.02),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              primarylightColor,
              primaryColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding * 0.5,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search features...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: verticalPadding * 0.5,
                    horizontal: horizontalPadding,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(horizontalPadding),
              padding: EdgeInsets.all(horizontalPadding),
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
                      fontSize: size.width * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: verticalPadding * 0.5),
                  eventItem(
                    context,
                    'Swimming Lesson Nina',
                    '10:30 - 12:30',
                    Colors.orange,
                  ),
                  eventItem(
                    context,
                    'Girl Cinema',
                    '02:30 - 04:30',
                    Colors.pink,
                  ),
                  eventItem(
                    context,
                    "Dinner at Granny's",
                    '07:30 - 09:00',
                    Colors.blue,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width < 600 ? 2 : 3,
                    crossAxisSpacing: horizontalPadding,
                    mainAxisSpacing: verticalPadding,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => features[index]['screen'],
                          ),
                        );
                      },
                      child: featureCard(context, features[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventItem(
    BuildContext context,
    String title,
    String time,
    Color color,
  ) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 4, height: 30, color: color),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.035,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.03,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget featureCard(BuildContext context, Map<String, dynamic> feature) {
    final size = MediaQuery.of(context).size;
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
      padding: EdgeInsets.all(size.width * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature['title'],
            style: TextStyle(
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            feature['subtitle'],
            style: TextStyle(
              fontSize: size.width * 0.03,
              color: Colors.grey[600],
            ),
          ),
          Text(
            feature['details'],
            style: TextStyle(
              fontSize: size.width * 0.027,
              color: Colors.grey[500],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: feature['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(size.width * 0.015),
              child: Icon(
                feature['icon'],
                size: size.width * 0.05,
                color: feature['color'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
