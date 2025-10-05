import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class AccountSignInPage extends StatelessWidget {
  const AccountSignInPage({super.key});

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
          _SignInOption(
            icon: Icons.mail_outline,
            title: l10n.settingsAccountSignInOptionEmail,
            subtitle: l10n.settingsAccountSignInOptionComingSoon,
          ),
          _SignInOption(
            icon: Icons.g_mobiledata,
            title: l10n.settingsAccountSignInOptionGoogle,
            subtitle: l10n.settingsAccountSignInOptionComingSoon,
          ),
          _SignInOption(
            icon: Icons.apple,
            title: l10n.settingsAccountSignInOptionApple,
            subtitle: l10n.settingsAccountSignInOptionComingSoon,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
            },
            child: Text(l10n.settingsAccountSignInButton),
          ),
        ],
      ),
    );
  }
}

class _SignInOption extends StatelessWidget {
  const _SignInOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(subtitle)));
        },
      ),
    );
  }
}
