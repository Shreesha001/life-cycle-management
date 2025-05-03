import 'package:flutter/material.dart';
import 'package:merge_app/features/dates_to_remember/responsive/mobile_screen_layout.dart';
import 'package:merge_app/features/my_diary/screens/dairy_home_page.dart';
import 'package:merge_app/features/todo/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_FeatureBox> _allFeatures = [
    _FeatureBox('ToDo', Colors.blueAccent, ToDoScreen()),
    _FeatureBox('My Dairy', Colors.pinkAccent, MyDiaryScreen()),
    _FeatureBox(
      'Password Manager',
      Colors.deepPurpleAccent,
      PasswordManagerScreen(),
    ),
    _FeatureBox('Document Management', Colors.teal, DocumentManagementScreen()),
    _FeatureBox('Finance Tracker', Colors.orangeAccent, FinanceTrackerScreen()),
    _FeatureBox('Dates to Remember', Colors.green, DatesToRememberScreen()),
    _FeatureBox('Vehicle', Colors.redAccent, VehicleScreen()),
  ];

  List<_FeatureBox> _filteredFeatures = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredFeatures = _allFeatures;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _filteredFeatures =
          _allFeatures
              .where(
                (f) => f.title.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  void _onFeatureTap(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _filteredFeatures.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final feature = _filteredFeatures[index];
                  return GestureDetector(
                    onTap: () => _onFeatureTap(feature.screen),
                    child: Container(
                      decoration: BoxDecoration(
                        color: feature.color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: feature.color.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          feature.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureBox {
  final String title;
  final Color color;
  final Widget screen;

  const _FeatureBox(this.title, this.color, this.screen);
}

class ToDoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => HomeScreen();
}

class MyDiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DiaryHomePage();
}

class PasswordManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _dummyScreen('Password Manager');
}

class DocumentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _dummyScreen('Document Management');
}

class FinanceTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _dummyScreen('Finance Tracker');
}

class DatesToRememberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MobileScreenLayout();
}

class VehicleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _dummyScreen('Vehicle');
}

Widget _dummyScreen(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Text('Welcome to $title screen!', style: TextStyle(fontSize: 22)),
    ),
  );
}
