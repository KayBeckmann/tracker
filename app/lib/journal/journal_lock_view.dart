import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

class JournalLockView extends StatefulWidget {
  const JournalLockView({
    super.key,
    required this.hasPin,
    required this.biometricEnabled,
    required this.onValidatePin,
    required this.onUnlocked,
    this.onBiometricUnlock,
  });

  final bool hasPin;
  final bool biometricEnabled;
  final Future<bool> Function(String pin) onValidatePin;
  final Future<bool> Function(BuildContext context)? onBiometricUnlock;
  final VoidCallback onUnlocked;

  @override
  State<JournalLockView> createState() => _JournalLockViewState();
}

class _JournalLockViewState extends State<JournalLockView> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    if (!widget.hasPin || _isProcessing) {
      return;
    }
    final loc = AppLocalizations.of(context);
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() {
        _errorMessage = loc.journalPinRequired;
      });
      return;
    }
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    final success = await widget.onValidatePin(pin);
    if (!mounted) {
      return;
    }
    setState(() {
      _isProcessing = false;
    });
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.journalUnlockSuccess)));
      widget.onUnlocked();
      _pinController.clear();
    } else {
      setState(() {
        _errorMessage = loc.journalUnlockFailed;
      });
      _pinController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _pinController.text.length,
      );
      _pinFocusNode.requestFocus();
    }
  }

  Future<void> _handleBiometricUnlock() async {
    if (widget.onBiometricUnlock == null || _isProcessing) {
      return;
    }
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    final success = await widget.onBiometricUnlock!(context);
    if (!mounted) {
      return;
    }
    setState(() {
      _isProcessing = false;
    });
    if (success) {
      widget.onUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.journalLockedTitle,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.journalLockedMessage,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (widget.hasPin)
                  TextField(
                    controller: _pinController,
                    focusNode: _pinFocusNode,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    enabled: !_isProcessing,
                    decoration: InputDecoration(labelText: loc.journalPinLabel),
                    onSubmitted: (_) => _submitPin(),
                  ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (widget.hasPin)
                      FilledButton.icon(
                        onPressed: _isProcessing ? null : _submitPin,
                        icon: const Icon(Icons.lock_open),
                        label: Text(loc.journalUnlockWithPin),
                      ),
                    if (widget.biometricEnabled)
                      OutlinedButton.icon(
                        onPressed: _isProcessing
                            ? null
                            : _handleBiometricUnlock,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(loc.journalUnlockWithBiometrics),
                      ),
                  ],
                ),
                if (!widget.hasPin && !widget.biometricEnabled)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      loc.journalNoProtectionConfigured,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
