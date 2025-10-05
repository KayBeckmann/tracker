import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/app/widgets/feature_placeholder.dart';

class HouseholdPage extends StatelessWidget {
  const HouseholdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholder(
      icon: Icons.account_balance_wallet_outlined,
      title: l10n.tabHousehold,
      message: l10n.householdPlaceholder,
    );
  }
}
