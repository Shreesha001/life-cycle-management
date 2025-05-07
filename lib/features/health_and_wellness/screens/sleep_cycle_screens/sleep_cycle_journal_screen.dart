import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepCycleJournalScreen extends StatelessWidget {
  const SleepCycleJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071C2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wednesday',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildDaySelectorBar(),
            const SizedBox(height: 16),
            _buildTopSection(),
            const SizedBox(height: 20),
            _buildSleepChart(),
            const SizedBox(height: 20),
            _buildStatisticsRow(),
            const SizedBox(height: 20),
            _buildAdditionalInfo(),
            const SizedBox(height: 20),
            _buildAlertnessCard(),
            const SizedBox(height: 20),
            _buildBreathingCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: 0.75,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade800,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
            const Text(
              '75%\nQuality',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('8h 12m', style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(
              'In bed',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text('7h 57m', style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(
              'Asleep',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const Spacer(),
        Icon(Icons.share, color: Colors.white),
      ],
    );
  }

  Widget _buildSleepChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2B3D),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Stages',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: const Color(0xFF0C2B3D),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget:
                          (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        if (value == 0)
                          return const Text(
                            "Deep",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        if (value == 1)
                          return const Text(
                            "Sleep",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        if (value == 2)
                          return const Text(
                            "Awake",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                minX: 2,
                maxX: 10,
                minY: 0,
                maxY: 2,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(2, 2),
                      FlSpot(3, 1),
                      FlSpot(4, 0),
                      FlSpot(5, 1),
                      FlSpot(6, 1.2),
                      FlSpot(7, 1.8),
                      FlSpot(8, 1),
                      FlSpot(9, 1.5),
                      FlSpot(10, 2),
                    ],
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelectorBar() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final todayIndex = DateTime.now().weekday % 7; // Sunday as index 0

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (index) {
        final isSelected = index == todayIndex;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            days[index],
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatisticsRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: const [
        _StatCard(icon: Icons.bedtime, label: '95%', subLabel: 'Regularity'),
        _StatCard(icon: Icons.timer, label: '15 min', subLabel: 'Asleep after'),
        _StatCard(
          icon: Icons.nightlight_round,
          label: '1:47 AM',
          subLabel: 'Went to bed',
        ),
        _StatCard(icon: Icons.wb_sunny, label: '10:00 AM', subLabel: 'Woke up'),
        _StatCard(icon: Icons.snooze, label: '8 min', subLabel: 'Snore'),
        _StatCard(
          icon: Icons.directions_walk,
          label: '5920',
          subLabel: 'Steps',
        ),
        _StatCard(
          icon: Icons.emoji_emotions,
          label: 'Good',
          subLabel: 'Wake up mood',
        ),
        _StatCard(icon: Icons.cloud, label: '54°F', subLabel: 'Weather'),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          tileColor: const Color(0xFF12334A),
          title: const Text(
            'Sleep Goal',
            style: TextStyle(color: Colors.white),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: const Text('Add new', style: TextStyle(color: Colors.amber)),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            Chip(
              label: const Text('Worked out'),
              backgroundColor: const Color(0xFF1F445C),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text('Edit sleep notes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F445C),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Sounds',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF12334A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text("Sound items", style: TextStyle(color: Colors.white54)),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertnessCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12334A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beta Alertness',
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Test available until 12:00 PM',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/period_dates/image/meditation.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Play our alertness game and see how sharp you are today. It takes only 1 minute.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Test alertness'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12334A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Breathing disruptions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get premium to track your breathing disruptions.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: Center(child: const Text('Unlock')),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.amber,
              side: const BorderSide(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF12334A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subLabel,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
