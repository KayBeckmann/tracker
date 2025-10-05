import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAccountSecurityTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsAccountSecurityDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: null,
                  secondary: const Icon(Icons.mail_outline),
                  title: Text(l10n.settingsAccountSignInOptionEmail),
                  subtitle: Text(l10n.settingsAccountSecurityManageProviders),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: null,
                  secondary: const Icon(Icons.g_mobiledata),
                  title: Text(l10n.settingsAccountSignInOptionGoogle),
                  subtitle: Text(l10n.settingsAccountSecurityManageProviders),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: false,
                  onChanged: null,
                  secondary: const Icon(Icons.apple),
                  title: Text(l10n.settingsAccountSignInOptionApple),
                  subtitle: Text(l10n.settingsAccountSecurityManageProviders),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
            },
            child: Text(l10n.settingsAccountSecurityManageProviders),
          ),
        ],
      ),
    );
  }
}
