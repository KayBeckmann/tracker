import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';

class HabitFormResult {
  const HabitFormResult({
    required this.name,
    required this.description,
    required this.interval,
    required this.measurementKind,
    required this.targetOccurrences,
    required this.targetValue,
  });

  final String name;
  final String description;
  final HabitIntervalKind interval;
  final HabitValueKind measurementKind;
  final int targetOccurrences;
  final double? targetValue;
}

Future<HabitFormResult?> showHabitFormDialog({
  required BuildContext context,
  HabitDefinition? initialHabit,
}) {
  return showDialog<HabitFormResult>(
    context: context,
    builder: (context) => _HabitFormDialog(initialHabit: initialHabit),
  );
}

class _HabitFormDialog extends StatefulWidget {
  const _HabitFormDialog({required this.initialHabit});

  final HabitDefinition? initialHabit;

  @override
  State<_HabitFormDialog> createState() => _HabitFormDialogState();
}

class _HabitFormDialogState extends State<_HabitFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _occurrencesController;
  late final TextEditingController _targetValueController;

  late HabitIntervalKind _interval;
  late HabitValueKind _measurementKind;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialHabit;
    _interval = initial?.interval ?? HabitIntervalKind.daily;
    _measurementKind = initial?.measurementKind ?? HabitValueKind.boolean;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _occurrencesController = TextEditingController(
      text: (initial?.targetOccurrences ?? 1).toString(),
    );
    final double? targetValue;
    if (initial?.targetValue != null) {
      targetValue = initial!.targetValue;
    } else if (initial != null &&
        initial.measurementKind == HabitValueKind.boolean) {
      targetValue = initial.targetOccurrences.toDouble();
    } else {
      targetValue = null;
    }
    _targetValueController = TextEditingController(
      text: targetValue == null ? '' : targetValue.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _occurrencesController.dispose();
    _targetValueController.dispose();
    super.dispose();
  }

  bool get _showsOccurrencesField {
    return _interval == HabitIntervalKind.multiplePerDay ||
        _interval == HabitIntervalKind.multiplePerWeek;
  }

  bool get _showsTargetValueField {
    return _measurementKind != HabitValueKind.boolean;
  }

  void _submit() {
    final current = _formKey.currentState;
    if (current == null || !current.validate()) {
      return;
    }
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final occurrences = _parseOccurrences();
    final targetValue = _parseTargetValue(occurrences: occurrences);

    Navigator.of(context).pop(
      HabitFormResult(
        name: name,
        description: description,
        interval: _interval,
        measurementKind: _measurementKind,
        targetOccurrences: occurrences,
        targetValue: targetValue,
      ),
    );
  }

  int _parseOccurrences() {
    if (!_showsOccurrencesField) {
      return 1;
    }
    final parsed = int.tryParse(_occurrencesController.text.trim());
    if (parsed == null || parsed <= 0) {
      return 1;
    }
    return parsed.clamp(1, 999);
  }

  double? _parseTargetValue({required int occurrences}) {
    if (!_showsTargetValueField) {
      return _measurementKind == HabitValueKind.boolean
          ? occurrences.toDouble()
          : null;
    }
    final raw = _targetValueController.text.trim();
    if (raw.isEmpty) {
      return null;
    }
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null) {
      return null;
    }
    if (parsed <= 0) {
      return null;
    }
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isEditing = widget.initialHabit != null;

    return AlertDialog(
      title: Text(
        isEditing ? loc.habitsEditTitle : loc.habitsCreateTitle,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: loc.habitsNameLabel),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.habitsNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    InputDecoration(labelText: loc.habitsDescriptionLabel),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<HabitIntervalKind>(
                value: _interval,
                decoration:
                    InputDecoration(labelText: loc.habitsIntervalLabel),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _interval = value;
                  });
                },
                items: HabitIntervalKind.values
                    .map(
                      (interval) => DropdownMenuItem(
                        value: interval,
                        child: Text(_intervalLabel(loc, interval)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<HabitValueKind>(
                value: _measurementKind,
                decoration: InputDecoration(
                  labelText: loc.habitsMeasurementLabel,
                ),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _measurementKind = value;
                  });
                },
                items: HabitValueKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(_measurementLabel(loc, kind)),
                      ),
                    )
                    .toList(),
              ),
              if (_showsOccurrencesField) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _occurrencesController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: loc.habitsTargetOccurrences),
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed <= 0) {
                      return loc.habitsInvalidNumber;
                    }
                    return null;
                  },
                ),
              ],
              if (_showsTargetValueField) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _targetValueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(labelText: loc.habitsTargetValueLabel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final parsed =
                        double.tryParse(value.trim().replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return loc.habitsInvalidNumber;
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.habitsCancelButton),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(loc.habitsSaveButton),
        ),
      ],
    );
  }

  String _intervalLabel(AppLocalizations loc, HabitIntervalKind interval) {
    switch (interval) {
      case HabitIntervalKind.daily:
        return loc.habitsIntervalDaily;
      case HabitIntervalKind.multiplePerDay:
        return loc.habitsIntervalMultiplePerDay;
      case HabitIntervalKind.weekly:
        return loc.habitsIntervalWeekly;
      case HabitIntervalKind.multiplePerWeek:
        return loc.habitsIntervalMultiplePerWeek;
    }
  }

  String _measurementLabel(AppLocalizations loc, HabitValueKind kind) {
    switch (kind) {
      case HabitValueKind.boolean:
        return loc.habitsMeasurementBoolean;
      case HabitValueKind.integer:
        return loc.habitsMeasurementInteger;
      case HabitValueKind.decimal:
        return loc.habitsMeasurementDecimal;
    }
  }
}
