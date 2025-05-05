import 'package:flutter/material.dart';
import 'package:merge_app/features/password_manager/core/constants/app_constants.dart';
import 'package:merge_app/features/password_manager/core/theme/theme.dart';
import 'package:merge_app/features/password_manager/screens/add_new_password_screen.dart';
import 'package:merge_app/features/password_manager/screens/password_details_screen.dart';

class PasswordDashboardScreen extends StatefulWidget {
  const PasswordDashboardScreen({super.key});

  @override
  State<PasswordDashboardScreen> createState() =>
      _PasswordDashboardScreenState();
}

class _PasswordDashboardScreenState extends State<PasswordDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _allItems = [
    {"title": "Dribbble", "email": "didar@mail.com", "time": "1 min"},
    {"title": "Facebook", "email": "didarfb@mail.com", "time": "2 min"},
    {"title": "Facebook", "email": "didarfb@mail.com", "time": "2 min"},
    {"title": "Facebook", "email": "didarfb@mail.com", "time": "2 min"},
    {"title": "Behance", "email": "didarbnc@mail.com", "time": "5 min"},
  ];

  List<Map<String, String>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems =
          _allItems
              .where(
                (item) =>
                    item['title']!.toLowerCase().contains(query) ||
                    item['email']!.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewPasswordScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: theme.cardColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.home_outlined, color: AppColors.primaryColor),
              Icon(Icons.access_time, color: AppColors.primaryColor),
              SizedBox(width: 48),
              Icon(Icons.shopping_bag_outlined, color: AppColors.primaryColor),
              Icon(Icons.person_outline, color: AppColors.primaryColor),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  children: [
                    const Icon(
                      Icons.menu,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: AppConstants.spacing16),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: theme.cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing16),
                    const Icon(
                      Icons.grid_view_rounded,
                      size: 24,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacing24),

                Text(
                  "Manage your privacy",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing24),

                Text(
                  "My Data",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),

                Wrap(
                  spacing: AppConstants.spacing16,
                  runSpacing: AppConstants.spacing16,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PasswordDetailsScreen(),
                          ),
                        );
                      },
                      child: DashboardCard(
                        title: "Browser",
                        subtitle: "34 password",
                        icon: Icons.language,
                        width: screenWidth * 0.42,
                      ),
                    ),

                    DashboardCard(
                      title: "Cloud",
                      subtitle: "23 files",
                      icon: Icons.cloud_outlined,
                      width: screenWidth * 0.42,
                    ),
                    DashboardCard(
                      title: "Application",
                      subtitle: "10 files",
                      icon: Icons.apps,
                      width: screenWidth * 0.42,
                    ),
                    DashboardCard(
                      title: "Payment",
                      subtitle: "23 cards",
                      icon: Icons.payment,
                      width: screenWidth * 0.42,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing32),

                Text(
                  "Recently Added",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: AppConstants.spacing16),

                ..._filteredItems.map(
                  (item) => RecentItem(
                    title: item['title']!,
                    email: item['email']!,
                    time: item['time']!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double width;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.spacing16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 28),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: theme.hintColor),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentItem extends StatelessWidget {
  final String title;
  final String email;
  final String time;

  const RecentItem({
    super.key,
    required this.title,
    required this.email,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Text(title[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColors.primaryColor,
        ),
      ),
      subtitle: Text(email, style: theme.textTheme.bodySmall),
      trailing: Text(time, style: theme.textTheme.bodySmall),
    );
  }
}
