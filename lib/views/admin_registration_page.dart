import 'package:consulationapp/models/app_router.dart';
import 'package:flutter/material.dart';
import 'package:consulationapp/servicess/auth_service.dart';
import 'package:provider/provider.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _registerAdmin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_secretController.text != "ADMIN_SECRET_123") { // Change this in production
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid admin secret code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
     await Provider.of<AuthService>(context, listen: false).registerAdmin(
  email: _emailController.text.trim(),
  password: _passwordController.text.trim(),
  name: _nameController.text.trim(),
  adminSecret: _secretController.text.trim(), // Fixed this line
);
      Navigator.pop(context); // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

     // Navigate to Admin Dashboard after successful registration
      Navigator.pushReplacementNamed(context, RouteManager.adminDashboard);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter valid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.length >= 6 ? null : 'Minimum 6 characters',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(labelText: 'Admin Secret Code'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerAdmin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}