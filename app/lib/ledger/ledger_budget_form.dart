import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'ledger_localized_labels.dart';

class LedgerBudgetFormResult {
  const LedgerBudgetFormResult({
    required this.categoryId,
    required this.periodKind,
    required this.year,
    required this.amount,
    required this.currencyCode,
    this.month,
  });

  final int categoryId;
  final LedgerBudgetPeriodKind periodKind;
  final int year;
  final int? month;
  final double amount;
  final String currencyCode;
}

Future<LedgerBudgetFormResult?> showLedgerBudgetFormDialog({
  required BuildContext context,
  LedgerBudget? existing,
  required List<LedgerCategory> categories,
}) {
  return showDialog<LedgerBudgetFormResult>(
    context: context,
    builder: (context) {
      return _LedgerBudgetFormDialog(
        existing: existing,
        categories: categories,
      );
    },
  );
}

class _LedgerBudgetFormDialog extends StatefulWidget {
  const _LedgerBudgetFormDialog({required this.categories, this.existing});

  final List<LedgerCategory> categories;
  final LedgerBudget? existing;

  @override
  State<_LedgerBudgetFormDialog> createState() =>
      _LedgerBudgetFormDialogState();
}

class _LedgerBudgetFormDialogState extends State<_LedgerBudgetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late int? _categoryId;
  late LedgerBudgetPeriodKind _periodKind;
  late int _year;
  late int? _month;
  late TextEditingController _amountController;
  late TextEditingController _currencyController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _categoryId = existing?.categoryId;
    _periodKind = existing?.periodKind ?? LedgerBudgetPeriodKind.monthly;
    _year = existing?.year ?? DateTime.now().year;
    _month = existing?.month;
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(2) : '',
    );
    _currencyController = TextEditingController(
      text: existing?.currencyCode ?? 'EUR',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final categoryOptions = _buildCategoryOptions();
    final showMonthField = _periodKind == LedgerBudgetPeriodKind.monthly;
    final showQuarterField = _periodKind == LedgerBudgetPeriodKind.quarterly;

    return AlertDialog(
      title: Text(
        widget.existing == null
            ? loc.ledgerBudgetCreateTitle
            : loc.ledgerBudgetEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: InputDecoration(
                  labelText: loc.ledgerBudgetCategoryLabel,
                ),
                items: categoryOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option.id,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return loc.validationRequiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LedgerBudgetPeriodKind>(
                value: _periodKind,
                decoration: InputDecoration(
                  labelText: loc.ledgerBudgetPeriodLabel,
                ),
                items: LedgerBudgetPeriodKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(ledgerBudgetPeriodLabel(loc, kind)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _periodKind = value;
                    if (_periodKind == LedgerBudgetPeriodKind.monthly &&
                        _month == null) {
                      _month = DateTime.now().month;
                    }
                    if (_periodKind == LedgerBudgetPeriodKind.quarterly) {
                      _month ??= 1;
                    }
                    if (_periodKind == LedgerBudgetPeriodKind.yearly) {
                      _month = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _year.toString(),
                decoration: InputDecoration(
                  labelText: loc.ledgerBudgetYearLabel,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    _year = parsed;
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed < 1900) {
                    return loc.validationNumberField;
                  }
                  return null;
                },
              ),
              if (showMonthField) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _month ?? DateTime.now().month,
                  decoration: InputDecoration(
                    labelText: loc.ledgerBudgetMonthLabel,
                  ),
                  items: List.generate(12, (index) {
                    final monthName = DateFormat.MMMM(
                      loc.localeName,
                    ).format(DateTime(2000, index + 1));
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(monthName),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _month = value;
                    });
                  },
                ),
              ],
              if (showQuarterField) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _month ?? 1,
                  decoration: InputDecoration(
                    labelText: loc.ledgerBudgetQuarterLabel,
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Q1')),
                    DropdownMenuItem(value: 4, child: Text('Q2')),
                    DropdownMenuItem(value: 7, child: Text('Q3')),
                    DropdownMenuItem(value: 10, child: Text('Q4')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _month = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: loc.ledgerBudgetAmountLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  final normalized = value.replaceAll(',', '.');
                  final parsed = double.tryParse(normalized);
                  if (parsed == null || parsed <= 0) {
                    return loc.validationNumberField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currencyController,
                decoration: InputDecoration(
                  labelText: loc.ledgerBudgetCurrencyLabel,
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  if (value.trim().length != 3) {
                    return loc.ledgerValidationCurrencyCode;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.commonCancel),
        ),
        FilledButton(onPressed: _handleSubmit, child: Text(loc.commonSave)),
      ],
    );
  }

  List<_CategoryOption> _buildCategoryOptions() {
    final options = <_CategoryOption>[];
    for (final category in widget.categories.where((c) => c.parentId == null)) {
      options.add(_CategoryOption(id: category.id, label: category.name));
      final children = widget.categories
          .where((child) => child.parentId == category.id)
          .toList();
      for (final child in children) {
        options.add(
          _CategoryOption(
            id: child.id,
            label: '${category.name} › ${child.name}',
          ),
        );
      }
    }
    return options;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    Navigator.of(context).pop(
      LedgerBudgetFormResult(
        categoryId: _categoryId!,
        periodKind: _periodKind,
        year: _year,
        month: _periodKind == LedgerBudgetPeriodKind.yearly ? null : _month,
        amount: amount,
        currencyCode: _currencyController.text.trim().toUpperCase(),
      ),
    );
  }
}

class _CategoryOption {
  _CategoryOption({required this.id, required this.label});

  final int id;
  final String label;
}
