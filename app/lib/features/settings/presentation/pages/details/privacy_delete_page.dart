import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class PrivacyDeletePage extends StatelessWidget {
  const PrivacyDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrivacyDeleteTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsPrivacyDeleteWarning,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.settingsPrivacyDeleteDescriptionLong,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsComingSoon)),
                );
              },
              icon: const Icon(Icons.delete_forever_outlined),
              label: Text(l10n.settingsPrivacyDeleteButton),
            ),
          ],
        ),
      ),
    );
  }
}
