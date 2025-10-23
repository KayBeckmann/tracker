import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'ledger_localized_labels.dart';

class LedgerAccountFormResult {
  const LedgerAccountFormResult({
    required this.name,
    required this.accountKind,
    required this.currencyCode,
    required this.includeInNetWorth,
    required this.initialBalance,
  });

  final String name;
  final LedgerAccountKind accountKind;
  final String currencyCode;
  final bool includeInNetWorth;
  final double initialBalance;
}

Future<LedgerAccountFormResult?> showLedgerAccountFormDialog({
  required BuildContext context,
  LedgerAccount? existing,
}) {
  return showDialog<LedgerAccountFormResult>(
    context: context,
    builder: (context) {
      return _LedgerAccountFormDialog(existing: existing);
    },
  );
}

class _LedgerAccountFormDialog extends StatefulWidget {
  const _LedgerAccountFormDialog({this.existing});

  final LedgerAccount? existing;

  @override
  State<_LedgerAccountFormDialog> createState() =>
      _LedgerAccountFormDialogState();
}

class _LedgerAccountFormDialogState extends State<_LedgerAccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _currencyController;
  late final TextEditingController _initialBalanceController;
  late LedgerAccountKind _accountKind;
  late bool _includeInNetWorth;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _currencyController = TextEditingController(
      text: existing?.currencyCode ?? 'EUR',
    );
    _initialBalanceController = TextEditingController(
      text: existing?.initialBalance.toStringAsFixed(2) ?? '0',
    );
    _accountKind = existing?.accountKind ?? LedgerAccountKind.cash;
    _includeInNetWorth = existing?.includeInNetWorth ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.existing == null
            ? loc.ledgerAccountCreateTitle
            : loc.ledgerAccountEditTitle,
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
                  labelText: loc.ledgerAccountNameLabel,
                ),
                textInputAction: TextInputAction.next,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LedgerAccountKind>(
                value: _accountKind,
                decoration: InputDecoration(
                  labelText: loc.ledgerAccountKindLabel,
                ),
                items: LedgerAccountKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(ledgerAccountKindLabel(loc, kind)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _accountKind = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currencyController,
                decoration: InputDecoration(
                  labelText: loc.ledgerAccountCurrencyLabel,
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
              TextFormField(
                controller: _initialBalanceController,
                decoration: InputDecoration(
                  labelText: loc.ledgerAccountInitialBalanceLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return loc.validationRequiredField;
                  }
                  final normalized = value.replaceAll(',', '.');
                  if (double.tryParse(normalized) == null) {
                    return loc.validationNumberField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _includeInNetWorth,
                onChanged: (value) {
                  setState(() {
                    _includeInNetWorth = value;
                  });
                },
                title: Text(loc.ledgerAccountIncludeInNetWorthLabel),
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

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final normalizedCurrency = _currencyController.text.trim().toUpperCase();
    final normalizedBalance = double.parse(
      _initialBalanceController.text.replaceAll(',', '.'),
    );
    Navigator.of(context).pop(
      LedgerAccountFormResult(
        name: _nameController.text.trim(),
        accountKind: _accountKind,
        currencyCode: normalizedCurrency,
        includeInNetWorth: _includeInNetWorth,
        initialBalance: normalizedBalance,
      ),
    );
  }
}
