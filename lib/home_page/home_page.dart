import 'package:flutter/material.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/dates_to_remember/home_screen.dart';
import 'package:merge_app/features/dates_to_remember/responsive/mobile_screen_layout.dart';
import 'package:merge_app/features/dates_to_remember/utils/home_screen_items.dart';
import 'package:merge_app/features/document_management/screens/document_screen.dart';
import 'package:merge_app/features/family_locator/screen/family_app_home_screen.dart';
import 'package:merge_app/features/finance_tracker/screens/homePage/home_page.dart';
import 'package:merge_app/features/health_and_wellness/screens/homepage_screen.dart';
import 'package:merge_app/features/my_diary/screens/dairy_home_page.dart';
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
      'color': secondaryColor,
      'screen': DiaryHomePage(),
    },
    {
      'title': 'To-Do',
      'subtitle': '7 tasks',
      'details': '2 overdue',
      'icon': Icons.check_circle,
      'color': secondaryColor,
      'screen': todo.HomeScreen(),
    },
    {
      'title': 'Document Manager',
      'subtitle': '5 entries',
      'details': 'Last added: Today',
      'icon': Icons.folder,
      'color': secondaryColor,
      'screen': DocumentScreen(),
    },
    {
      'title': 'Family Locator',
      'subtitle': '2 members',
      'details': 'Active now',
      'icon': Icons.location_on,
      'color': secondaryColor,
      'screen': FamilyAppHomeScreen(),
    },
    {
      'title': 'Password Manager',
      'subtitle': '15 passwords',
      'details': 'All secure',
      'icon': Icons.lock,
      'color': secondaryColor,
      'screen': PasswordDashboardScreen(),
    },
    {
      'title': 'Finance Tracker',
      'subtitle': 'Budget updated',
      'details': 'This month',
      'icon': Icons.attach_money,
      'color': secondaryColor,
      'screen': HomepageScreen(),
    },
    {
      'title': 'Vehicle Manager',
      'subtitle': '2 vehicles',
      'details': 'Next service: 15 May',
      'icon': Icons.directions_car,
      'color': secondaryColor,
      'screen': VehicleDasboardBottomScreen(),
    },
    {
      'title': 'Dates to Remember',
      'subtitle': '3 dates',
      'details': 'Next: Anniversary',
      'icon': Icons.calendar_today,
      'color': secondaryColor ,
      'screen': HomeScreen2(),
    },
    {
      'title': 'Health & Wellness',
      'subtitle': '3 activities',
      'details': 'Meditation today',
      'icon': Icons.favorite,
      'color': secondaryColor,
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Row(
          children: [
            SizedBox(width: size.width * 0.02),
            Text(
              'The Johnsons',
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: Colors.white,
              ),
            ),
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
              color: Colors.white,
              size: size.width * 0.06,
            ),
          ),
          SizedBox(width: size.width * 0.02),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24), // Curve only bottom corners
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: size.width * 0.04,
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Center(
                          child: Text(
                            'MAY 2025',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: size.width * 0.04,
                      ),
                    ],
                  ),
                  SizedBox(height: verticalPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDayBox(context, 'Thu', '22', false),
                      _buildDayBox(context, 'Fri', '23', true),
                      _buildDayBox(context, 'Sat', '24', false),
                      _buildDayBox(context, 'Sun', '25', false),
                      _buildDayBox(context, 'Mon', '26', false),
                      _buildDayBox(context, 'Tue', '27', false),
                      _buildDayBox(context, 'Wed', '28', false),
                      _buildDayBox(context, 'Thu', '29', false),
                    ],
                  ),
                ],
              ),
            ),
            // Today's Plan Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Plan",
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: verticalPadding),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(horizontalPadding * 1.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 12,

                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildEventItem(context, '1:30', 'Swimming Lesson'),
                        Divider(color: Colors.grey[300]),
                        _buildEventItem(context, '2:30', 'Movie with Team'),
                        Divider(color: Colors.grey[300]),
                        _buildEventItem(context, '7:30', "Dinner at Granny's"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Feature Cards Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
            SizedBox(height: verticalPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBox(
    BuildContext context,
    String day,
    String date,
    bool isSelected,
  ) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.1,
      height: size.width * 0.1,
      decoration: BoxDecoration(
        color: isSelected ? secondaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(fontSize: size.width * 0.03, color: Colors.white),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: size.width * 0.035,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, String time, String title) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: secondaryColor,
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Container(
            width: 2,
            height: size.height * 0.04,
            color: Colors.grey[300],
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
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
            color: Colors.grey.shade500,
            blurRadius: 12,
            offset: Offset(3, 3),
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
              color: primaryColor,
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