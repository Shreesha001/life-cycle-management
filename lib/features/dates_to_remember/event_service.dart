// lib/features/dates_to_remember/services/event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:merge_app/features/dates_to_remember/event_model.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Stream<List<EventModel>> getEvents() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  Future<void> addEvent(EventModel event) async {
    await _eventsCollection.add(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}