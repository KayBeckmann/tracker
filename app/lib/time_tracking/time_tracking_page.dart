import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'time_tracking_summary.dart';
import 'time_tracking_types.dart';

class TimeTrackingPage extends StatefulWidget {
  const TimeTrackingPage({
    super.key,
    required this.database,
    required this.rounding,
    required this.targetMode,
    required this.dailyTargetMinutes,
    required this.weeklyTargetMinutes,
    required this.onStartTracking,
    required this.onStopTracking,
  });

  final AppDatabase database;
  final TimeTrackingRounding rounding;
  final TimeTrackingTargetMode targetMode;
  final int dailyTargetMinutes;
  final int weeklyTargetMinutes;
  final Future<bool> Function(BuildContext context) onStartTracking;
  final Future<bool> Function(BuildContext context) onStopTracking;

  @override
  State<TimeTrackingPage> createState() => _TimeTrackingPageState();
}

class _TimeTrackingPageState extends State<TimeTrackingPage> {
  late DateTime _selectedDay;
  late DateTime _calendarMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _calendarMonth = DateTime(now.year, now.month);
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime timestamp, DateTime target) {
    final local = timestamp.toLocal();
    return local.year == target.year &&
        local.month == target.month &&
        local.day == target.day;
  }

  void _selectDay(DateTime date) {
    setState(() {
      _selectedDay = _normalizeDate(date);
      _calendarMonth = DateTime(date.year, date.month);
    });
  }

  void _changeMonth(int delta) {
    final newMonth = DateTime(
      _calendarMonth.year,
      _calendarMonth.month + delta,
    );
    setState(() {
      _calendarMonth = newMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder<List<TimeEntry>>(
      stream: widget.database.watchAllTimeEntries(),
      builder: (context, timeSnapshot) {
        final entries = timeSnapshot.data ?? const <TimeEntry>[];
        return StreamBuilder<List<TaskEntry>>(
          stream: widget.database.watchTaskEntries(),
          builder: (context, taskSnapshot) {
            final tasks = taskSnapshot.data ?? const <TaskEntry>[];
            final taskMap = {for (final task in tasks) task.id: task};

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryCard(context, loc, entries),
                const SizedBox(height: 16),
                _buildCalendar(context, loc, entries),
                const SizedBox(height: 16),
                _buildActionsRow(context, loc, entries),
                const SizedBox(height: 16),
                _buildDayEntries(context, loc, entries, taskMap),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AppLocalizations loc,
    List<TimeEntry> entries,
  ) {
    final summary = TimeTrackingSummary.fromEntries(
      entries: entries,
      selectedDay: _selectedDay,
      rounding: widget.rounding,
      targetMode: widget.targetMode,
      dailyTargetMinutes: widget.dailyTargetMinutes,
      weeklyTargetMinutes: widget.weeklyTargetMinutes,
    );

    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMMd(loc.localeName);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.timeTrackingSummaryDay(
                dateFormat.format(_selectedDay),
                formatTrackedMinutes(summary.dailyWorkMinutes),
              ),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.timeTrackingSummaryAllEntries(
                formatTrackedMinutes(summary.dailyAllMinutes),
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              loc.timeTrackingSummaryWeek(
                dateFormat.format(summary.weekStart),
                dateFormat.format(summary.weekEnd),
                formatTrackedMinutes(summary.weeklyWorkMinutes),
              ),
              style: theme.textTheme.titleSmall,
            ),
            if (summary.deltaMinutes != null) ...[
              const SizedBox(height: 8),
              Text(
                loc.timeTrackingSummaryDelta(
                  formatTrackedMinutes(
                    summary.deltaMinutes!,
                    includeSign: true,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    AppLocalizations loc,
    List<TimeEntry> entries,
  ) {
    final theme = Theme.of(context);
    final highlightedDays = entries
        .map((entry) => _normalizeDate(entry.startedAt.toLocal()))
        .toSet();
    final days = _generateMonthDays(_calendarMonth);
    final weekdayNames = List.generate(7, (index) {
      final date = DateTime(2023, 1, 2 + index); // Monday-based sample week.
      return DateFormat.E(loc.localeName).format(date);
    });

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: loc.timeTrackingCalendarPrevious,
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat.yMMMM(loc.localeName).format(_calendarMonth),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: loc.timeTrackingCalendarNext,
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final name in weekdayNames)
                  Center(child: Text(name, style: theme.textTheme.labelSmall)),
                for (final day in days)
                  _CalendarDayButton(
                    day: day,
                    isSelected: _isSameDay(day.date, _selectedDay),
                    hasEntries: highlightedDays.contains(day.date),
                    onSelected: _selectDay,
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    final isWide = MediaQuery.of(context).size.width >= 900;
    if (!isWide) {
      return card;
    }
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: card,
      ),
    );
  }

  Widget _buildActionsRow(
    BuildContext context,
    AppLocalizations loc,
    List<TimeEntry> entries,
  ) {
    final hasActive = entries.any((entry) => entry.endedAt == null);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: hasActive ? null : () => widget.onStartTracking(context),
          icon: const Icon(Icons.play_arrow),
          label: Text(loc.timeTrackingStartNowButton),
        ),
        FilledButton.tonalIcon(
          onPressed: hasActive ? () => widget.onStopTracking(context) : null,
          icon: const Icon(Icons.stop),
          label: Text(loc.timeTrackingStopNowButton),
        ),
        OutlinedButton.icon(
          onPressed: () => _openEntryForm(context, loc),
          icon: const Icon(Icons.add),
          label: Text(loc.timeTrackingAddManualButton),
        ),
      ],
    );
  }

  Widget _buildDayEntries(
    BuildContext context,
    AppLocalizations loc,
    List<TimeEntry> entries,
    Map<int, TaskEntry> taskMap,
  ) {
    final theme = Theme.of(context);
    final dayEntries =
        entries
            .where((entry) => _isSameDay(entry.startedAt, _selectedDay))
            .toList()
          ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

    if (dayEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            loc.timeTrackingNoEntriesForDay,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dayEntries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TimeEntryTile(
                entry: entry,
                rounding: widget.rounding,
                task: entry.taskId != null ? taskMap[entry.taskId!] : null,
                onEdit: () => _openEntryForm(
                  context,
                  loc,
                  entry: entry,
                  taskMap: taskMap,
                ),
                onDelete: () => _confirmDeleteEntry(context, loc, entry),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _openEntryForm(
    BuildContext context,
    AppLocalizations loc, {
    TimeEntry? entry,
    Map<int, TaskEntry>? taskMap,
  }) async {
    final tasks =
        taskMap?.values.toList() ??
        await widget.database.watchTaskEntries().first;
    if (!context.mounted) {
      return;
    }
    final initialStart =
        entry?.startedAt.toLocal() ??
        DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          TimeOfDay.now().hour,
          0,
        );
    final initialEnd =
        entry?.endedAt?.toLocal() ?? initialStart.add(const Duration(hours: 1));

    final result = await showDialog<_TimeEntryFormResult>(
      context: context,
      builder: (context) => _TimeEntryFormDialog(
        loc: loc,
        rounding: widget.rounding,
        tasks: tasks,
        initialStart: initialStart,
        initialEnd: initialEnd,
        initialKind: entry?.kind ?? TimeEntryKind.work,
        initialNote: entry?.note ?? '',
        initialTaskId: entry?.taskId,
      ),
    );

    if (result == null) {
      return;
    }

    if (entry == null) {
      await widget.database.insertTimeEntry(
        startedAt: result.startedAt,
        endedAt: result.endedAt,
        durationMinutes: result.durationMinutes,
        kind: result.kind,
        note: result.note,
        taskId: result.taskId,
        isManual: true,
      );
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.timeTrackingManualEntrySaved)));
      return;
    }

    final updated = entry.copyWith(
      startedAt: result.startedAt.toUtc(),
      endedAt: Value(result.endedAt.toUtc()),
      durationMinutes: result.durationMinutes,
      note: result.note,
      kind: result.kind,
      taskId: Value(result.taskId),
      isManual: true,
    );
    await widget.database.updateTimeEntry(updated);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.timeTrackingManualEntrySaved)));
  }

  Future<void> _confirmDeleteEntry(
    BuildContext context,
    AppLocalizations loc,
    TimeEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.timeTrackingDeleteEntryTitle),
        content: Text(loc.timeTrackingDeleteEntryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.timeTrackingFormCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.timeTrackingDeleteEntryConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await widget.database.deleteTimeEntry(entry.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.timeTrackingEntryDeleted)));
  }

  List<_CalendarDayEntry> _generateMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final weekday = first.weekday; // Monday=1
    final leading = (weekday + 6) % 7;
    final start = first.subtract(Duration(days: leading));
    return List.generate(42, (index) {
      final date = start.add(Duration(days: index));
      return _CalendarDayEntry(
        date: _normalizeDate(date),
        isCurrentMonth: date.month == month.month,
      );
    });
  }
}

class _CalendarDayEntry {
  const _CalendarDayEntry({required this.date, required this.isCurrentMonth});

  final DateTime date;
  final bool isCurrentMonth;
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({
    required this.day,
    required this.isSelected,
    required this.hasEntries,
    required this.onSelected,
  });

  final _CalendarDayEntry day;
  final bool isSelected;
  final bool hasEntries;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: day.isCurrentMonth ? null : theme.disabledColor,
    );
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : Colors.transparent;
    final backgroundColor = isSelected
        ? theme.colorScheme.primary.withValues(alpha: 0.12)
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onSelected(day.date),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${day.date.day}', style: textStyle),
              if (hasEntries)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeEntryTile extends StatelessWidget {
  const _TimeEntryTile({
    required this.entry,
    required this.rounding,
    this.task,
    this.onEdit,
    this.onDelete,
  });

  final TimeEntry entry;
  final TimeTrackingRounding rounding;
  final TaskEntry? task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isActive = entry.endedAt == null;
    final start = entry.startedAt.toLocal();
    final end = entry.endedAt?.toLocal();
    final dateFormat = DateFormat.Hm(loc.localeName);
    final durationMinutes = isActive
        ? TimeTrackingSummary.activeMinutes(start, rounding)
        : entry.durationMinutes;
    final durationText = formatTrackedMinutes(durationMinutes);
    final kindLabel = _kindLabel(loc, entry.kind);

    return Card(
      child: ListTile(
        onTap: onEdit,
        title: Text(
          isActive
              ? loc.timeTrackingEntryRunning(
                  dateFormat.format(start),
                  durationText,
                )
              : loc.timeTrackingEntryInterval(
                  dateFormat.format(start),
                  end == null ? '—' : dateFormat.format(end),
                  durationText,
                ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kindLabel),
            if (entry.note.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(entry.note.trim()),
              ),
            if (task != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  loc.timeTrackingLinkedTask(task!.title),
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              tooltip: loc.timeTrackingEditEntryTooltip,
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              tooltip: loc.timeTrackingDeleteEntryTooltip,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
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

class _TimeEntryFormDialog extends StatefulWidget {
  const _TimeEntryFormDialog({
    required this.loc,
    required this.rounding,
    required this.tasks,
    required this.initialStart,
    required this.initialEnd,
    required this.initialKind,
    required this.initialNote,
    this.initialTaskId,
  });

  final AppLocalizations loc;
  final TimeTrackingRounding rounding;
  final List<TaskEntry> tasks;
  final DateTime initialStart;
  final DateTime initialEnd;
  final TimeEntryKind initialKind;
  final String initialNote;
  final int? initialTaskId;

  @override
  State<_TimeEntryFormDialog> createState() => _TimeEntryFormDialogState();
}

class _TimeEntryFormDialogState extends State<_TimeEntryFormDialog> {
  late DateTime _start;
  late DateTime _end;
  late TimeEntryKind _kind;
  late TextEditingController _noteController;
  int? _taskId;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd.isAfter(widget.initialStart)
        ? widget.initialEnd
        : widget.initialStart.add(const Duration(hours: 1));
    _kind = widget.initialKind;
    _noteController = TextEditingController(text: widget.initialNote);
    _taskId = widget.initialTaskId;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;
    final theme = Theme.of(context);

    final durationMinutes = _end.isAfter(_start)
        ? roundDurationMinutes(_end.difference(_start), widget.rounding)
        : 0;

    final durationLabel = durationMinutes > 0
        ? formatTrackedMinutes(durationMinutes)
        : loc.timeTrackingFormInvalidDuration;

    return AlertDialog(
      title: Text(loc.timeTrackingFormTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateTimeRow(
              label: loc.timeTrackingFormStartLabel,
              date: _start,
              onPickDate: _pickStartDate,
              onPickTime: _pickStartTime,
            ),
            const SizedBox(height: 12),
            _DateTimeRow(
              label: loc.timeTrackingFormEndLabel,
              date: _end,
              onPickDate: _pickEndDate,
              onPickTime: _pickEndTime,
            ),
            const SizedBox(height: 12),
            Text(
              loc.timeTrackingFormDurationLabel(durationLabel),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TimeEntryKind>(
              value: _kind,
              decoration: InputDecoration(
                labelText: loc.timeTrackingFormKindLabel,
              ),
              items: TimeEntryKind.values
                  .map(
                    (kind) => DropdownMenuItem(
                      value: kind,
                      child: Text(_kindLabel(loc, kind)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _kind = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _taskId,
              decoration: InputDecoration(
                labelText: loc.timeTrackingFormTaskLabel,
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(loc.timeTrackingFormNoTask),
                ),
                ...widget.tasks.map(
                  (task) => DropdownMenuItem<int?>(
                    value: task.id,
                    child: Text(task.title),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _taskId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: loc.timeTrackingFormNoteLabel,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.timeTrackingFormCancel),
        ),
        FilledButton(
          onPressed: durationMinutes <= 0
              ? null
              : () {
                  Navigator.of(context).pop(
                    _TimeEntryFormResult(
                      startedAt: _start,
                      endedAt: _end,
                      durationMinutes: durationMinutes,
                      kind: _kind,
                      note: _noteController.text.trim(),
                      taskId: _taskId,
                    ),
                  );
                },
          child: Text(loc.timeTrackingFormSave),
        ),
      ],
    );
  }

  Future<void> _pickStartDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted || result == null) return;
    setState(() {
      _start = alignDateTimeToRounding(
        DateTime(
          result.year,
          result.month,
          result.day,
          _start.hour,
          _start.minute,
        ),
        widget.rounding,
      );
      _end = alignDateTimeToRounding(_end, widget.rounding);
      if (!_end.isAfter(_start)) {
        _end = alignDateTimeToRounding(
          _start.add(Duration(minutes: widget.rounding.stepMinutes)),
          widget.rounding,
        );
      }
    });
  }

  Future<void> _pickStartTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );
    if (!mounted || result == null) return;
    setState(() {
      _start = alignDateTimeToRounding(
        DateTime(
          _start.year,
          _start.month,
          _start.day,
          result.hour,
          result.minute,
        ),
        widget.rounding,
      );
      _end = alignDateTimeToRounding(_end, widget.rounding);
      if (!_end.isAfter(_start)) {
        _end = alignDateTimeToRounding(
          _start.add(Duration(minutes: widget.rounding.stepMinutes)),
          widget.rounding,
        );
      }
    });
  }

  Future<void> _pickEndDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted || result == null) return;
    setState(() {
      _end = alignDateTimeToRounding(
        DateTime(result.year, result.month, result.day, _end.hour, _end.minute),
        widget.rounding,
      );
      if (!_end.isAfter(_start)) {
        _end = alignDateTimeToRounding(
          _start.add(Duration(minutes: widget.rounding.stepMinutes)),
          widget.rounding,
        );
      }
    });
  }

  Future<void> _pickEndTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_end),
    );
    if (!mounted || result == null) return;
    setState(() {
      _end = alignDateTimeToRounding(
        DateTime(_end.year, _end.month, _end.day, result.hour, result.minute),
        widget.rounding,
      );
      if (!_end.isAfter(_start)) {
        _end = alignDateTimeToRounding(
          _start.add(Duration(minutes: widget.rounding.stepMinutes)),
          widget.rounding,
        );
      }
    });
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

class _TimeEntryFormResult {
  const _TimeEntryFormResult({
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.kind,
    required this.note,
    this.taskId,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMinutes;
  final TimeEntryKind kind;
  final String note;
  final int? taskId;
}

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow({
    required this.label,
    required this.date,
    required this.onPickDate,
    required this.onPickTime,
  });

  final String label;
  final DateTime date;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(locale);
    final timeFormat = DateFormat.Hm(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onPickDate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(dateFormat.format(date)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onPickTime,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(timeFormat.format(date)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
