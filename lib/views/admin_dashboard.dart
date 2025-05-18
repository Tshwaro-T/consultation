import 'package:consulationapp/models/consulation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulationapp/servicess/auth_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await authService.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
          ),
          IconButton(
  icon: const Icon(Icons.home),
  onPressed: () {
    Navigator.pushNamed(context, '/home'); // or your desired route
  },
),
        ],
      ),
      body: StreamBuilder<List<Consultation>>(
        stream: authService.getAllConsultations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final consultations = snapshot.data ?? [];

          if (consultations.isEmpty) {
            return const Center(child: Text('No consultations found.'));
          }

          return ListView.builder(
            itemCount: consultations.length,
            itemBuilder: (context, index) {
              final consultation = consultations[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(consultation.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student ID: ${consultation.studentId}'),
                      Text('Date: ${_formatDate(consultation.createdAt)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteConsultation(context, consultation.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteConsultation(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this consultation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<AuthService>(context, listen: false)
            .deleteConsultation(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consultation deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}