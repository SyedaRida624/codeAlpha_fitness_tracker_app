import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String id;
  final String type;
  final int duration;
  final int calories;
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.type,
    required this.duration,
    required this.calories,
    required this.timestamp,
  });

  factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ActivityLog(
      id: doc.id,
      type: data['type'] ?? 'Unknown',
      duration: data['duration'] ?? 0,
      calories: data['calories'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}