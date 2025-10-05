// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tracker';

  @override
  String get tabDashboard => 'Dashboard';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabNotes => 'Notes';

  @override
  String get tabHabits => 'Habits';

  @override
  String get tabHousehold => 'Household';

  @override
  String get tabSettings => 'Settings';

  @override
  String get dashboardPlaceholder => 'Dashboard overview coming soon.';

  @override
  String get tasksPlaceholder => 'Plan and review your tasks here.';

  @override
  String get notesPlaceholder => 'Create and organize notes here.';

  @override
  String get habitsPlaceholder => 'Track habits from this screen.';

  @override
  String get householdPlaceholder => 'Manage household finances here.';

  @override
  String get settingsPlaceholder => 'Configure your preferences here.';
}
