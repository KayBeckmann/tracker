import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/l10n/app_localizations.dart';
import 'package:tracker/core/network/serverpod_client.dart';
import 'package:tracker_backend_client/tracker_backend_client.dart';

class AccountSignInPage extends ConsumerStatefulWidget {
  const AccountSignInPage({super.key});

  @override
  ConsumerState<AccountSignInPage> createState() => _AccountSignInPageState();
}

class _AccountSignInPageState extends ConsumerState<AccountSignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAccountSignInTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsAccountSignInLongDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            context,
            controller: _emailController,
            label: l10n.settingsAccountSignInOptionEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            controller: _passwordController,
            label: l10n.settingsAccountPasswordLabel,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            controller: _confirmPasswordController,
            label: l10n.settingsAccountPasswordConfirmLabel,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : () => _submit(register: true),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.settingsAccountRegisterButton),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _isLoading ? null : () => _submit(register: false),
            child: Text(l10n.settingsAccountLoginButton),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      obscureText: obscureText,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
    );
  }

  Future<void> _submit({required bool register}) async {
    final client = ref.read(serverpodClientProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsAccountValidationEmpty)),
      );
      return;
    }

    if (register && password != _confirmPasswordController.text) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsAccountValidationMismatch)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse response = register
          ? await client.auth.register(email, password)
          : await client.auth.login(email, password);

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: response.success
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      );
    } catch (error, _) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('${l10n.settingsAccountUnknownError}: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
