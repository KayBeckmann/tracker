import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/app/widgets/feature_placeholder.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FeaturePlaceholder(
      icon: Icons.note_alt_outlined,
      title: l10n.tabNotes,
      message: l10n.notesPlaceholder,
    );
  }
}
