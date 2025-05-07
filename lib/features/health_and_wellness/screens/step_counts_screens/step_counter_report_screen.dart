import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StepCounterReportScreen extends StatelessWidget {
  const StepCounterReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3C),
        elevation: 0,
        title: const Text('Report', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerProgressCard(),
            const SizedBox(height: 24),
            _sectionCard(title: "Week", child: _weekSection()),
            const SizedBox(height: 16),
            _toggleTabBar(),
            const SizedBox(height: 16),
            _sectionCard(title: "Today", child: _todayChart()),
            const SizedBox(height: 16),
            _sectionCard(title: "Month", child: _monthChart()),
          ],
        ),
      ),
     
    );
  }

  Widget _headerProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                child: const Text("3K", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Away from Sofa",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Text(
                "3000 ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("steps left", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.5,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              const Text("MORE", style: TextStyle(color: Colors.greenAccent)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

 Widget _weekSection() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 6000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  if (value == 5000) {
                    return const Text(
                      '5000',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = ['S', 'M', 'T', 'W', 'TODAY', 'F', 'S'];
                  return Text(
                    days[value.toInt()],
                    style: TextStyle(
                      color: value == 4 ? Colors.greenAccent : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            final isToday = i == 4;
            final y =
                [3000, 4500, 2500, 4000, 5000, 2000, 1000][i]; // example data
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: y.toDouble(),
                  width: 16,
                  color: isToday ? Colors.greenAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _toggleTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF153A67),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toggleChip(label: "STEP", selected: true),
          _toggleChip(label: "CALORIE"),
          _toggleChip(label: "TIME"),
          _toggleChip(label: "DISTANCE"),
        ],
      ),
    );
  }

  Widget _toggleChip({required String label, bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.greenAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _todayChart() {
    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 6000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final labels = ['06:00 AM', '12:00 PM', '06:00 PM'];
                  if (value >= 0 && value < labels.length) {
                    return Text(
                      labels[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 1500,
                  width: 20,
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 2500,
                  width: 20,
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 5000,
                  width: 20,
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _monthChart() {
    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 6000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final labels = [
                    'May 3',
                    'May 9',
                    'May 15',
                    'May 21',
                    'May 27',
                  ];
                  if (value >= 0 && value < labels.length) {
                    return Text(
                      labels[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(5, (index) {
            final heights = [3000, 4000, 2000, 5000, 3500];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: heights[index].toDouble(),
                  width: 20,
                  color: index == 3 ? Colors.greenAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }


 
}
