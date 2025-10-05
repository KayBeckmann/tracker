import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/app/widgets/feature_placeholder.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholder(
      icon: Icons.flag_outlined,
      title: l10n.tabHabits,
      message: l10n.habitsPlaceholder,
    );
  }
}
