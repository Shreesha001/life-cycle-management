import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepCycleStaticsScreen extends StatefulWidget {
  const SleepCycleStaticsScreen({super.key});

  @override
  State<SleepCycleStaticsScreen> createState() =>
      _SleepCycleStaticsScreenState();
}

class _SleepCycleStaticsScreenState extends State<SleepCycleStaticsScreen> {
  String selectedTab = 'Days';
  int selectedDayIndex = DateTime.now().weekday % 7; // Sunday = 0


  List<FlSpot> _getChartData() {
    switch (selectedTab) {
      case 'Weeks':
        return [
          FlSpot(0, 1.2),
          FlSpot(1, 2),
          FlSpot(2, 2.5),
          FlSpot(3, 1.8),
          FlSpot(4, 2.1),
          FlSpot(5, 1.7),
          FlSpot(6, 2.2),
        ];
      case 'Months':
        return [
          FlSpot(0, 2),
          FlSpot(1, 2.5),
          FlSpot(2, 3),
          FlSpot(3, 2.8),
          FlSpot(4, 3.2),
          FlSpot(5, 3),
          FlSpot(6, 3.1),
        ];
      case 'All':
        return [
          FlSpot(0, 1),
          FlSpot(1, 1.3),
          FlSpot(2, 1.6),
          FlSpot(3, 1.9),
          FlSpot(4, 2.2),
          FlSpot(5, 2.5),
          FlSpot(6, 2.8),
        ];
      case 'Days':
      default:
        return [
          FlSpot(0, 1),
          FlSpot(1, 1.5),
          FlSpot(2, 1.4),
          FlSpot(3, 3.4),
          FlSpot(4, 2),
          FlSpot(5, 2.2),
          FlSpot(6, 1.8),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081C2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Statistics', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(),
            const SizedBox(height: 20),
            _buildDayBar(),
            const SizedBox(height: 20),
            _buildChartSection('Sleep quality'),
            _buildChartSection('Regularity'),
            _buildChartSection('Went to bed'),
            _buildChartSection('Woke up'),
            _buildChartSection('Time in bed'),
            _buildChartSection('Asleep'),
            _buildChartSection('Asleep after'),
            _buildChartSection('Snore'),
            _buildChartSection('Steps'),
            _buildChartSection('Light'),
            _buildChartSection('Ambient noise'),
            _buildChartSection('Breathing disruptions'),
            const SizedBox(height: 20),
            _buildPremiumBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Days', 'Weeks', 'Months', 'All'];
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2C44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            tabs
                .map((tab) => _tabItem(tab, isSelected: tab == selectedTab))
                .toList(),
      ),
    );
  }

  Widget _tabItem(String label, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayBar() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        final isSelected = selectedDayIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDayIndex = index;
            });
          },
          child: CircleAvatar(
            radius: 18,
            backgroundColor: isSelected ? Colors.blue : const Color(0xFF0E2C44),
            child: Text(
              days[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }


  Widget _buildChartSection(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2C44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title ($selectedTab)',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('More >', style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: Colors.lightBlueAccent,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            'Upgrade to premium for unlimited access.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {},
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
