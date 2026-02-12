import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'habit_form.dart';
import 'habit_utils.dart';

class HabitDetailPage extends StatefulWidget {
  const HabitDetailPage({super.key, required this.database, required this.habit});

  final AppDatabase database;
  final HabitDefinition habit;

  @override
  State<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HabitDefinition>>(
      stream: widget.database.watchHabits(includeArchived: true),
      builder: (context, snapshot) {
        final currentHabit = snapshot.data
                ?.firstWhereOrNull((h) => h.id == widget.habit.id) ??
            widget.habit;
        return StreamBuilder<List<HabitLog>>(
          stream: widget.database.watchHabitLogs(currentHabit.id),
          builder: (context, logSnapshot) {
            final logs = logSnapshot.data ?? const <HabitLog>[];
            return Scaffold(
              appBar: AppBar(
                title: Text(currentHabit.name),
                actions: [
                  IconButton(
                    tooltip: AppLocalizations.of(context).habitsEditTitle,
                    icon: const Icon(Icons.edit),
                    onPressed: _isProcessing
                        ? null
                        : () => _editHabit(context, currentHabit),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context).habitsDeleteHabit,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _isProcessing
                        ? null
                        : () => _deleteHabit(context, currentHabit),
                  ),
                  PopupMenuButton<String>(
                    enabled: !_isProcessing,
                    onSelected: (value) {
                      if (value == 'backdate') {
                        _addCompletionWithDate(currentHabit);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'backdate',
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(AppLocalizations.of(context).habitsBackdateEntry),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              floatingActionButton: _buildFab(context, currentHabit, logs),
              body: _HabitDetailBody(
                habit: currentHabit,
                logs: logs,
                isProcessing: _isProcessing,
                onDeleteLog: _deleteLog,
              ),
            );
          },
        );
      },
    );
  }

  Widget? _buildFab(
    BuildContext context,
    HabitDefinition habit,
    List<HabitLog> logs,
  ) {
    final loc = AppLocalizations.of(context);
    if (isBooleanHabit(habit)) {
      final singleCompletion = isSingleCompletionHabit(habit);
      if (singleCompletion) {
        final period = periodForHabit(habit, DateTime.now());
        final completed = logs.any(
          (log) => !log.occurredAt
                  .toLocal()
                  .isBefore(period.start) &&
              log.occurredAt.toLocal().isBefore(period.end),
        );
        return FloatingActionButton.extended(
          onPressed: _isProcessing
              ? null
              : () => _toggleBooleanCompletion(habit, completed),
          icon: Icon(completed ? Icons.undo : Icons.task_alt),
          label: Text(
            completed ? loc.habitsUndoTodayButton : loc.habitsMarkDoneButton,
          ),
        );
      }

      return FloatingActionButton.extended(
        onPressed: _isProcessing ? null : () => _addCompletion(habit),
        icon: const Icon(Icons.add_task),
        label: Text(loc.habitsAddCompletion),
      );
    }

    return FloatingActionButton.extended(
      onPressed: _isProcessing ? null : () => _addNumericValue(habit),
      icon: const Icon(Icons.note_add),
      label: Text(AppLocalizations.of(context).habitsAddMeasurement),
    );
  }

  Future<void> _editHabit(BuildContext context, HabitDefinition habit) async {
    final result = await showHabitFormDialog(
      context: context,
      initialHabit: habit,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      final updated = habit.copyWith(
        name: result.name,
        description: result.description,
        interval: result.interval,
        targetOccurrences: result.targetOccurrences,
        measurementKind: result.measurementKind,
        targetValue: Value(result.targetValue),
      );
      await widget.database.updateHabit(updated);
      if (!context.mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.of(context);
      final loc = AppLocalizations.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(loc.habitsUpdateSuccess(result.name)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _deleteHabit(BuildContext context, HabitDefinition habit) async {
    final loc = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.habitsDeleteHabit),
          content: Text(loc.habitsDeleteHabitConfirm(habit.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.habitsCancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.habitsDeleteHabitAction),
            ),
          ],
        );
      },
    );
    if (confirm != true) {
      return;
    }
    setState(() {
      _isProcessing = true;
    });
    try {
      await widget.database.deleteHabit(habit.id);
      if (!context.mounted) {
        return;
      }
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(loc.habitsDeleteHabitSuccess(habit.name))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _toggleBooleanCompletion(
    HabitDefinition habit,
    bool completed,
  ) async {
    final period = periodForHabit(habit, DateTime.now());
    setState(() {
      _isProcessing = true;
    });
    try {
      if (completed) {
        await widget.database.deleteHabitLogsForRange(
          habitId: habit.id,
          start: period.start,
          end: period.end,
        );
      } else {
        await widget.database.insertHabitLog(
          habitId: habit.id,
          value: 1,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _addCompletion(HabitDefinition habit) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      await widget.database.insertHabitLog(
        habitId: habit.id,
        value: 1,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _addCompletionWithDate(HabitDefinition habit) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (!mounted) return;

    final occurredAt = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 12,
      time?.minute ?? 0,
    );

    setState(() {
      _isProcessing = true;
    });
    try {
      if (isBooleanHabit(habit)) {
        await widget.database.insertHabitLog(
          habitId: habit.id,
          value: 1,
          occurredAt: occurredAt,
        );
      } else {
        final value = await _showNumericInputDialog(habit);
        if (value != null) {
          await widget.database.insertHabitLog(
            habitId: habit.id,
            value: value,
            occurredAt: occurredAt,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<double?> _showNumericInputDialog(HabitDefinition habit) async {
    final loc = AppLocalizations.of(context);
    final controller = TextEditingController();
    return showDialog<double?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.habitsLogValueTitle(habit.name)),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: loc.habitsValueHint),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.habitsCancelButton),
            ),
            FilledButton(
              onPressed: () {
                final parsed =
                    double.tryParse(controller.text.trim().replaceAll(',', '.'));
                Navigator.of(context).pop(parsed);
              },
              child: Text(loc.habitsSaveButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNumericValue(HabitDefinition habit) async {
    final loc = AppLocalizations.of(context);
    final controller = TextEditingController();
    final value = await showDialog<double?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.habitsLogValueTitle(habit.name)),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: loc.habitsValueHint),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.habitsCancelButton),
            ),
            FilledButton(
              onPressed: () {
                final parsed =
                    double.tryParse(controller.text.trim().replaceAll(',', '.'));
                Navigator.of(context).pop(parsed);
              },
              child: Text(loc.habitsSaveButton),
            ),
          ],
        );
      },
    );
    if (value == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });
    try {
      await widget.database.insertHabitLog(
        habitId: habit.id,
        value: value,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _deleteLog(HabitLog log) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      await widget.database.deleteHabitLog(log.id);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

class _HabitDetailBody extends StatelessWidget {
  const _HabitDetailBody({
    required this.habit,
    required this.logs,
    required this.isProcessing,
    required this.onDeleteLog,
  });

  final HabitDefinition habit;
  final List<HabitLog> logs;
  final bool isProcessing;
  final ValueChanged<HabitLog> onDeleteLog;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final now = DateTime.now();
    final period = periodForHabit(habit, now);
    final periodLogs = logs
        .where(
          (log) => !log.occurredAt
              .toLocal()
              .isBefore(period.start) &&
              log.occurredAt.toLocal().isBefore(period.end),
        )
        .toList();
    final total = periodLogs.fold<double>(0, (prev, log) => prev + log.value);
    final summary = habitProgressLabel(
      loc: loc,
      habit: habit,
      periodLogs: periodLogs,
      numericTotal: total,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.habitsCurrentProgress,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(summary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        HabitProgressChart(habit: habit, logs: logs),
        const SizedBox(height: 16),
        Text(
          loc.habitsHistorySectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (logs.isEmpty)
          Text(loc.habitsNoEntriesYet)
        else
          ...logs
              .sortedBy<DateTime>((log) => log.occurredAt)
              .reversed
              .map(
                (log) => _HabitLogTile(
                  habit: habit,
                  log: log,
                  onDelete: isProcessing ? null : () => onDeleteLog(log),
                ),
              ),
      ],
    );
  }

}

class HabitProgressChart extends StatelessWidget {
  const HabitProgressChart({super.key, required this.habit, required this.logs});

  final HabitDefinition habit;
  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final periods = latestHabitPeriods(habit, count: 12);
    if (periods.isEmpty) {
      return const SizedBox.shrink();
    }
    final target = habitTargetValue(habit);
    final usePercentage = target != null && target > 0;
    final numberFormat = NumberFormat.decimalPattern(loc.localeName);
    final spots = <FlSpot>[];
    final labels = <int, DateTime>{};
    double maxY = 0;
    for (var i = 0; i < periods.length; i++) {
      final period = periods[i];
      final total = sumLogsForPeriod(logs, period);
      final value = usePercentage ? (total / target) * 100 : total;
      if (value > maxY) {
        maxY = value;
      }
      spots.add(FlSpot(i.toDouble(), value));
      labels[i] = period.start;
    }

    if (spots.every((spot) => spot.y == 0)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(loc.habitsChartEmpty),
        ),
      );
    }

    final double resolvedMaxY;
    if (usePercentage) {
      final num candidate = maxY <= 0 ? 100 : (maxY / 10).ceil() * 10;
      resolvedMaxY = candidate.clamp(20, 200).toDouble();
    } else {
      if (maxY <= 0) {
        resolvedMaxY = 1;
      } else {
        resolvedMaxY = (maxY * 1.2).ceilToDouble();
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.habitsChartTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: resolvedMaxY,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.9),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.spotIndex;
                          final periodStart = labels[index] ?? DateTime.now();
                          final formatter = DateFormat.Md(loc.localeName);
                          final label = formatter.format(periodStart);
                          final valueLabel = usePercentage
                              ? '${spot.y.toStringAsFixed(1)} %'
                              : numberFormat.format(spot.y);
                          return LineTooltipItem(
                            '$label\n$valueLabel',
                            Theme.of(context).textTheme.bodyMedium!,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: usePercentage ? 20 : null,
                        getTitlesWidget: (value, _) {
                          final text = usePercentage
                              ? '${value.toStringAsFixed(0)}%'
                              : numberFormat.format(value);
                          return Text(text, style: const TextStyle(fontSize: 11));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          final date = labels[index];
                          if (date == null) {
                            return const SizedBox.shrink();
                          }
                          final formatter = DateFormat.Md(loc.localeName);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              formatter.format(date),
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (usePercentage)
                        HorizontalLine(
                          y: 100,
                          dashArray: [6, 4],
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      else if (target != null)
                        HorizontalLine(
                          y: target,
                          dashArray: [6, 4],
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    ],
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitLogTile extends StatelessWidget {
  const _HabitLogTile({
    required this.habit,
    required this.log,
    required this.onDelete,
  });

  final HabitDefinition habit;
  final HabitLog log;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final date = log.occurredAt.toLocal();
    final dateLabel = DateFormat.yMMMd().add_Hm().format(date);
    String valueLabel;
    if (habit.measurementKind == HabitValueKind.boolean) {
      valueLabel = loc.habitsLogBooleanValue;
    } else {
      final numberFormat = NumberFormat.decimalPattern(loc.localeName);
      valueLabel = numberFormat.format(log.value);
    }

    return Card(
      child: ListTile(
        title: Text(dateLabel),
        subtitle: Text(valueLabel),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: loc.habitsDeleteEntryTooltip,
          onPressed: onDelete,
        ),
      ),
    );
  }
}
