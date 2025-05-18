import 'package:consulationapp/models/consulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Admin management methods
  Future<User?> registerAdmin({
    required String email,
    required String password,
    required String name,
    required String adminSecret,
  }) async {
    const validSecret = "Admin@011"; // Change in production!
    if (adminSecret != validSecret) {
      throw 'Invalid admin secret';
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final appUser = AppUser(
        email: email,
        name: name,
        createdAt: DateTime.now(),
        isAdmin: true,
        roles: ['admin'],
      );
      
      await _firestore.collection('users')
        .doc(userCredential.user!.uid)
        .set(appUser.toFirestore());
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code);
    }
  }

  Future<bool> isAdmin() async {
    if (currentUser == null) return false;
    final doc = await _firestore.collection('users')
      .doc(currentUser!.uid)
      .get();
    return doc.exists && (doc.data() as Map<String, dynamic>)['isAdmin'] == true;
  }

  // Existing methods with improvements
  Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'Logout failed: $e';
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code);
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final appUser = AppUser(
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('users')
        .doc(userCredential.user!.uid)
        .set(appUser.toFirestore());
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code);
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'invalid-email': return 'Invalid email address';
      case 'weak-password': return 'Password must be 8+ chars with @ symbol';
      case 'email-already-in-use': return 'Email already registered';
      case 'user-not-found': return 'User not found';
      case 'wrong-password': return 'Incorrect password';
      default: return 'Authentication failed';
    }
  }

  // Consultation methods with admin access
  CollectionReference get _consultationsCollection => _firestore.collection('consultations');

  // In AuthService class

Future<void> addConsultation({
  required String name,
  required String code,
  required String topic,
  required String notes,
  required DateTime dateTime,
  required String lecturerId,
  required String lecturerName,
}) async {
  if (currentUser == null) throw Exception('User not authenticated');
  
  await _consultationsCollection.add({
    'name': name,
    'code': code,
    'topic': topic,
    'notes': notes,
    'dateTime': dateTime,
    'lecturerId': lecturerId,
    'lecturerName': lecturerName,
    'studentId': currentUser!.uid,
    'createdAt': DateTime.now(),
  });
  notifyListeners();
}

Future<void> updateConsultation({
  required String consultationId,
  required String name,
  required String code,
  required String topic,
  required String notes,
  required DateTime dateTime,
  required String lecturerId,
  required String lecturerName,
}) async {
  await _consultationsCollection.doc(consultationId).update({
    'name': name,
    'code': code,
    'topic': topic,
    'notes': notes,
    'dateTime': dateTime,
    'lecturerId': lecturerId,
    'lecturerName': lecturerName,
    'updatedAt': DateTime.now(),
  });
  notifyListeners();
}

  Future<void> deleteConsultation(String id) async {
    if (currentUser == null) throw Exception('Authentication required');
    
    final doc = await _consultationsCollection.doc(id).get();
    if (!doc.exists) throw Exception('Consultation not found');
    
    final data = doc.data() as Map<String, dynamic>;
    if (data['studentId'] != currentUser!.uid && !(await isAdmin())) {
      throw Exception('Not authorized');
    }

    await _consultationsCollection.doc(id).delete();
    notifyListeners();
  }

  Stream<List<Consultation>> getConsultations() {
    if (currentUser == null) throw Exception('Authentication required');
    
    return _consultationsCollection
      .where('studentId', isEqualTo: currentUser!.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .handleError((error) => throw _handleFirestoreError(error))
      .map((snapshot) => snapshot.docs
        .map((doc) => Consultation.fromFirestore(doc))
        .toList());
  }

  Future<AppUser?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  Stream<List<Consultation>> getAllConsultations() {
    if (currentUser == null) throw Exception('Authentication required');
    
    return _consultationsCollection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .handleError((error) => throw _handleFirestoreError(error))
      .map((snapshot) => snapshot.docs
        .map((doc) => Consultation.fromFirestore(doc))
        .toList());
  }

  String _handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied': return 'Permission denied';
      case 'not-found': return 'Document not found';
      default: return 'Database error: ${e.message}';
    }
  }
  
}