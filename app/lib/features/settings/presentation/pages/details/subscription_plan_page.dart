import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class SubscriptionPlanPage extends StatelessWidget {
  const SubscriptionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSubscriptionPlanTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsSubscriptionPlanPricing,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsSubscriptionPlanDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsSubscriptionPlanBenefits,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...[
            l10n.settingsSubscriptionBenefitSync,
            l10n.settingsSubscriptionBenefitBackup,
            l10n.settingsSubscriptionBenefitSupport,
          ].map(
            (benefit) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(benefit),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
            },
            child: Text(l10n.settingsSubscriptionPlanButton),
          ),
        ],
      ),
    );
  }
}
