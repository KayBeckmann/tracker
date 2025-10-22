import '../data/local/app_database.dart';

enum HabitPeriodUnit { day, week }

class HabitPeriod {
  HabitPeriod({required this.start, required this.end});

  final DateTime start; // inclusive
  final DateTime end; // exclusive

  bool contains(DateTime timestamp) {
    final local = timestamp.toLocal();
    return !local.isBefore(start) && local.isBefore(end);
  }
}

HabitPeriodUnit periodUnitForHabit(HabitDefinition habit) {
  switch (habit.interval) {
    case HabitIntervalKind.daily:
    case HabitIntervalKind.multiplePerDay:
      return HabitPeriodUnit.day;
    case HabitIntervalKind.weekly:
    case HabitIntervalKind.multiplePerWeek:
      return HabitPeriodUnit.week;
  }
}

HabitPeriod periodForHabit(HabitDefinition habit, DateTime reference) {
  final localized = reference.toLocal();
  final unit = periodUnitForHabit(habit);
  final startOfDay = DateTime(localized.year, localized.month, localized.day);
  if (unit == HabitPeriodUnit.day) {
    final end = startOfDay.add(const Duration(days: 1));
    return HabitPeriod(start: startOfDay, end: end);
  }

  final difference = startOfDay.weekday - DateTime.monday;
  final normalizedDifference = difference >= 0 ? difference : difference + 7;
  final start = startOfDay.subtract(Duration(days: normalizedDifference));
  final end = start.add(const Duration(days: 7));
  return HabitPeriod(start: start, end: end);
}

List<HabitPeriod> latestHabitPeriods(
  HabitDefinition habit, {
  required int count,
  DateTime? reference,
}) {
  final now = reference ?? DateTime.now();
  final unit = periodUnitForHabit(habit);
  final periods = <HabitPeriod>[];
  HabitPeriod current = periodForHabit(habit, now);
  periods.add(current);
  for (var i = 1; i < count; i++) {
    final previousStart = unit == HabitPeriodUnit.day
        ? current.start.subtract(const Duration(days: 1))
        : current.start.subtract(const Duration(days: 7));
    current = periodForHabit(habit, previousStart);
    periods.add(current);
  }
  return periods.reversed.toList();
}

double sumLogsForPeriod(Iterable<HabitLog> logs, HabitPeriod period) {
  double total = 0;
  for (final log in logs) {
    final local = log.occurredAt.toLocal();
    if (!local.isBefore(period.start) && local.isBefore(period.end)) {
      total += log.value;
    }
  }
  return total;
}

bool isBooleanHabit(HabitDefinition habit) {
  return habit.measurementKind == HabitValueKind.boolean;
}

bool isSingleCompletionHabit(HabitDefinition habit) {
  if (!isBooleanHabit(habit)) {
    return false;
  }
  switch (habit.interval) {
    case HabitIntervalKind.daily:
    case HabitIntervalKind.weekly:
      return habit.targetOccurrences <= 1;
    case HabitIntervalKind.multiplePerDay:
    case HabitIntervalKind.multiplePerWeek:
      return false;
  }
}

double? habitTargetValue(HabitDefinition habit) {
  switch (habit.measurementKind) {
    case HabitValueKind.boolean:
      return habit.targetOccurrences.toDouble();
    case HabitValueKind.integer:
    case HabitValueKind.decimal:
      final value = habit.targetValue;
      if (value == null || value <= 0) {
        return null;
      }
      return value;
  }
}
