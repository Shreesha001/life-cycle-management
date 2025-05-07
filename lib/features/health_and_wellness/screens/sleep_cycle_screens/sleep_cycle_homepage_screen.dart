import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SleepCycleHomepageScreen extends StatefulWidget {
  const SleepCycleHomepageScreen({super.key});

  @override
  State<SleepCycleHomepageScreen> createState() =>
      _SleepCycleHomepageScreenState();
}

class _SleepCycleHomepageScreenState extends State<SleepCycleHomepageScreen> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 6, minute: 0);
  final PageController _pageController = PageController();
  int currentPage = 0;

  void _onTimeChanged(DateTime newTime) {
    setState(() {
      selectedTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03192E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSleepAidBar(),
            const SizedBox(height: 40),

            // PageView with alarm modes
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildAlarmSetPage(),
                  _anotherSleepMode(),
                  _buildNoAlarmPage(),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildPageIndicator(),

            const SizedBox(height: 16),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepAidBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF002A3A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Sleep aid",
                style: TextStyle(
                  color: Color(0xFF00E6F6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Color(0xFF00E6F6)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmSetPage() {
    final hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          child: CupertinoTheme(
            data: const CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              initialDateTime: DateTime(
                2023,
                1,
                1,
                selectedTime.hour,
                selectedTime.minute,
              ),
              onDateTimeChanged: _onTimeChanged,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Wake up easy between",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          "$hour:$minute $period",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 24),
        _buildStartButton(const Color(0xFFFF8C00)),
      ],
    );
  }

  Widget _buildNoAlarmPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "No alarm",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const Text(
          "Only sleep analyzed",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
        _buildStartButton(const Color(0xFF144454)),
      ],
    );
  }

  Widget _anotherSleepMode() {
    final hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    final minute = selectedTime.minute.toString().padLeft(2, '0');
    final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          child: CupertinoTheme(
            data: const CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              initialDateTime: DateTime(
                2023,
                1,
                1,
                selectedTime.hour,
                selectedTime.minute,
              ),
              onDateTimeChanged: _onTimeChanged,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "No wakeup window.",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          "Alarm will go off at $hour:$minute $period",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 24),
        _buildStartButton(const Color(0xFF00E6F6)),
      ],
    );
  }

  Widget _buildStartButton(Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      onPressed: () {},
      child: const Text(
        "Start",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                currentPage == index
                    ? Colors.orange
                    : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: const Color(0xFF003E38),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Sleep better with Premium",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Try"),
          ),
        ],
      ),
    );
  }
}
