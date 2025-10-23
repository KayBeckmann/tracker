import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import '../l10n/generated/app_localizations.dart';
import 'ledger_localized_labels.dart';

class LedgerCategoryFormResult {
  const LedgerCategoryFormResult({
    required this.name,
    required this.categoryKind,
    required this.parentId,
    required this.archived,
  });

  final String name;
  final LedgerCategoryKind categoryKind;
  final int? parentId;
  final bool archived;
}

Future<LedgerCategoryFormResult?> showLedgerCategoryFormDialog({
  required BuildContext context,
  LedgerCategory? existing,
  required List<LedgerCategory> categories,
  LedgerCategory? parent,
  LedgerCategoryKind? initialKind,
}) {
  return showDialog<LedgerCategoryFormResult>(
    context: context,
    builder: (context) {
      return _LedgerCategoryFormDialog(
        existing: existing,
        categories: categories,
        parent: parent,
        initialKind: initialKind,
      );
    },
  );
}

class _LedgerCategoryFormDialog extends StatefulWidget {
  const _LedgerCategoryFormDialog({
    required this.categories,
    this.existing,
    this.parent,
    this.initialKind,
  });

  final List<LedgerCategory> categories;
  final LedgerCategory? existing;
  final LedgerCategory? parent;
  final LedgerCategoryKind? initialKind;

  @override
  State<_LedgerCategoryFormDialog> createState() =>
      _LedgerCategoryFormDialogState();
}

class _LedgerCategoryFormDialogState extends State<_LedgerCategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late LedgerCategoryKind _categoryKind;
  late int? _parentId;
  late bool _archived;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    if (existing != null) {
      _categoryKind = existing.categoryKind;
      _parentId = existing.parentId;
      _archived = existing.isArchived;
    } else if (widget.parent != null) {
      _categoryKind = widget.parent!.categoryKind;
      _parentId = widget.parent!.id;
      _archived = false;
    } else {
      _categoryKind = widget.initialKind ?? LedgerCategoryKind.expense;
      _parentId = null;
      _archived = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final parentOptions = [
      DropdownMenuItem<int?>(
        value: null,
        child: Text(loc.ledgerCategoryNoParent),
      ),
      ...widget.categories
          .where((category) => category.parentId == null)
          .where((category) => category.id != widget.existing?.id)
          .map(
            (category) => DropdownMenuItem<int?>(
              value: category.id,
              child: Text(category.name),
            ),
          ),
    ];

    return AlertDialog(
      title: Text(
        widget.existing == null
            ? loc.ledgerCategoryCreateTitle
            : loc.ledgerCategoryEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.ledgerCategoryNameLabel,
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return loc.validationRequiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _parentId,
              decoration: InputDecoration(
                labelText: loc.ledgerCategoryParentLabel,
              ),
              items: parentOptions,
              onChanged: (value) {
                setState(() {
                  _parentId = value;
                  if (value != null) {
                    final parent = widget.categories.firstWhere(
                      (category) => category.id == value,
                    );
                    _categoryKind = parent.categoryKind;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<LedgerCategoryKind>(
              value: _categoryKind,
              decoration: InputDecoration(
                labelText: loc.ledgerCategoryKindLabel,
              ),
              items: LedgerCategoryKind.values
                  .map(
                    (kind) => DropdownMenuItem(
                      value: kind,
                      child: Text(ledgerCategoryKindLabel(loc, kind)),
                    ),
                  )
                  .toList(),
              onChanged: _parentId != null
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _categoryKind = value;
                      });
                    },
            ),
            const SizedBox(height: 12),
            if (widget.existing != null)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _archived,
                onChanged: (value) {
                  setState(() {
                    _archived = value;
                  });
                },
                title: Text(loc.ledgerCategoryArchiveLabel),
              ),
          ],
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
    Navigator.of(context).pop(
      LedgerCategoryFormResult(
        name: _nameController.text.trim(),
        categoryKind: _categoryKind,
        parentId: _parentId,
        archived: _archived,
      ),
    );
  }
}
