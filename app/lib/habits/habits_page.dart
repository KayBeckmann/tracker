import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'habit_detail_page.dart';
import 'habit_form.dart';
import 'habit_utils.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return StreamBuilder<List<HabitDefinition>>(
      stream: widget.database.watchHabits(),
      builder: (context, snapshot) {
        final habits = snapshot.data ?? const <HabitDefinition>[];
        if (habits.isEmpty) {
          return _EmptyHabitsHint(
            onCreateHabit: _addHabit,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _addHabit,
                icon: const Icon(Icons.add),
                label: Text(loc.habitsAddHabitButton),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return _HabitCard(
                    habit: habit,
                    database: widget.database,
                    isSubmitting: _isSubmitting,
                    onSubmittingChanged: _setSubmitting,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: habits.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addHabit() async {
    final loc = AppLocalizations.of(context);
    final result = await showHabitFormDialog(context: context);
    if (result == null) {
      return;
    }
    try {
      setState(() {
        _isSubmitting = true;
      });
      await widget.database.createHabit(
        name: result.name,
        description: result.description,
        interval: result.interval,
        measurementKind: result.measurementKind,
        targetOccurrences: result.targetOccurrences,
        targetValue: result.targetValue,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.habitsCreateSuccess(result.name))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _setSubmitting(bool submitting) {
    if (_isSubmitting == submitting) {
      return;
    }
    setState(() {
      _isSubmitting = submitting;
    });
  }
}

class _EmptyHabitsHint extends StatelessWidget {
  const _EmptyHabitsHint({required this.onCreateHabit});

  final VoidCallback onCreateHabit;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_graph, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              loc.habitsEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              loc.habitsEmptyDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateHabit,
              icon: const Icon(Icons.add),
              label: Text(loc.habitsAddHabitButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.habit,
    required this.database,
    required this.isSubmitting,
    required this.onSubmittingChanged,
  });

  final HabitDefinition habit;
  final AppDatabase database;
  final bool isSubmitting;
  final ValueChanged<bool> onSubmittingChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<HabitLog>>(
          stream: database.watchHabitLogs(habit.id),
          builder: (context, snapshot) {
            final logs = snapshot.data ?? const <HabitLog>[];
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
            final total = periodLogs.fold<double>(
              0,
              (prev, log) => prev + log.value,
            );
            final target = habitTargetValue(habit);
            final progressValue = target == null || target <= 0
                ? 0.0
                : (total / target).clamp(0, 1).toDouble();

            final bool singleCompletion = isSingleCompletionHabit(habit);
            final bool completed =
                isBooleanHabit(habit) && singleCompletion && periodLogs.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (habit.description.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              habit.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            _buildSubtitle(loc, habit),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: loc.habitsOpenDetails,
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => _openDetails(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: target == null || target <= 0 ? null : progressValue,
                  minHeight: 8,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(height: 8),
                Text(
                  _progressLabel(
                    loc,
                    habit,
                    total: total,
                    periodLogs: periodLogs,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    if (isBooleanHabit(habit))
                      FilledButton(
                        onPressed:
                            isSubmitting ? null : () => _toggleBoolean(context, completed),
                        child: Text(
                          singleCompletion
                              ? (completed
                                  ? loc.habitsUndoTodayButton
                                  : loc.habitsMarkDoneButton)
                              : loc.habitsAddCompletion,
                        ),
                      )
                    else
                      FilledButton(
                        onPressed:
                            isSubmitting ? null : () => _promptNumericLog(context),
                        child: Text(loc.habitsAddMeasurement),
                      ),
                    OutlinedButton(
                      onPressed: () => _openDetails(context),
                      child: Text(loc.habitsOpenDetails),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _toggleBoolean(BuildContext context, bool completed) async {
    final now = DateTime.now();
    final period = periodForHabit(habit, now);
    onSubmittingChanged(true);
    try {
      if (completed && isSingleCompletionHabit(habit)) {
        await database.deleteHabitLogsForRange(
          habitId: habit.id,
          start: period.start,
          end: period.end,
        );
      } else {
        await database.insertHabitLog(
          habitId: habit.id,
          value: 1,
        );
      }
    } finally {
      onSubmittingChanged(false);
    }
  }

  Future<void> _promptNumericLog(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final controller = TextEditingController();
    final result = await showDialog<double?>(
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
                if (parsed == null) {
                  Navigator.of(context).pop(null);
                  return;
                }
                Navigator.of(context).pop(parsed);
              },
              child: Text(loc.habitsSaveButton),
            ),
          ],
        );
      },
    );

    if (result == null) {
      return;
    }
    onSubmittingChanged(true);
    try {
      await database.insertHabitLog(
        habitId: habit.id,
        value: result,
      );
    } finally {
      onSubmittingChanged(false);
    }
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HabitDetailPage(
          database: database,
          habit: habit,
        ),
      ),
    );
  }

  String _buildSubtitle(AppLocalizations loc, HabitDefinition habit) {
    final intervalLabel = () {
      switch (habit.interval) {
        case HabitIntervalKind.daily:
          return loc.habitsIntervalDaily;
        case HabitIntervalKind.multiplePerDay:
          return loc.habitsIntervalMultiplePerDay;
        case HabitIntervalKind.weekly:
          return loc.habitsIntervalWeekly;
        case HabitIntervalKind.multiplePerWeek:
          return loc.habitsIntervalMultiplePerWeek;
      }
    }();

    final measurementLabel = () {
      switch (habit.measurementKind) {
        case HabitValueKind.boolean:
          return loc.habitsMeasurementBoolean;
        case HabitValueKind.integer:
          return loc.habitsMeasurementInteger;
        case HabitValueKind.decimal:
          return loc.habitsMeasurementDecimal;
      }
    }();

    if (habit.measurementKind == HabitValueKind.boolean) {
      final occurrences = habit.targetOccurrences;
      if (occurrences <= 1) {
        return loc.habitsSubtitleBooleanSingle(intervalLabel);
      }
      return loc.habitsSubtitleBooleanMultiple(intervalLabel, occurrences);
    }

    final target = habit.targetValue;
    if (target == null || target <= 0) {
      return loc.habitsSubtitleNumeric(intervalLabel, measurementLabel);
    }
    final formatted = NumberFormat.decimalPattern(loc.localeName).format(target);
    return loc.habitsSubtitleNumericTarget(
      intervalLabel,
      measurementLabel,
      formatted,
    );
  }

  String _progressLabel(
    AppLocalizations loc,
    HabitDefinition habit, {
    required double total,
    required List<HabitLog> periodLogs,
  }) {
    final periodLabel = () {
      switch (periodUnitForHabit(habit)) {
        case HabitPeriodUnit.day:
          return loc.habitsPeriodDay;
        case HabitPeriodUnit.week:
          return loc.habitsPeriodWeek;
      }
    }();

    if (habit.measurementKind == HabitValueKind.boolean) {
      final count = periodLogs.length;
      final target = habit.targetOccurrences;
      return loc.habitsProgressCompleted(count, target, periodLabel);
    }

    final numberFormat = NumberFormat.decimalPattern(loc.localeName);
    final totalLabel = numberFormat.format(total);
    final target = habit.targetValue;
    if (target == null || target <= 0) {
      return loc.habitsProgressValueNoTarget(totalLabel, periodLabel);
    }
    final targetLabel = numberFormat.format(target);
    return loc.habitsProgressValue(totalLabel, targetLabel, periodLabel);
  }
}
