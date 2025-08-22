import 'package:flutter/material.dart';
import 'package:tracker/src/core/database/database.dart';

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

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: database.select(database.appointments).watch(),
        builder: (context, snapshot) {
          final appointments = snapshot.data ?? [];

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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          database.into(database.appointments).insert(
                AppointmentsCompanion.insert(
                  title: 'Test Appointment',
                  dueDate: DateTime.now(),
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}