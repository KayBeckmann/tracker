import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import '../time_tracking/time_tracking_summary.dart';
import '../time_tracking/time_tracking_types.dart';

class TaskTimeEntry {
  const TaskTimeEntry({required this.entry, required this.minutes});

  final TimeEntry entry;
  final int minutes;
}

class TaskTimeInfo {
  const TaskTimeInfo({required this.entries, required this.totalMinutes});

  final List<TaskTimeEntry> entries;
  final int totalMinutes;
}

Map<int, TaskTimeInfo> groupTimeEntriesByTask(
  Iterable<TimeEntry> entries,
  TimeTrackingRounding rounding,
) {
  final Map<int, List<TimeEntry>> grouped = {};
  for (final entry in entries) {
    final taskId = entry.taskId;
    if (taskId == null) {
      continue;
    }
    grouped.putIfAbsent(taskId, () => <TimeEntry>[]).add(entry);
  }

  final Map<int, TaskTimeInfo> info = {};
  grouped.forEach((taskId, list) {
    info[taskId] = buildTaskTimeInfo(list, rounding);
  });
  return info;
}

TaskTimeInfo buildTaskTimeInfo(
  Iterable<TimeEntry> entries,
  TimeTrackingRounding rounding,
) {
  final sorted = entries.toList()
    ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  final List<TaskTimeEntry> displays = [];
  int total = 0;
  for (final entry in sorted) {
    final minutes = entry.endedAt == null
        ? TimeTrackingSummary.activeMinutes(entry.startedAt.toLocal(), rounding)
        : entry.durationMinutes;
    displays.add(TaskTimeEntry(entry: entry, minutes: minutes));
    total += minutesForKind(entry.kind, minutes);
  }
  return TaskTimeInfo(entries: displays, totalMinutes: total);
}

class TaskTimeEntriesSection extends StatelessWidget {
  const TaskTimeEntriesSection({super.key, required this.timeInfo});

  final TaskTimeInfo timeInfo;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeTag = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(localeTag);
    final timeFormat = DateFormat.Hm(localeTag);

    if (timeInfo.entries.isEmpty) {
      return Text(loc.tasksTrackedTimeEmpty, style: theme.textTheme.bodySmall);
    }

    final displayed = timeInfo.entries.take(5).toList();
    final remaining = timeInfo.entries.length - displayed.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.tasksTrackedTimeTotal(
            formatTrackedMinutes(timeInfo.totalMinutes),
          ),
          style: theme.textTheme.bodySmall,
        ),
        for (final display in displayed) ...[
          const SizedBox(height: 2),
          Text(
            _formatEntryLabel(loc, display, dateFormat, timeFormat),
            style: theme.textTheme.bodySmall,
          ),
          if (display.entry.note.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Text(
                display.entry.note.trim(),
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
        if (remaining > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              loc.tasksTrackedTimeMore(remaining),
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  String _formatEntryLabel(
    AppLocalizations loc,
    TaskTimeEntry display,
    DateFormat dateFormat,
    DateFormat timeFormat,
  ) {
    final entry = display.entry;
    final start = entry.startedAt.toLocal();
    final end = entry.endedAt?.toLocal();
    final durationText = formatTrackedMinutes(display.minutes);
    final prefix = dateFormat.format(start);
    final typeSuffix = entry.kind == TimeEntryKind.work
        ? ''
        : ' • ${_kindLabel(loc, entry.kind)}';
    if (entry.endedAt == null) {
      return '$prefix • ${loc.timeTrackingEntryRunning(timeFormat.format(start), durationText)}$typeSuffix';
    }
    return '$prefix • ${loc.timeTrackingEntryInterval(timeFormat.format(start), end == null ? '—' : timeFormat.format(end), durationText)}$typeSuffix';
  }

  String _kindLabel(AppLocalizations loc, TimeEntryKind kind) {
    switch (kind) {
      case TimeEntryKind.work:
        return loc.timeTrackingKindWork;
      case TimeEntryKind.vacation:
        return loc.timeTrackingKindVacation;
      case TimeEntryKind.dayOff:
        return loc.timeTrackingKindDayOff;
      case TimeEntryKind.sick:
        return loc.timeTrackingKindSick;
    }
  }
}
