import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class PrivacyExportPage extends StatelessWidget {
  const PrivacyExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrivacyExportTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsPrivacyExportDescriptionLong,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsComingSoon)),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: Text(l10n.settingsPrivacyExportButton),
            ),
          ],
        ),
      ),
    );
  }
}
