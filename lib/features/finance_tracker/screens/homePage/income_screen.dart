import 'package:merge_app/features/finance_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum TimeFilter { day, week, month, year, all }

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  TimeFilter _selectedFilter = TimeFilter.day;

  final Map<TimeFilter, Map<String, dynamic>> _incomeData = {
    TimeFilter.day: {"salary": 4.25, "passive": 10.25, "total": 14.50},
    TimeFilter.week: {"salary": 30.0, "passive": 25.0, "total": 55.0},
    TimeFilter.month: {"salary": 120.0, "passive": 100.0, "total": 220.0},
    TimeFilter.year: {"salary": 1400.0, "passive": 1600.0, "total": 3000.0},
    TimeFilter.all: {"salary": 3200.0, "passive": 2000.0, "total": 5200.0},
  };

  void _updateFilter(TimeFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _incomeData[_selectedFilter]!;
    final salary = data["salary"] as double;
    final passive = data["passive"] as double;
    final total = data["total"] as double;

    final salaryPercent = (salary / total) * 100;
    final passivePercent = (passive / total) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Income",
          style: TextStyle(
            color: Colors.black,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Filters
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.spacing16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    TimeFilter.values.map((filter) {
                      final label =
                          {
                            TimeFilter.day: '1D',
                            TimeFilter.week: '1W',
                            TimeFilter.month: '1M',
                            TimeFilter.year: '1Y',
                            TimeFilter.all: 'All',
                          }[filter]!;

                      final selected = filter == _selectedFilter;

                      return GestureDetector(
                        onTap: () => _updateFilter(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selected ? Colors.orange : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppConstants.spacing16,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),

            // Pie Chart
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppConstants.spacing16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: salaryPercent,
                                title: "${salaryPercent.toStringAsFixed(0)}%",
                                color: Colors.blue,
                                radius: 40,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                              PieChartSectionData(
                                value: passivePercent,
                                title: "${passivePercent.toStringAsFixed(0)}%",
                                color: Colors.white,
                                radius: 40,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                            ],
                            startDegreeOffset: -90,
                            sectionsSpace: 0,
                            centerSpaceRadius: 100,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Total Income",
                              style: TextStyle(
                                color: Colors.white54,
                                fontFamily: AppConstants.fontFamily,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spacing8),
                            Text(
                              "\$${total.toStringAsFixed(2)} K",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: AppConstants.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _incomeDetail("Passive Income", passive, Colors.white),
                      _incomeDetail("Salary", salary, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacing24),

            // Earnings Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Earnings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6,
                                  width: 50,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const Text(
                                  "All Earnings",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children:
                                      [
                                        _EarningCard(
                                          title: "Upwork",
                                          amount: "\$2,480.00",
                                          backgroundColor:
                                              Colors.lightGreenAccent,
                                        ),
                                        _EarningCard(
                                          title: "Fiverr",
                                          amount: "\$3,000",
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                        ),
                                        _EarningCard(
                                          title: "Travel",
                                          amount: "\$1,580",
                                          backgroundColor: Colors.purpleAccent,
                                        ),
                                      ].map((card) {
                                        return SizedBox(
                                          width: screenWidth * 0.42,
                                          child: card,
                                        );
                                      }).toList(),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacing16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _EarningCard(
                    title: "Upwork",
                    amount: "\$2,480.00",
                    backgroundColor: Colors.lightGreenAccent,
                  ),
                  const SizedBox(width: AppConstants.spacing16),
                  _EarningCard(
                    title: "Fiverr",
                    amount: "\$3,000",
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  const SizedBox(width: AppConstants.spacing16),
                  _EarningCard(
                    title: "Travel",
                    amount: "\$1,580",
                    backgroundColor: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _incomeDetail(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: AppConstants.spacing8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacing8),
        Text(
          "\$${amount.toStringAsFixed(2)}K",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }
}

class _EarningCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color backgroundColor;

  const _EarningCard({
    required this.title,
    required this.amount,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.35,
      height: screenHeight * 0.15,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text(
                  title.isNotEmpty ? title[0] : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
