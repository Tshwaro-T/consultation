// consultation.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  final String id;
  final String name;
  final String code;
  final String studentId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String lecturerId;
  final String lecturerName;
  final DateTime dateTime;
  final String topic;
  final String? notes;

  Consultation({
    required this.id,
    required this.name,
    required this.code,
    required this.studentId,
    required this.createdAt,
    this.updatedAt,
    required this.lecturerId,
    required this.lecturerName,
    required this.dateTime,
    required this.topic,
    this.notes,
  });

  factory Consultation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Consultation(
      id: doc.id,
      name: data['name'] as String,
      code: data['code'] as String,
      studentId: data['studentId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      lecturerId: data['lecturerId'] as String,
      lecturerName: data['lecturerName'] as String,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      topic: data['topic'] as String,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'code': code,
      'studentId': studentId,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'dateTime': dateTime,
      'topic': topic,
      if (notes != null) 'notes': notes,
    };
  }
}