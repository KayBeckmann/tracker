import 'package:flutter/material.dart';
import 'package:tracker/src/core/database/database.dart';
import 'package:tracker/src/features/appointments/presentation/appointment_edit_screen.dart';
import 'package:tracker/src/features/categories/presentation/category_management_screen.dart';

late AppDatabase database;

void main() {
  database = AppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppointmentsScreen(),
    );
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

enum AppointmentSortOrder {
  dueDateAscending,
  dueDateDescending,
  priorityAscending,
  priorityDescending,
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentSortOrder _sortOrder = AppointmentSortOrder.dueDateAscending;

  Stream<List<Appointment>> _getAppointmentsStream() {
    final query = database.select(database.appointments);

    switch (_sortOrder) {
      case AppointmentSortOrder.dueDateAscending:
        query.orderBy([(t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc)]);
        break;
      case AppointmentSortOrder.dueDateDescending:
        query.orderBy([(t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc)]);
        break;
      case AppointmentSortOrder.priorityAscending:
        query.orderBy([(t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc)]);
        break;
      case AppointmentSortOrder.priorityDescending:
        query.orderBy([(t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc)]);
        break;
    }

    return query.watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CategoryManagementScreen(),
                ),
              );
            },
          ),
          DropdownButton<AppointmentSortOrder>(
            value: _sortOrder,
            onChanged: (AppointmentSortOrder? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortOrder = newValue;
                });
              }
            },
            items: const <DropdownMenuItem<AppointmentSortOrder>>[
              DropdownMenuItem(
                value: AppointmentSortOrder.dueDateAscending,
                child: Text('Due Date (Asc)'),
              ),
              DropdownMenuItem(
                value: AppointmentSortOrder.dueDateDescending,
                child: Text('Due Date (Desc)'),
              ),
              DropdownMenuItem(
                value: AppointmentSortOrder.priorityAscending,
                child: Text('Priority (Asc)'),
              ),
              DropdownMenuItem(
                value: AppointmentSortOrder.priorityDescending,
                child: Text('Priority (Desc)'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: _getAppointmentsStream(),
        builder: (context, snapshot) {
          final appointments = snapshot.data ?? [],

          if (appointments.isEmpty) {
            return const Center(
              child: Text('No appointments yet.'),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text(appointment.title),
                subtitle: Text(appointment.dueDate.toString()),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AppointmentEditScreen(
                        appointment: appointment,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AppointmentEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
