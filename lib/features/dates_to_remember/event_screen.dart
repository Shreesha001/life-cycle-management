import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merge_app/core/colors.dart';
import 'package:merge_app/features/dates_to_remember/event_model.dart';
import 'package:merge_app/features/dates_to_remember/event_service.dart';
import 'package:merge_app/features/dates_to_remember/notification_service.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'My Events',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: Provider.of<EventService>(context).getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No events found',
                style: TextStyle(color: primaryColor, fontSize: 18),
              ),
            );
          }

          final events = snapshot.data!;
          final now = DateTime.now();
          final todayEvents = events.where((event) =>
              event.eventDateTime.day == now.day &&
              event.eventDateTime.month == now.month &&
              event.eventDateTime.year == now.year).toList();
          final upcomingEvents = events
              .where((event) => event.eventDateTime.isAfter(now))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todayEvents.isNotEmpty) ...[
                  _buildSectionTitle('Today\'s Events'),
                  const SizedBox(height: 12),
                  ...todayEvents.map((event) => _buildEventCard(context, event)),
                  const SizedBox(height: 24),
                ],
                _buildSectionTitle('Upcoming Events'),
                const SizedBox(height: 12),
                if (upcomingEvents.isNotEmpty)
                  ...upcomingEvents.map((event) => _buildEventCard(context, event))
                else
                  const Text(
                    'No upcoming events',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    final now = DateTime.now();
    final diff = event.eventDateTime.difference(now);
    final isPast = diff.isNegative;

    final String timeText = isPast
        ? 'Event Passed'
        : diff.inDays >= 1
            ? 'In ${diff.inDays} day${diff.inDays > 1 ? 's' : ''}'
            : diff.inHours >= 1
                ? 'In ${diff.inHours} hour${diff.inHours > 1 ? 's' : ''}'
                : 'In ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}';

    final dateFormatted =
        DateFormat('EEE, MMM d • hh:mm a').format(event.eventDateTime);

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.event, color: primaryColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (event.description.isNotEmpty)
                    Text(
                      event.description,
                      style: const TextStyle(color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormatted,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeText,
                    style: TextStyle(
                      color: isPast ? Colors.red : secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, event),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<EventService>(context, listen: false)
                  .deleteEvent(event.id);
              await NotificationService().cancelNotification(event.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}