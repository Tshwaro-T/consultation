import 'package:consulationapp/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profileViewModel.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          profileViewModel.role,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Text(
          'Email: ${profileViewModel.email}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Phone: ${profileViewModel.phone}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}