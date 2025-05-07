import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddPeriodLifecycleScreen extends StatefulWidget {
  const AddPeriodLifecycleScreen({super.key});

  @override
  State<AddPeriodLifecycleScreen> createState() =>
      _AddPeriodLifecycleScreenState();
}

class _AddPeriodLifecycleScreenState extends State<AddPeriodLifecycleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: GestureDetector(
          onTap: () {
            setState(() {
              _calendarFormat =
                  _calendarFormat == CalendarFormat.week
                      ? CalendarFormat.month
                      : CalendarFormat.week;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${DateFormat.MMMM().format(_focusedDay)} ${_focusedDay.year}",
                style: const TextStyle(fontSize: 18),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {},
              headerVisible: false,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            cycleCard(),
            const SizedBox(height: 24),
            sectionTitle("Sexual activity"),
            activityIcons([
              {'icon': Icons.favorite, 'label': 'Unprotected sex'},
              {'icon': Icons.lock, 'label': 'Protected sex'},
              {'icon': Icons.favorite_border, 'label': 'Masturbation'},
              {'icon': Icons.mood, 'label': 'Kissing'},
            ]),
            const SizedBox(height: 24),
            sectionTitle("Symptoms", action: "Show all"),
            activityIcons([
              {'icon': Icons.favorite, 'label': 'Abdominal cramps'},
              {'icon': Icons.brightness_1, 'label': 'Spotting'},
              {'icon': Icons.battery_alert, 'label': 'Fatigue'},
              {'icon': Icons.bubble_chart, 'label': 'Bloating'},
              {'icon': Icons.waves, 'label': 'Backache'},
              {'icon': Icons.flash_on, 'label': 'Cramps'},
              {'icon': Icons.error, 'label': 'Headache'},
              {'icon': Icons.air, 'label': 'Flatulence'},
            ]),
            const SizedBox(height: 24),
            sectionTitle("Moods", action: "Show all"),
            activityIcons([
              {'icon': Icons.bedtime, 'label': 'Sleepy'},
              {'icon': Icons.mood_bad, 'label': 'Stressed'},
              {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Exhausted'},
              {'icon': Icons.sentiment_dissatisfied, 'label': 'Emotional'},
              {'icon': Icons.sentiment_satisfied, 'label': 'Normal'},
              {'icon': Icons.sentiment_neutral, 'label': 'Tense'},
              {'icon': Icons.mood, 'label': 'Depressed'},
              {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Sad'},
            ]),
            const SizedBox(height: 24),
            sectionTitle("Contraception", action: "Configure"),
            Row(
              children: const [
                PillIcon(text: "Yesterday’s pill"),
                SizedBox(width: 16),
                PillIcon(text: "Today’s pill"),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            listTile("Notes"),
            listTile("Medicine"),
            listTile("Temperature"),
            listTile("Weight"),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("Customize list"),
            ),
          ],
        ),
      ),
    );
  }

  Widget cycleCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("My Cycle"),
              subtitle: const Text("Period starts today"),
              trailing: const Icon(Icons.check_circle, color: Colors.pink),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                4,
                (_) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.opacity, color: Colors.pinkAccent),
                ),
              ),
            ),
            const Divider(height: 24),
            Container(
              width: double.infinity,
              color: Colors.pink.shade50.withOpacity(0.2),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("1st day of period"),
                  Text("9 days until fertile"),
                  Text("14 days until ovulation"),
                  Text("1st day of cycle"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (action != null)
          TextButton(
            onPressed: () {},
            child: Text(action, style: const TextStyle(color: Colors.pink)),
          ),
      ],
    );
  }

  Widget activityIcons(List<Map<String, dynamic>> icons) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          icons
              .map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.pink.shade50,
                      child: Icon(item['icon'], color: Colors.pink, size: 28),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 70,
                      child: Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  Widget listTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class PillIcon extends StatelessWidget {
  final String text;

  const PillIcon({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.medication, color: Colors.purpleAccent),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
