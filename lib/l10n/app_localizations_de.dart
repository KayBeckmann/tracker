// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tracker';

  @override
  String get tabDashboard => 'Übersicht';

  @override
  String get tabTasks => 'Termine';

  @override
  String get tabNotes => 'Notizen';

  @override
  String get tabHabits => 'Gewohnheiten';

  @override
  String get tabHousehold => 'Haushalt';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get dashboardPlaceholder => 'Die Übersichtsseite entsteht hier.';

  @override
  String get tasksPlaceholder =>
      'Plane und verwalte deine Termine und Aufgaben hier.';

  @override
  String get notesPlaceholder => 'Lege deine Notizen und Vorlagen hier an.';

  @override
  String get habitsPlaceholder =>
      'Verfolge deine Gewohnheiten auf dieser Seite.';

  @override
  String get householdPlaceholder =>
      'Verwalte Einnahmen und Ausgaben im Haushaltsbuch.';

  @override
  String get settingsPlaceholder =>
      'Passe deine persönlichen Einstellungen hier an.';
}
