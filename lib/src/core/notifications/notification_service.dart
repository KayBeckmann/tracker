import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracker/src/core/database/database.dart';

class NotificationService {
  final AppDatabase database;
  Timer? _timer;

  NotificationService(this.database);

  void initialize(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForUpcomingAppointments(context);
    });
  }

  void _checkForUpcomingAppointments(BuildContext context) async {
    final now = DateTime.now();
    final upcomingAppointments = await database.select(database.appointments).get();

    for (final appointment in upcomingAppointments) {
      // Check if the appointment is due within the next 5 minutes
      if (appointment.dueDate.isAfter(now) &&
          appointment.dueDate.difference(now).inMinutes <= 5) {
        _showNotification(context, appointment);
      }
    }
  }

  void _showNotification(BuildContext context, Appointment appointment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upcoming Appointment: ${appointment.title} at ${appointment.dueDate.hour}:${appointment.dueDate.minute}'),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
