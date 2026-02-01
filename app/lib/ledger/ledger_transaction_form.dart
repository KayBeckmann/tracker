import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'ledger_localized_labels.dart';

class LedgerTransactionFormResult {
  const LedgerTransactionFormResult({
    required this.transactionKind,
    required this.amount,
    required this.currencyCode,
    required this.bookingDate,
    required this.isPlanned,
    required this.description,
    this.accountId,
    this.targetAccountId,
    this.categoryId,
    this.subcategoryId,
    this.cryptoSymbol,
    this.cryptoQuantity,
    this.pricePerUnit,
  });

  final LedgerTransactionKind transactionKind;
  final double amount;
  final String currencyCode;
  final DateTime bookingDate;
  final bool isPlanned;
  final String description;
  final int? accountId;
  final int? targetAccountId;
  final int? categoryId;
  final int? subcategoryId;
  final String? cryptoSymbol;
  final double? cryptoQuantity;
  final double? pricePerUnit;
}

Future<LedgerTransactionFormResult?> showLedgerTransactionFormDialog({
  required BuildContext context,
  LedgerTransaction? existing,
  required List<LedgerAccount> accounts,
  required List<LedgerCategory> categories,
}) {
  return showDialog<LedgerTransactionFormResult>(
    context: context,
    builder: (context) {
      return _LedgerTransactionFormDialog(
        existing: existing,
        accounts: accounts,
        categories: categories,
      );
    },
  );
}

class _LedgerTransactionFormDialog extends StatefulWidget {
  const _LedgerTransactionFormDialog({
    required this.accounts,
    required this.categories,
    this.existing,
  });

  final List<LedgerAccount> accounts;
  final List<LedgerCategory> categories;
  final LedgerTransaction? existing;

  @override
  State<_LedgerTransactionFormDialog> createState() =>
      _LedgerTransactionFormDialogState();
}

class _LedgerTransactionFormDialogState
    extends State<_LedgerTransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late LedgerTransactionKind _kind;
  late int? _accountId;
  late int? _targetAccountId;
  late int? _categoryId;
  late int? _subcategoryId;
  late bool _isPlanned;
  late DateTime _bookingDate;
  late TextEditingController _amountController;
  late TextEditingController _currencyController;
  late TextEditingController _descriptionController;
  late TextEditingController _cryptoSymbolController;
  late TextEditingController _cryptoQuantityController;
  late TextEditingController _cryptoPriceController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _kind = existing?.transactionKind ?? LedgerTransactionKind.expense;
    _accountId = existing?.accountId;
    _targetAccountId = existing?.targetAccountId;
    _categoryId = existing?.categoryId;
    _subcategoryId = existing?.subcategoryId;
    _isPlanned = existing?.isPlanned ?? false;
    _bookingDate = (existing?.bookingDate ?? DateTime.now()).toLocal();
    _amountController = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(2) : '',
    );
    _currencyController = TextEditingController(
      text: existing?.currencyCode ?? 'EUR',
    );
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _cryptoSymbolController = TextEditingController(
      text: existing?.cryptoSymbol ?? '',
    );
    _cryptoQuantityController = TextEditingController(
      text: existing?.cryptoQuantity == null
          ? ''
          : existing!.cryptoQuantity!.toString(),
    );
    _cryptoPriceController = TextEditingController(
      text: existing?.pricePerUnit == null
          ? ''
          : existing!.pricePerUnit!.toStringAsFixed(2),
    );
    if (_accountId == null && widget.accounts.isNotEmpty) {
      final defaultAccount = widget.accounts.firstWhereOrNull(
        (account) => account.isDefault,
      );
      _accountId = defaultAccount?.id ?? widget.accounts.first.id;
    }
    if (_kind == LedgerTransactionKind.transfer) {
      if (_targetAccountId == null && widget.accounts.length > 1) {
        _targetAccountId = widget.accounts[1].id;
      }
      if (_targetAccountId == _accountId && widget.accounts.length > 1) {
        _targetAccountId = widget.accounts
            .firstWhere(
              (account) => account.id != _accountId,
              orElse: () => widget.accounts.first,
            )
            .id;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    _descriptionController.dispose();
    _cryptoSymbolController.dispose();
    _cryptoQuantityController.dispose();
    _cryptoPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final relevantCategories = _filteredCategories();
    final relevantSubcategories = _filteredSubcategories();
    final showTargetField = _kind == LedgerTransactionKind.transfer;
    final showCategoryFields =
        _kind == LedgerTransactionKind.expense ||
        _kind == LedgerTransactionKind.income;
    final showCryptoFields = _kind == LedgerTransactionKind.cryptoPurchase;

    return AlertDialog(
      title: Text(
        widget.existing == null
            ? loc.ledgerTransactionCreateTitle
            : loc.ledgerTransactionEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<LedgerTransactionKind>(
                value: _kind,
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
                    _kind = value;
                    if (_kind == LedgerTransactionKind.transfer) {
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
                  labelText: _kind == LedgerTransactionKind.transfer
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
                  if (_kind == LedgerTransactionKind.transfer &&
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
                    if (_kind == LedgerTransactionKind.transfer) {
                      if (value == null) {
                        return loc.validationRequiredField;
                      }
                      if (value == _accountId) {
                        return loc.ledgerValidationDifferentAccounts;
                      }
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
                  items: relevantCategories
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
                    ...relevantSubcategories.map(
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
                  labelText: loc.ledgerTransactionAmountLabel,
                ),
                enabled: _kind != LedgerTransactionKind.cryptoPurchase,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    if (_kind == LedgerTransactionKind.cryptoPurchase) {
                      // Amount will be derived from crypto inputs.
                      return null;
                    }
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
                  labelText: loc.ledgerTransactionCurrencyLabel,
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
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.event),
                  label: Text(
                    loc.ledgerTransactionDateLabel(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(_bookingDate),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: loc.ledgerTransactionDescriptionLabel,
                ),
                maxLines: 2,
              ),
              if (showCryptoFields) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cryptoSymbolController,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionCryptoSymbolLabel,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (_kind == LedgerTransactionKind.cryptoPurchase) {
                      if (value == null || value.trim().isEmpty) {
                        return loc.validationRequiredField;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cryptoQuantityController,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionCryptoQuantityLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (_kind != LedgerTransactionKind.cryptoPurchase) {
                      return null;
                    }
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
                  controller: _cryptoPriceController,
                  decoration: InputDecoration(
                    labelText: loc.ledgerTransactionCryptoPriceLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (_kind != LedgerTransactionKind.cryptoPurchase) {
                      return null;
                    }
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
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _isPlanned,
                onChanged: (value) {
                  setState(() {
                    _isPlanned = value;
                  });
                },
                title: Text(loc.ledgerTransactionPlannedLabel),
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
    final kind = _kind == LedgerTransactionKind.income
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _bookingDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      setState(() {
        _bookingDate = DateTime(
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
    double amount;
    if (_kind == LedgerTransactionKind.cryptoPurchase) {
      final quantity = double.parse(
        _cryptoQuantityController.text.replaceAll(',', '.'),
      );
      final price = double.parse(
        _cryptoPriceController.text.replaceAll(',', '.'),
      );
      amount = quantity * price;
      _amountController.text = amount.toStringAsFixed(2);
    } else {
      amount = double.parse(_amountController.text.replaceAll(',', '.'));
    }
    if (amount <= 0) {
      return;
    }
    final bool hasCategory =
        _kind == LedgerTransactionKind.expense ||
        _kind == LedgerTransactionKind.income;
    Navigator.of(context).pop(
      LedgerTransactionFormResult(
        transactionKind: _kind,
        amount: amount,
        currencyCode: _currencyController.text.trim().toUpperCase(),
        bookingDate: _bookingDate,
        isPlanned: _isPlanned,
        description: _descriptionController.text.trim(),
        accountId: _accountId,
        targetAccountId: _kind == LedgerTransactionKind.transfer
            ? _targetAccountId
            : null,
        categoryId: hasCategory ? _categoryId : null,
        subcategoryId: hasCategory ? _subcategoryId : null,
        cryptoSymbol: _kind == LedgerTransactionKind.cryptoPurchase
            ? _cryptoSymbolController.text.trim().toUpperCase()
            : null,
        cryptoQuantity: _kind == LedgerTransactionKind.cryptoPurchase
            ? double.parse(_cryptoQuantityController.text.replaceAll(',', '.'))
            : null,
        pricePerUnit: _kind == LedgerTransactionKind.cryptoPurchase
            ? double.parse(_cryptoPriceController.text.replaceAll(',', '.'))
            : null,
      ),
    );
  }
}
