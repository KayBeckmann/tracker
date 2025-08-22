import 'package:flutter/material.dart';
import 'package:tracker/src/core/database/database.dart';

class AppointmentEditScreen extends StatefulWidget {
  final Appointment? appointment;

  const AppointmentEditScreen({super.key, this.appointment});

  @override
  State<AppointmentEditScreen> createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends State<AppointmentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  int _priority = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.appointment?.title);
    _descriptionController = TextEditingController(text: widget.appointment?.description);
    _dueDate = widget.appointment?.dueDate ?? DateTime.now();
    _priority = widget.appointment?.priority ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null ? 'New Appointment' : 'Edit Appointment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Due Date: ${_dueDate.toLocal()}'.split(' ')[0]),
                  ),
                  TextButton(
                    child: const Text('Select Date'),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _dueDate) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Low')),
                  DropdownMenuItem(value: 1, child: Text('Medium')),
                  DropdownMenuItem(value: 2, child: Text('High')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newAppointment = AppointmentsCompanion(
        title: Value(_titleController.text),
        description: Value(_descriptionController.text),
        dueDate: Value(_dueDate),
        priority: Value(_priority),
      );

      if (widget.appointment == null) {
        database.into(database.appointments).insert(newAppointment);
      } else {
        database.update(database.appointments).replace(newAppointment);
      }

      Navigator.of(context).pop();
    }
  }
}
