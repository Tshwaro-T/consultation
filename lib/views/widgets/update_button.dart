import 'package:consulationapp/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showUpdateDialog(context),
      child: const Text('Update Details'),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final TextEditingController nameController = TextEditingController(text: profileViewModel.name);
    final TextEditingController roleController = TextEditingController(text: profileViewModel.role);
    final TextEditingController emailController = TextEditingController(text: profileViewModel.email);
    final TextEditingController phoneController = TextEditingController(text: profileViewModel.phone);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Your Details'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                  ),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter your role' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter your email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter your phone number';
                      if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  profileViewModel.updateName(nameController.text);
                  profileViewModel.updateRole(roleController.text);
                  profileViewModel.updateEmail(emailController.text);
                  profileViewModel.updatePhone(phoneController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}