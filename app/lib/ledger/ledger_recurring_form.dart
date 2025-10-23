import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'ledger_localized_labels.dart';

class LedgerRecurringFormResult {
  const LedgerRecurringFormResult({
    required this.name,
    required this.transactionKind,
    required this.amount,
    required this.currencyCode,
    required this.intervalKind,
    required this.intervalCount,
    required this.nextOccurrence,
    required this.autoApply,
    this.accountId,
    this.targetAccountId,
    this.categoryId,
    this.subcategoryId,
    this.metadataJson,
  });

  final String name;
  final LedgerTransactionKind transactionKind;
  final double amount;
  final String currencyCode;
  final LedgerRecurringIntervalKind intervalKind;
  final int intervalCount;
  final DateTime nextOccurrence;
  final bool autoApply;
  final int? accountId;
  final int? targetAccountId;
  final int? categoryId;
  final int? subcategoryId;
  final String? metadataJson;
}

Future<LedgerRecurringFormResult?> showLedgerRecurringFormDialog({
  required BuildContext context,
  LedgerRecurringTransaction? existing,
  required List<LedgerAccount> accounts,
  required List<LedgerCategory> categories,
}) {
  return showDialog<LedgerRecurringFormResult>(
    context: context,
    builder: (context) {
      return _LedgerRecurringFormDialog(
        existing: existing,
        accounts: accounts,
        categories: categories,
      );
    },
  );
}

class _LedgerRecurringFormDialog extends StatefulWidget {
  const _LedgerRecurringFormDialog({
    required this.accounts,
    required this.categories,
    this.existing,
  });

  final List<LedgerAccount> accounts;
  final List<LedgerCategory> categories;
  final LedgerRecurringTransaction? existing;

  @override
  State<_LedgerRecurringFormDialog> createState() =>
      _LedgerRecurringFormDialogState();
}

class _LedgerRecurringFormDialogState
    extends State<_LedgerRecurringFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late LedgerTransactionKind _transactionKind;
  late TextEditingController _amountController;
  late TextEditingController _currencyController;
  late int? _accountId;
  late int? _targetAccountId;
  late int? _categoryId;
  late int? _subcategoryId;
  late LedgerRecurringIntervalKind _intervalKind;
  late TextEditingController _intervalCountController;
  late DateTime _nextOccurrence;
  late bool _autoApply;
  late TextEditingController _metadataController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _transactionKind =
        existing?.transactionKind ?? LedgerTransactionKind.expense;
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(2) : '',
    );
    _currencyController = TextEditingController(
      text: existing?.currencyCode ?? 'EUR',
    );
    _accountId =
        existing?.accountId ??
        (widget.accounts.isNotEmpty ? widget.accounts.first.id : null);
    _targetAccountId = existing?.targetAccountId;
    _categoryId = existing?.categoryId;
    _subcategoryId = existing?.subcategoryId;
    _intervalKind =
        existing?.intervalKind ?? LedgerRecurringIntervalKind.monthly;
    _intervalCountController = TextEditingController(
      text: (existing?.intervalCount ?? 1).toString(),
    );
    _nextOccurrence = (existing?.nextOccurrence ?? DateTime.now()).toLocal();
    _autoApply = existing?.autoApply ?? false;
    _metadataController = TextEditingController(
      text: existing?.metadataJson ?? '{}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _currencyController.dispose();
    _intervalCountController.dispose();
    _metadataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final showCategoryFields =
        _transactionKind == LedgerTransactionKind.expense ||
        _transactionKind == LedgerTransactionKind.income;
    final showTargetField = _transactionKind == LedgerTransactionKind.transfer;
    final categories = _filteredCategories();
    final subcategories = _filteredSubcategories();

    return AlertDialog(
      title: Text(
        widget.existing == null
            ? loc.ledgerRecurringCreateTitle
            : loc.ledgerRecurringEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.ledgerRecurringNameLabel,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LedgerTransactionKind>(
                value: _transactionKind,
                decoration: InputDecoration(
                  labelText: loc.ledgerTransactionKindLabel,
                ),
                items: LedgerTransactionKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(ledgerTransactionKindLabel(loc, kind)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _transactionKind = value;
                    if (_transactionKind == LedgerTransactionKind.transfer) {
                      _categoryId = null;
                      _subcategoryId = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _accountId,
                decoration: InputDecoration(
                  labelText: _transactionKind == LedgerTransactionKind.transfer
                      ? loc.ledgerTransactionSourceAccountLabel
                      : loc.ledgerTransactionAccountLabel,
                ),
                items: widget.accounts
                    .map(
                      (account) => DropdownMenuItem(
                        value: account.id,
                        child: Text(
                          '${account.name} (${account.currencyCode})',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _accountId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return loc.validationRequiredField;
                  }
                  if (_transactionKind == LedgerTransactionKind.transfer &&
                      _targetAccountId != null &&
                      value == _targetAccountId) {
                    return loc.ledgerValidationDifferentAccounts;
                  }
                  return null;
                },
              ),
              if (showTargetField) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _targetAccountId,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionTargetAccountLabel,
                  ),
                  items: widget.accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(
                            '${account.name} (${account.currencyCode})',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _targetAccountId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return loc.validationRequiredField;
                    }
                    if (value == _accountId) {
                      return loc.ledgerValidationDifferentAccounts;
                    }
                    return null;
                  },
                ),
              ],
              if (showCategoryFields) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _categoryId,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionCategoryLabel,
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoryId = value;
                      _subcategoryId = null;
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
                DropdownButtonFormField<int?>(
                  value: _subcategoryId,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionSubcategoryLabel,
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(loc.ledgerTransactionNoSubcategory),
                    ),
                    ...subcategories.map(
                      (subcategory) => DropdownMenuItem<int?>(
                        value: subcategory.id,
                        child: Text(subcategory.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _subcategoryId = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: loc.ledgerRecurringAmountLabel,
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
                  labelText: loc.ledgerRecurringCurrencyLabel,
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
              const SizedBox(height: 12),
              DropdownButtonFormField<LedgerRecurringIntervalKind>(
                value: _intervalKind,
                decoration: InputDecoration(
                  labelText: loc.ledgerRecurringIntervalLabel,
                ),
                items: LedgerRecurringIntervalKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(ledgerRecurringIntervalLabel(loc, kind)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _intervalKind = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _intervalCountController,
                decoration: InputDecoration(
                  labelText: loc.ledgerRecurringIntervalCountLabel,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return loc.validationNumberField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _pickNextOccurrence,
                  icon: const Icon(Icons.event_repeat),
                  label: Text(
                    loc.ledgerRecurringNextOccurrenceLabel(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(_nextOccurrence),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _autoApply,
                onChanged: (value) {
                  setState(() {
                    _autoApply = value;
                  });
                },
                title: Text(loc.ledgerRecurringAutoApplyLabel),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _metadataController,
                decoration: InputDecoration(
                  labelText: loc.ledgerRecurringMetadataLabel,
                ),
                maxLines: 3,
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

  List<LedgerCategory> _filteredCategories() {
    final kind = _transactionKind == LedgerTransactionKind.income
        ? LedgerCategoryKind.income
        : LedgerCategoryKind.expense;
    return widget.categories
        .where(
          (category) =>
              category.parentId == null && category.categoryKind == kind,
        )
        .toList();
  }

  List<LedgerCategory> _filteredSubcategories() {
    if (_categoryId == null) {
      return const <LedgerCategory>[];
    }
    return widget.categories
        .where((category) => category.parentId == _categoryId)
        .toList();
  }

  Future<void> _pickNextOccurrence() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _nextOccurrence,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      setState(() {
        _nextOccurrence = DateTime(
          selected.year,
          selected.month,
          selected.day,
          12,
        );
      });
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final intervalCount = int.parse(_intervalCountController.text);
    Navigator.of(context).pop(
      LedgerRecurringFormResult(
        name: _nameController.text.trim(),
        transactionKind: _transactionKind,
        amount: amount,
        currencyCode: _currencyController.text.trim().toUpperCase(),
        intervalKind: _intervalKind,
        intervalCount: intervalCount,
        nextOccurrence: _nextOccurrence,
        autoApply: _autoApply,
        accountId: _accountId,
        targetAccountId: _transactionKind == LedgerTransactionKind.transfer
            ? _targetAccountId
            : null,
        categoryId:
            (_transactionKind == LedgerTransactionKind.income ||
                _transactionKind == LedgerTransactionKind.expense)
            ? _categoryId
            : null,
        subcategoryId:
            (_transactionKind == LedgerTransactionKind.income ||
                _transactionKind == LedgerTransactionKind.expense)
            ? _subcategoryId
            : null,
        metadataJson: _metadataController.text.trim().isEmpty
            ? null
            : _metadataController.text.trim(),
      ),
    );
  }
}
