import 'dart:io';

import 'package:consulationapp/views/widgets/profile_details.dart';
import 'package:consulationapp/views/widgets/profile_image.dart';
import 'package:consulationapp/views/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:consulationapp/viewmodels/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load user data when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserData(context);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .updateImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImage(onImagePick: _pickImage),
              const SizedBox(height: 20),
              const ProfileDetails(),
              const SizedBox(height: 30),
              const UpdateButton(),
            ],
          ),
        ),
      ),
    );
  }
}