import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/app/widgets/feature_placeholder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholder(
      icon: Icons.dashboard_outlined,
      title: l10n.tabDashboard,
      message: l10n.dashboardPlaceholder,
    );
  }
}
