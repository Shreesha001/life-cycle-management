import 'package:flutter/material.dart';
import 'package:merge_app/features/ai_chatbot/screen/ai_chatbot_screen.dart';
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
import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat('EEE d MMM').format(date);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      'color': secondaryColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                  SizedBox(height: 10),
                  Text(
                    "User Name",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "user@email.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            drawerSection("User Profile", [
              "Name",
              "Mobile number",
              "Email ID",
              "Profile photo",
              "Surname",
              "Date of birth",
              "Gender",
            ]),
            drawerSection("Family & Shared Access", [
              "Manage family members",
              "Role assignment (admin, member)",
              "Permissions (e.g., access to modules)",
              "Invite or remove family members",
            ]),
            drawerSection("Notification", [
              "Setting notification frequency",
              "Default & custom options",
            ]),
            drawerSection("Lifestyle Preferences & Settings", [
              "Interest areas",
              "Health settings",
              "Finance settings",
              "Meal preferences",
              "Notification preferences",
            ]),
            drawerSection("Account & Security", [
              "Change password",
              "Biometric login toggle",
              "Secure Vault access",
              "Data sync settings",
              "Two-factor authentication",
            ]),
            drawerSection("AI & Personalization Tools", [
              "Recalibrate personality quiz",
              "AI assistant settings",
              "Daily summary/report preferences",
            ]),
            drawerSection("Help & Support", [
              "FAQs",
              "Contact support",
              "Feedback & suggestions",
              "Report a bug",
            ]),
            drawerSection("Legal & Logout", [
              "Privacy policy",
              "Terms & conditions",
              "Delete account",
              "Logout",
            ]),
          ],
        ),
      ),

      appBar: AppBar(
        title: Row(
          children: [Text('The Johnsons'), Icon(Icons.arrow_drop_down)],
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: CircleAvatar(child: Icon(Icons.person)),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Swipable event block with dynamic date
          SingleChildScrollView(
            child: Container(
              height: 240,
              child: PageView.builder(
                itemBuilder: (context, index) {
                  final date = DateTime.now();
                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getFormattedDate(date),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          eventItem(
                            'Swimming Lesson Nina',
                            '10:30 - 12:30',
                            Colors.orange,
                          ),
                          eventItem(
                            'Girl Cinema',
                            '02:30 - 04:30',
                            Colors.pink,
                          ),
                          eventItem(
                            "Dinner at Granny's",
                            '07:30 - 09:00',
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Feature Grid
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AIChatBotScreen()),
          );
        },
        child: Icon(Icons.chat),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            feature['title'],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

Widget drawerSection(String title, List<String> items) {
  return ExpansionTile(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    children: items.map((item) => ListTile(title: Text(item))).toList(),
  );
}
