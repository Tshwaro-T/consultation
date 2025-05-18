import 'package:consulationapp/models/app_user.dart';
import 'package:consulationapp/models/consulation.dart';
import 'package:consulationapp/routes/app_router.dart';
import 'package:consulationapp/servicess/auth_service.dart';
import 'package:consulationapp/views/consulation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_page_screen.dart';
// Import ConsultationForm if not already imported
//import 'package:consulationapp/views/consultation_form.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Booking'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, RouteManager.loginPage);
            },
          ),

           IconButton(
      icon: const Icon(Icons.admin_panel_settings),
      tooltip: 'Go to Admin Dashboard',
      onPressed: () {
        Navigator.pushNamed(context, RouteManager.adminDashboard);
      },
    ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddConsultationDialog(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddConsultationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book New Consultation'),
        content: ConsultationForm(
          onSubmit: ({
            required name,
            required code,
            required topic,
            required notes,
            required dateTime,
            required lecturerId,
            required lecturerName,
          }) {
            Provider.of<AuthService>(context, listen: false).addConsultation(
              name: name,
              code: code,
              topic: topic,
              notes: notes,
              dateTime: dateTime,
              lecturerId: lecturerId,
              lecturerName: lecturerName,
            );
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  void _showEditConsultationDialog(BuildContext context, Consultation consultation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Consultation'),
        content: ConsultationForm(
          consultationId: consultation.id,
          initialName: consultation.name,
          initialCode: consultation.code,
          initialTopic: consultation.topic,
          initialNotes: consultation.notes,
          initialDateTime: consultation.dateTime,
          initialLecturerId: consultation.lecturerId,
          initialLecturerName: consultation.lecturerName,
          onSubmit: ({
            required name,
            required code,
            required topic,
            required notes,
            required dateTime,
            required lecturerId,
            required lecturerName,
          }) {
            Provider.of<AuthService>(context, listen: false).updateConsultation(
              consultationId: consultation.id,
              name: name,
              code: code,
              topic: topic,
              notes: notes,
              dateTime: dateTime,
              lecturerId: lecturerId,
              lecturerName: lecturerName,
            );
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _deleteConsultation(BuildContext context, String consultationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this consultation?'),
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
      // ignore: use_build_context_synchronously
      await Provider.of<AuthService>(context, listen: false)
          .deleteConsultation(consultationId);
    }
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FutureBuilder<AppUser?>(
      future: authService.getUserData(authService.currentUser!.uid),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!userSnapshot.hasData) {
          return const Center(child: Text('User not found'));
        }

        final user = userSnapshot.data!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Welcome, ${user.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Email: ${authService.currentUser!.email}'),
                ],
              ),
            ),
            const Divider(),
            const Text('Your Consultations', style: TextStyle(fontSize: 18)),
            Expanded(
              child: _buildConsultationsList(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConsultationsList(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<List<Consultation>>(
      stream: authService.getConsultations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final consultations = snapshot.data ?? [];

        if (consultations.isEmpty) {
          return const Center(child: Text('No consultations added yet'));
        }

        return ListView.builder(
          itemCount: consultations.length,
          itemBuilder: (context, index) {
            final consultation = consultations[index];
            return ListTile(
              title: Text(consultation.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${consultation.code}'),
                  Text('Lecturer: ${consultation.lecturerName}'),
                  Text('Date: ${consultation.dateTime.toLocal().toString().split(' ')[0]}'),
                  Text('Time: ${TimeOfDay.fromDateTime(consultation.dateTime).format(context)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete this consultation?'),
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
                        // ignore: use_build_context_synchronously
                        await Provider.of<AuthService>(context, listen: false)
                            .deleteConsultation(consultation.id);
                      }
                    },
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blueAccent),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultationDetails(
                      consultation: {
                        'id': consultation.id,
                        'date': consultation.dateTime.toLocal().toString().split(' ')[0],
                        'time': TimeOfDay.fromDateTime(consultation.dateTime).format(context),
                        'description': consultation.notes,
                        'topic': consultation.topic,
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  
  // ignore: non_constant_identifier_names
  Widget ConsultationDetails({required Map<String, String?> consultation}) {
    throw UnimplementedError('ConsultationDetails is not implemented.');
  }
}