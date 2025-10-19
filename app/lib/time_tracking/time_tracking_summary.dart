import '../data/local/app_database.dart';
import 'time_tracking_types.dart';

class TimeTrackingSummary {
  const TimeTrackingSummary({
    required this.dailyWorkMinutes,
    required this.dailyAllMinutes,
    required this.weeklyWorkMinutes,
    required this.weekStart,
    required this.weekEnd,
    this.deltaMinutes,
  });

  final int dailyWorkMinutes;
  final int dailyAllMinutes;
  final int weeklyWorkMinutes;
  final DateTime weekStart;
  final DateTime weekEnd;
  final int? deltaMinutes;

  static TimeTrackingSummary fromEntries({
    required Iterable<TimeEntry> entries,
    required DateTime selectedDay,
    required TimeTrackingRounding rounding,
    required TimeTrackingTargetMode targetMode,
    required int dailyTargetMinutes,
    required int weeklyTargetMinutes,
  }) {
    final day = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final weekStart = _startOfWeek(day);
    final weekEnd = weekStart.add(const Duration(days: 6));

    int dailyWork = 0;
    int dailyAll = 0;
    int weeklyWork = 0;

    for (final entry in entries) {
      final localStart = entry.startedAt.toLocal();
      final minutes = entry.endedAt == null
          ? activeMinutes(localStart, rounding)
          : entry.durationMinutes;

      if (day.year == localStart.year &&
          day.month == localStart.month &&
          day.day == localStart.day) {
        dailyAll += minutes;
        dailyWork += minutesForKind(entry.kind, minutes);
      }

      if (!localStart.isBefore(weekStart) && !localStart.isAfter(weekEnd)) {
        weeklyWork += minutesForKind(entry.kind, minutes);
      }
    }

    int? delta;
    switch (targetMode) {
      case TimeTrackingTargetMode.none:
        delta = null;
        break;
      case TimeTrackingTargetMode.daily:
        delta = dailyWork - dailyTargetMinutes;
        break;
      case TimeTrackingTargetMode.weekly:
        delta = weeklyWork - weeklyTargetMinutes;
        break;
    }

    return TimeTrackingSummary(
      dailyWorkMinutes: dailyWork,
      dailyAllMinutes: dailyAll,
      weeklyWorkMinutes: weeklyWork,
      weekStart: weekStart,
      weekEnd: weekEnd,
      deltaMinutes: delta,
    );
  }

  static int activeMinutes(DateTime start, TimeTrackingRounding rounding) {
    final now = DateTime.now();
    if (now.isBefore(start)) {
      return 0;
    }
    final duration = now.difference(start);
    var minutes = roundDurationMinutes(duration, rounding);
    if (minutes <= 0) {
      minutes = rounding.stepMinutes;
    }
    return minutes;
  }

  static DateTime _startOfWeek(DateTime day) {
    final weekday = day.weekday; // Monday = 1
    return DateTime(
      day.year,
      day.month,
      day.day,
    ).subtract(Duration(days: weekday - 1));
  }
}
