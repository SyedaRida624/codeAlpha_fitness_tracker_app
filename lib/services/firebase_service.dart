import 'package:cloud_firestore/cloud_firestore.dart';

// Renamed to FitnessService to eliminate the naming clash completely
class FitnessService {
  final CollectionReference _activityCollection =
  FirebaseFirestore.instance.collection('fitness_activities');

  Stream<QuerySnapshot> getActivitiesStream() {
    return _activityCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addActivity(String type, int duration, int calories) async {
    await _activityCollection.add({
      'type': type,
      'duration': duration,
      'calories': calories,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}