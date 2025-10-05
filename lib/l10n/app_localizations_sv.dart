// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Tracker';

  @override
  String get tabDashboard => 'Översikt';

  @override
  String get tabTasks => 'Uppgifter';

  @override
  String get tabNotes => 'Anteckningar';

  @override
  String get tabHabits => 'Vanor';

  @override
  String get tabHousehold => 'Hushåll';

  @override
  String get tabSettings => 'Inställningar';

  @override
  String get dashboardPlaceholder => 'Översikten byggs här.';

  @override
  String get tasksPlaceholder => 'Planera och hantera uppgifter och möten här.';

  @override
  String get notesPlaceholder => 'Skapa och organisera anteckningar här.';

  @override
  String get habitsPlaceholder => 'Följ dina vanor på denna sida.';

  @override
  String get householdPlaceholder => 'Hantera hushållets ekonomi här.';

  @override
  String get settingsPlaceholder => 'Justera dina inställningar här.';
}
