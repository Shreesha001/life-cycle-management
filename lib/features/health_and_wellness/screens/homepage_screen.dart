import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/core/constants/app_constants.dart';
import 'package:merge_app/features/health_and_wellness/core/theme/theme.dart';
import 'package:merge_app/features/health_and_wellness/screens/health_body_screens/health_body_homepage_screen.dart';

import 'package:merge_app/features/health_and_wellness/screens/period_tracking_screens/period_dashboard_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_dashboard_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/sleep_cycle_screens/sleep_cycle_statics_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/home_dashboard_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/step_counter_report_screen.dart';
import 'package:merge_app/features/health_and_wellness/screens/step_counts_screens/step_counter_screen.dart';

class HealthAndWellnessHomepageScreen extends StatelessWidget {
  const HealthAndWellnessHomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: AppConstants.spacing24),
              const Text(
                "Practices",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: AppConstants.spacing8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Exercises\n',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: 'based on your\n',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: 'needs',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppConstants.spacing24),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width =
                        (constraints.maxWidth - AppConstants.spacing16) / 2;
                    return Wrap(
                      spacing: AppConstants.spacing16,
                      runSpacing: AppConstants.spacing16,
                      children: [
                        _PracticeCard(
                          title: "Sleep\nCycle",
                          backgroundColor: Colors.blue.shade100,
                          icon: Icons.arrow_outward,
                          width: width,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SleepCycleStaticsScreen(),
                              ),
                            );
                          },
                        ),
                        _PracticeCard(
                          title: "Steps\nCount",
                          backgroundColor: Colors.amber.shade100,
                          icon: Icons.arrow_outward,
                          width: width,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StepCounterReportScreen(),
                              ),
                            );
                          },
                        ),
                        _PracticeCard(
                          title: "Expected\nperiod Dates",
                          backgroundColor: Colors.teal.shade100,
                          icon: Icons.arrow_outward,
                          width: width,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PeriodDashboardScreen(),
                              ),
                            );
                          },
                        ),
                        _PracticeCard(
                          title: "Deep\nMeditation",
                          backgroundColor: Colors.grey.shade200,
                          icon: Icons.arrow_outward,
                          width: width,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HealthBodyHomepageScreen(),
                              ),
                            );
                          },
                        ),
                        // _PracticeCard(
                        //   title: "Arabic\nMental Heal",
                        //   backgroundColor: Colors.white,
                        //   icon: Icons.arrow_outward,
                        //   width: constraints.maxWidth,
                        //   onTap: () {
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (_) => DashboardScreen(),
                        //     //   ),
                        //     // );
                        //   },
                        // ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.spacing16),
              const _BottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [Icon(Icons.apps), Icon(Icons.search)],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final IconData icon;
  final String? image;
  final double width;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.title,
    required this.backgroundColor,
    required this.icon,
    this.image,
    required this.width,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        padding: const EdgeInsets.all(AppConstants.spacing16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.spacing16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacing8),
                child: Image.asset(image!, height: 50),
              ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppConstants.spacing8),
            Align(alignment: Alignment.bottomRight, child: Icon(icon)),
          ],
        ),
      ),
    );
  }
}
