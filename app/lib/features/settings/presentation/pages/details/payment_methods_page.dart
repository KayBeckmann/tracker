import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPaymentMethodsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsPaymentMethodsDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _PaymentMethodTile(
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.settingsPaymentMethodsPaypal,
          ),
          _PaymentMethodTile(
            icon: Icons.currency_bitcoin,
            title: l10n.settingsPaymentMethodsBitcoin,
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.settingsComingSoon)));
            },
            child: Text(l10n.settingsPaymentMethodsManage),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(AppLocalizations.of(context)!.settingsComingSoon),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.settingsComingSoon),
            ),
          );
        },
      ),
    );
  }
}
