import 'package:flutter/material.dart';
import 'package:merge_app/core/theme/theme.dart';

class PeriodStatisticsScreen extends StatelessWidget {
  const PeriodStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: const TabBar(
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.pink,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Cycles'),
                Tab(text: 'Logs'),
                Tab(text: 'Timeline'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [_CyclesTab(), _LogsTab(), _TimelineTab()],
        ),
      ),
    );
  }
}

class _LogsTab extends StatelessWidget {
  const _LogsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji row (simulated using text emojis)
            const Text(
              '😅 😘 ❤️ 😀 💊',
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Start logging your wellbeing information to view it as a chart',
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Log',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CyclesTab extends StatelessWidget {
  const _CyclesTab();

  Widget _buildCard({
    required String title,
    required String message,
    bool showLog = true,
    bool isPremium = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              if (isPremium)
                Row(
                  children: const [
                    Icon(Icons.paid, size: 16, color: Colors.pink),
                    SizedBox(width: 4),
                    Text(
                      'Premium',
                      style: TextStyle(color: Colors.pink, fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          if (showLog) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Log',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildCard(
          title: 'Last Cycle',
          message: 'Please log one finished cycle',
        ),
        _buildCard(
          title: 'Last Period',
          message: 'Please log one finished period',
        ),
        _buildCard(
          title: 'Cycle length',
          message: 'Please log two or more cycles to view this chart',
        ),
        _buildCard(
          title: 'Period length',
          message: 'Please log at least one finished period to view this chart',
        ),
        _buildCard(
          title: 'Chance of getting pregnant',
          message:
              'Get to know how each phase of your cycle affects your chances of getting pregnant',
          showLog: false,
          isPremium: true,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Try for free',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _TimelineCard(
          date: '05',
          monthYear: 'May 2025',
          dayInfo: '5th day of period',
          fertileIn: '5 days until fertile',
          ovulationIn: '10 days until ovulation',
          cycleDay: '5th day of cycle',
          flowLevel: 3,
        ),
        SizedBox(height: 12),
        _TimelineCard(
          date: '01',
          monthYear: 'May 2025',
          dayInfo: '1st day of period',
          fertileIn: '9 days until fertile',
          ovulationIn: '14 days until ovulation',
          cycleDay: '1st day of cycle',
          flowLevel: 4,
          contraception: 'Yesterday’s pill, Today’s pill',
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final String date;
  final String monthYear;
  final String dayInfo;
  final String fertileIn;
  final String ovulationIn;
  final String cycleDay;
  final int flowLevel; // 1 to 5 drops
  final String? contraception;

  const _TimelineCard({
    required this.date,
    required this.monthYear,
    required this.dayInfo,
    required this.fertileIn,
    required this.ovulationIn,
    required this.cycleDay,
    required this.flowLevel,
    this.contraception,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(monthYear, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(width: 16),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dayInfo, style: const TextStyle(fontSize: 14)),
                Text(fertileIn, style: const TextStyle(fontSize: 14)),
                Text(ovulationIn, style: const TextStyle(fontSize: 14)),
                Text(cycleDay, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Flow",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(5, (index) {
                      return Icon(
                        Icons.water_drop,
                        size: 16,
                        color:
                            index < flowLevel
                                ? Colors.pink
                                : Colors.grey.shade300,
                      );
                    }),
                  ],
                ),
                if (contraception != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    "Contraception",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    children:
                        contraception!
                            .split(',') // Split by comma
                            .map(
                              (pillText) => Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.medication,
                                    size: 16,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pillText.trim(), // Trim extra spaces
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
