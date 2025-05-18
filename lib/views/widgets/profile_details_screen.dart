/*
 * Student Numbers:        221001482,        222043497,                   2221013309,              221014333,            222075927
 * Student Names:  Koena Mosa Ramela, Tshwaro Thothela, Selloane Relebohile Letsoara, Vinjiwe Onica Precious, Lesego Ignician Moutlana
 * Question: Profile Details Screen
 */

import 'package:flutter/material.dart';
import 'profile_image.dart';
import 'profile_details.dart';
import 'update_button.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileImage(onImagePick: () {  },), 
            const SizedBox(height: 20),
            const ProfileDetails(), 
            const SizedBox(height: 20),
            const UpdateButton(), 
          ],
        ),
      ),
    );
  }
}