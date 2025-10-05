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

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionAccountDescription =>
      'Sign in to unlock synchronization across your devices.';

  @override
  String get settingsAccountSignIn => 'Sign in';

  @override
  String get settingsAccountSignInDescription =>
      'Use email, Google, or Apple ID.';

  @override
  String get settingsAccountSecurity => 'Security';

  @override
  String get settingsAccountSecurityDescription =>
      'Review password and linked providers.';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionAppearanceDescription =>
      'Personalize how Tracker looks and feels.';

  @override
  String get settingsAppearanceTheme => 'Theme';

  @override
  String get settingsAppearanceThemeDescription =>
      'Choose system, light, or dark mode.';

  @override
  String get settingsAppearanceLanguage => 'Language';

  @override
  String get settingsAppearanceLanguageDescription =>
      'Switch between German, English, or Swedish.';

  @override
  String get settingsAppearanceAccent => 'Accent color';

  @override
  String get settingsAppearanceAccentDescription =>
      'Pick a color palette that matches your mood.';

  @override
  String get settingsSectionSync => 'Synchronization';

  @override
  String get settingsSectionSyncDescription =>
      'Control when data syncs with the backend service.';

  @override
  String get settingsSyncStatus => 'Enable synchronization';

  @override
  String get settingsSyncStatusDescription =>
      'Keep data up to date across devices when signed in.';

  @override
  String get settingsSyncAuto => 'Automatic backups';

  @override
  String get settingsSyncAutoDescription =>
      'Send changes in the background when connected to Wi‑Fi.';

  @override
  String get settingsSyncAutoDisabled =>
      'Activate synchronization to manage automatic backups.';

  @override
  String get settingsSectionSubscription => 'Subscription';

  @override
  String get settingsSectionSubscriptionDescription =>
      'Tracker Sync costs €1/month or €10/year after the trial.';

  @override
  String get settingsSubscriptionPlan => 'Manage plan';

  @override
  String get settingsSubscriptionPlanDescription =>
      'View your current tier and renewal date.';

  @override
  String get settingsSubscriptionPaymentMethods => 'Payment methods';

  @override
  String get settingsSubscriptionPaymentMethodsDescription =>
      'Pay with PayPal or Bitcoin.';

  @override
  String get settingsSectionPrivacy => 'Data & Privacy';

  @override
  String get settingsSectionPrivacyDescription =>
      'Export or delete your stored information.';

  @override
  String get settingsPrivacyExport => 'Export data';

  @override
  String get settingsPrivacyExportDescription =>
      'Download a copy of tasks, notes, and finances.';

  @override
  String get settingsPrivacyDelete => 'Delete account';

  @override
  String get settingsPrivacyDeleteDescription =>
      'Request removal of all synced data.';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageGerman => 'German';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSwedish => 'Swedish';

  @override
  String get settingsColorTeal => 'Ocean teal';

  @override
  String get settingsColorBlue => 'Sky blue';

  @override
  String get settingsColorAmber => 'Warm amber';

  @override
  String get settingsColorPurple => 'Berry purple';

  @override
  String get settingsColorForest => 'Forest green';

  @override
  String get settingsComingSoon => 'This option will arrive soon.';
}
