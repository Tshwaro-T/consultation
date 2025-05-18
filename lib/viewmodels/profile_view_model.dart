import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel with ChangeNotifier {
  String _name = 'Loading...';
  String _role = 'Student';
  String _email = 'Loading...';
  String _phone = 'Not provided';
  File? _image;

  String get name => _name;
  String get role => _role;
  String get email => _email;
  String get phone => _phone;
  File? get image => _image;

  Future<void> loadUserData(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    
    if (user != null) {
      _name = user.displayName ?? 'No name provided';
      _email = user.email ?? 'No email provided';
      // You might want to fetch additional user data from Firestore here
      notifyListeners();
    }
  }

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updatePhone(String newPhoneNumber) {
    _phone = newPhoneNumber;
    notifyListeners();
  }

  void updateImage(File newImage) {
    _image = newImage;
    notifyListeners();
  }
}