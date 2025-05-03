import 'package:flutter/material.dart';

class TodaysEventScreen extends StatelessWidget {
  final String eventType;
  final List<Map<String, String>> events;

  const TodaysEventScreen({required this.eventType, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventType),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            events.isEmpty
                ? Center(child: Text("No $eventType today"))
                : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(event['name']![0])),
                      title: Text(event['name']!),
                      subtitle: Text(event['description'] ?? ''),
                    );
                  },
                ),
      ),
    );
  }
}
