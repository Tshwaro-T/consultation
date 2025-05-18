// consultation_form.dart
import 'package:flutter/material.dart';

class ConsultationForm extends StatefulWidget {
  final String? consultationId;
  final String? initialName;
  final String? initialCode;
  final String? initialTopic;
  final String? initialNotes;
  final DateTime? initialDateTime;
  final String? initialLecturerId;
  final String? initialLecturerName;
  final Function({
    required String name,
    required String code,
    required String topic,
    required String notes,
    required DateTime dateTime,
    required String lecturerId,
    required String lecturerName,
  }) onSubmit;

  const ConsultationForm({
    super.key,
    this.consultationId,
    this.initialName,
    this.initialCode,
    this.initialTopic,
    this.initialNotes,
    this.initialDateTime,
    this.initialLecturerId,
    this.initialLecturerName,
    required this.onSubmit,
  });

  @override
  State<ConsultationForm> createState() => _ConsultationFormState();
}

class _ConsultationFormState extends State<ConsultationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _topicController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _selectedLecturerId;
  String? _selectedLecturerName;

  // Fixed list of 6 lecturers
  final List<Map<String, String>> _lecturers = const [
    {'id': '1', 'name': 'Dr. Smith'},
    {'id': '2', 'name': 'Prof. Johnson'},
    {'id': '3', 'name': 'Dr. Williams'},
    {'id': '4', 'name': 'Prof. Brown'},
    {'id': '5', 'name': 'Dr. Davis'},
    {'id': '6', 'name': 'Prof. Miller'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _codeController.text = widget.initialCode ?? '';
    _topicController.text = widget.initialTopic ?? '';
    _notesController.text = widget.initialNotes ?? '';
    _selectedDate = widget.initialDateTime ?? DateTime.now().add(const Duration(days: 1));
    _selectedTime = widget.initialDateTime != null 
        ? TimeOfDay.fromDateTime(widget.initialDateTime!) 
        : const TimeOfDay(hour: 9, minute: 0);
    _selectedLecturerId = widget.initialLecturerId;
    _selectedLecturerName = widget.initialLecturerName;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Consultation Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Consultation Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedLecturerId,
              decoration: const InputDecoration(
                labelText: 'Lecturer',
                border: OutlineInputBorder(),
              ),
              items: _lecturers.map((lecturer) {
                return DropdownMenuItem<String>(
                  value: lecturer['id'],
                  child: Text(lecturer['name']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLecturerId = newValue;
                  _selectedLecturerName = _lecturers
                      .firstWhere((l) => l['id'] == newValue)['name'];
                });
              },
              validator: (value) => value == null ? 'Please select a lecturer' : null,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Time: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
                hintText: 'Minimum 20 characters',
              ),
              minLines: 2,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (value.length < 20) return 'Minimum 20 characters';
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 5,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedLecturerId != null) {
                  final dateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  
                  widget.onSubmit(
                    name: _nameController.text.trim(),
                    code: _codeController.text.trim(),
                    topic: _topicController.text.trim(),
                    notes: _notesController.text.trim(),
                    dateTime: dateTime,
                    lecturerId: _selectedLecturerId!,
                    lecturerName: _selectedLecturerName!,
                  );
                  
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                widget.consultationId == null 
                    ? 'Book Consultation' 
                    : 'Update Consultation',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}