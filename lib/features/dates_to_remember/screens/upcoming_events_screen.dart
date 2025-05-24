import 'package:merge_app/features/dates_to_remember/screens/reminder_modal.dart';
import 'package:merge_app/features/dates_to_remember/screens/todays_events_screen.dart';
import 'package:merge_app/core/colors.dart';
import 'package:flutter/material.dart';

// ✅ Move this to the top
class EventCard extends StatelessWidget {
  final String name;
  final String description;
  final String? avatar;
  final String? initials;
  final bool actions;
  final bool reminder;

  const EventCard({
    required this.name,
    required this.description,
    this.avatar,
    this.initials,
    this.actions = false,
    this.reminder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          avatar != null
              ? CircleAvatar(backgroundImage: NetworkImage(avatar!), radius: 24)
              : CircleAvatar(child: Text(initials ?? ''), radius: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          if (actions) ...[
            IconButton(icon: Icon(Icons.call), onPressed: () {}),
            IconButton(icon: Icon(Icons.message), onPressed: () {}),
          ] else if (reminder) ...[
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.grey[700]),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) => ReminderModal(name: name),
                );
              },
              tooltip: 'Set reminder',
            ),
          ],
        ],
      ),
    );
  }
}

// ✅ Now the EventCard class is defined before use
class UpcomingEventsScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> todayEvents = {
    'Birthday': [
      {'name': 'John Appleseed', 'description': '🎉 Turning 247'},
    ],
    'Anniversary': [],
    'Subscription reminder': [],
    'Bank mandates': [],
    'Trial': [],
    'Gift card expiring date': [],
  };

  final Map<String, IconData> eventIcons = {
    'Birthday': Icons.cake,
    'Anniversary': Icons.favorite,
    'Subscription reminder': Icons.subscriptions,
    'Bank mandates': Icons.account_balance,
    'Trial': Icons.timer,
    'Gift card expiring date': Icons.card_giftcard,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48),
            Text(
              'TUESDAY, APRIL 30, 2025',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),

            SizedBox(height: 24),
            Text(
              "Today's Events",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    todayEvents.entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => TodaysEventScreen(
                                        eventType: entry.key,
                                        events: entry.value,
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blue[100],
                                    child: Icon(
                                      eventIcons[entry.key] ?? Icons.event,
                                      color: Colors.blue[800],
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Upcoming Birthdays',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0),
            Expanded(
              child: ListView(
                children: [
                  EventCard(
                    name: 'Cara Smith',
                    description: 'Feb. 29 in 41 days',
                    avatar: 'https://i.imgur.com/BoN9kdC.png',
                    reminder: true,
                  ),
                  EventCard(
                    name: 'Jeffrey Li',
                    description: 'Dec. 5 in 320 days',
                    initials: 'J.L.',
                    reminder: true,
                  ),
                  EventCard(
                    name: 'Albert Lee',
                    description: 'Jan. 8 in 354 days',
                    initials: 'A.L.',
                    reminder: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
