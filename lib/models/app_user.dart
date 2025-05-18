import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final String name;
  final DateTime createdAt;
  final bool isAdmin;
  final List<String> roles; // For future role-based access

  AppUser({
    required this.email,
    required this.name,
    required this.createdAt,
    this.isAdmin = false,
    this.roles = const [],
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      email: data['email'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isAdmin: data['isAdmin'] ?? false,
      roles: List<String>.from(data['roles'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
      'roles': roles,
    };
  }

  bool hasRole(String role) => roles.contains(role);
}