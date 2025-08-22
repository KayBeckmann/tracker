import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracker/src/core/database/database.dart';
import 'package:tracker/main.dart' as main;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              // TODO: Implement event loading for highlighting days with appointments
              return [];
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: main.database.select(main.database.appointments).watch(),
              builder: (context, snapshot) {
                final appointments = snapshot.data ?? [];
                final selectedDayAppointments = appointments.where((appointment) =>
                    _selectedDay != null && isSameDay(appointment.dueDate, _selectedDay!)).toList();

                if (selectedDayAppointments.isEmpty) {
                  return const Center(
                    child: Text('No appointments for this day.'),
                  );
                }

                return ListView.builder(
                  itemCount: selectedDayAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = selectedDayAppointments[index];
                    return ListTile(
                      title: Text(appointment.title),
                      subtitle: Text(appointment.dueDate.toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
