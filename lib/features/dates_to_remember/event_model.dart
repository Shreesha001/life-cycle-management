// lib/features/dates_to_remember/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDateTime;
  final int notifyBeforeMinutes;
  final String userId;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDateTime,
    required this.notifyBeforeMinutes,
    required this.userId,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      eventDateTime: (data['eventDateTime'] as Timestamp).toDate(),
      notifyBeforeMinutes: data['notifyBeforeMinutes'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'eventDateTime': Timestamp.fromDate(eventDateTime),
      'notifyBeforeMinutes': notifyBeforeMinutes,
      'userId': userId,
    };
  }
}