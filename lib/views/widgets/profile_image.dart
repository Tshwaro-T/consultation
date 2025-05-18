import 'package:consulationapp/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  final VoidCallback onImagePick;
  
  const ProfileImage({super.key, required this.onImagePick});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    
    return GestureDetector(
      onTap: onImagePick,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: profileViewModel.image != null 
            ? FileImage(profileViewModel.image!) 
            : const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png') as ImageProvider,
        child: profileViewModel.image == null 
            ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
            : null,
      ),
    );
  }
}