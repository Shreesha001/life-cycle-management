// lib/features/my_diary/services/diary_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryService {
  final CollectionReference _diaryCollection =
      FirebaseFirestore.instance.collection('diary_entries');
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  // Add a new diary entry
  Future<void> addEntry(Map<String, dynamic> entry) async {
    if (_userId == null) throw Exception('User not logged in');
    final entryWithUser = {
      ...entry,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': _userId,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };
    await _diaryCollection.doc(entryWithUser['id']).set(entryWithUser);
  }

  // Update an existing diary entry
  Future<void> updateEntry(String id, Map<String, dynamic> updatedEntry) async {
    if (_userId == null) throw Exception('User not logged in');
    final entryWithUser = {
      ...updatedEntry,
      'userId': _userId,
      'updatedAt': Timestamp.now(),
    };
    await _diaryCollection.doc(id).update(entryWithUser);
  }

  // Delete a diary entry
  Future<void> deleteEntry(String id) async {
    if (_userId == null) throw Exception('User not logged in');
    await _diaryCollection.doc(id).delete();
  }

  // Stream to get all diary entries for the current user
  Stream<List<Map<String, dynamic>>> getEntries() {
    if (_userId == null) throw Exception('User not logged in');
    return _diaryCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
}