import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

const String _channelId = 'task_reminders';
const String _channelName = 'Task reminders';
const String _channelDescription =
    'Reminder notifications for your tasks and appointments';

const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  _channelId,
  _channelName,
  description: _channelDescription,
  importance: Importance.high,
);

const NotificationDetails _notificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    importance: Importance.high,
    priority: Priority.high,
    category: AndroidNotificationCategory.reminder,
  ),
  iOS: DarwinNotificationDetails(),
  macOS: DarwinNotificationDetails(),
);

class TaskReminderService {
  TaskReminderService._();

  static final TaskReminderService instance = TaskReminderService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'open',
    );
    final settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );
    await _plugin.initialize(settings);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_androidChannel);
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    final macPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    await macPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> syncReminders(
    List<TaskEntry> tasks,
    AppLocalizations loc,
  ) async {
    await initialize();
    List<PendingNotificationRequest> pending;
    try {
      pending = await _plugin.pendingNotificationRequests();
    } on UnimplementedError {
      return;
    }
    final now = DateTime.now();
    final activeIds = <int>{};

    for (final task in tasks) {
      final reminderAt = task.reminderAt;
      if (reminderAt == null) {
        continue;
      }
      final localReminder = reminderAt.toLocal();
      if (localReminder.isBefore(now)) {
        continue;
      }
      final (date: dateLabel, time: timeLabel) = _formatDateTime(
        loc,
        localReminder,
      );
      final title = task.title.trim().isEmpty
          ? loc.tasksReminderNotificationGenericTitle
          : task.title.trim();
      final body = loc.tasksReminderNotificationBody(dateLabel, timeLabel);
      await _schedule(task.id, title, body, localReminder);
      activeIds.add(task.id);
    }

    for (final request in pending) {
      if (!activeIds.contains(request.id)) {
        await cancelReminder(request.id);
      }
    }
  }

  Future<void> cancelReminder(int taskId) {
    return _plugin.cancel(taskId);
  }

  Future<void> _schedule(
    int taskId,
    String title,
    String body,
    DateTime scheduledFor,
  ) async {
    await _plugin.cancel(taskId);
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledFor.toUtc(),
      tz.UTC,
    );
    await _plugin.zonedSchedule(
      taskId,
      title,
      body,
      scheduledDate,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  ({String date, String time}) _formatDateTime(
    AppLocalizations loc,
    DateTime dateTime,
  ) {
    final locale = loc.localeName;
    final date = DateFormat.yMMMMd(locale).format(dateTime);
    final time = DateFormat.Hm(locale).format(dateTime);
    return (date: date, time: time);
  }
}
