enum TimeEntryKind { work, vacation, dayOff, sick }

enum TimeTrackingRounding { minute, fiveMinutes, tenMinutes, quarterHour }

extension TimeTrackingRoundingX on TimeTrackingRounding {
  int get stepMinutes {
    switch (this) {
      case TimeTrackingRounding.minute:
        return 1;
      case TimeTrackingRounding.fiveMinutes:
        return 5;
      case TimeTrackingRounding.tenMinutes:
        return 10;
      case TimeTrackingRounding.quarterHour:
        return 15;
    }
  }

  static TimeTrackingRounding fromStorage(String? value) {
    return TimeTrackingRounding.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => TimeTrackingRounding.minute,
    );
  }
}

enum TimeTrackingTargetMode { none, daily, weekly }

extension TimeTrackingTargetModeX on TimeTrackingTargetMode {
  static TimeTrackingTargetMode fromStorage(String? value) {
    return TimeTrackingTargetMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => TimeTrackingTargetMode.none,
    );
  }
}

String formatTrackedMinutes(int minutes, {bool includeSign = false}) {
  final sign = minutes < 0 ? '-' : (includeSign && minutes > 0 ? '+' : '');
  final total = minutes.abs();
  final hours = total ~/ 60;
  final remainingMinutes = total % 60;
  final hoursPart = hours.toString().padLeft(2, '0');
  final minutesPart = remainingMinutes.toString().padLeft(2, '0');
  return '$sign$hoursPart:$minutesPart';
}

int roundDurationMinutes(Duration duration, TimeTrackingRounding rounding) {
  final minutes = duration.inMinutes;
  if (minutes <= 0) {
    return 0;
  }
  final step = rounding.stepMinutes;
  if (step <= 1) {
    return minutes;
  }
  final remainder = minutes % step;
  if (remainder == 0) {
    return minutes;
  }
  final roundUp = remainder * 2 >= step;
  final rounded = roundUp ? minutes + (step - remainder) : minutes - remainder;
  if (rounded == 0) {
    return step;
  }
  return rounded;
}

int minutesForKind(TimeEntryKind kind, int minutes) {
  if (kind == TimeEntryKind.work) {
    return minutes;
  }
  return 0;
}

DateTime alignDateTimeToRounding(DateTime date, TimeTrackingRounding rounding) {
  final step = rounding.stepMinutes;
  final normalized = DateTime(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.minute,
  );
  if (step <= 1) {
    return normalized;
  }
  final totalMinutes = normalized.hour * 60 + normalized.minute;
  final remainder = totalMinutes % step;
  if (remainder == 0) {
    return normalized;
  }
  final roundUp = remainder * 2 >= step;
  final diff = roundUp ? step - remainder : -remainder;
  final aligned = normalized.add(Duration(minutes: diff));
  return DateTime(
    aligned.year,
    aligned.month,
    aligned.day,
    aligned.hour,
    aligned.minute,
  );
}

String formatDurationInput(int minutes) {
  final safe = minutes.clamp(0, 999 * 60).toInt();
  final hours = safe ~/ 60;
  final remaining = safe % 60;
  final minutesPart = remaining.toString().padLeft(2, '0');
  return '$hours:$minutesPart';
}

int? parseDurationInput(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  if (trimmed.contains(':')) {
    final parts = trimmed.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hours = int.tryParse(parts.first.trim());
    final minutes = int.tryParse(parts.last.trim());
    if (hours == null || minutes == null || minutes < 0 || minutes >= 60) {
      return null;
    }
    return (hours * 60) + minutes;
  }
  final hours = int.tryParse(trimmed);
  if (hours == null) {
    return null;
  }
  return hours * 60;
}
