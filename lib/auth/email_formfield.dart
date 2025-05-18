import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'CUT Email',
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        if (!value.endsWith('@cut.ac.za')) return 'Only CUT emails allowed';
        return null;
      },
    );
  }
}
// This widget is a custom email input field for a form. It uses a TextFormField to accept user input and validate the email address. 
//The validator checks if the email is empty and if it ends with '@cut.ac.za', which is a requirement for the application. 
//The field also includes an icon for better user experience.
// The widget is reusable and can be easily integrated into any form that requires email input. 
//It enhances the user interface by providing clear feedback on the validity of the input, ensuring that only valid CUT email addresses are accepted.