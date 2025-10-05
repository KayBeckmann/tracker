import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get appTitle;

  /// No description provided for @tabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabDashboard;

  /// No description provided for @tabTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tabTasks;

  /// No description provided for @tabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// No description provided for @tabHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get tabHabits;

  /// No description provided for @tabHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get tabHousehold;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @dashboardPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Dashboard overview coming soon.'**
  String get dashboardPlaceholder;

  /// No description provided for @tasksPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Plan and review your tasks here.'**
  String get tasksPlaceholder;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Create and organize notes here.'**
  String get notesPlaceholder;

  /// No description provided for @habitsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Track habits from this screen.'**
  String get habitsPlaceholder;

  /// No description provided for @householdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Manage household finances here.'**
  String get householdPlaceholder;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Configure your preferences here.'**
  String get settingsPlaceholder;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to unlock synchronization across your devices.'**
  String get settingsSectionAccountDescription;

  /// No description provided for @settingsAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get settingsAccountSignIn;

  /// No description provided for @settingsAccountSignInDescription.
  ///
  /// In en, this message translates to:
  /// **'Use email, Google, or Apple ID.'**
  String get settingsAccountSignInDescription;

  /// No description provided for @settingsAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsAccountSecurity;

  /// No description provided for @settingsAccountSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Review password and linked providers.'**
  String get settingsAccountSecurityDescription;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionAppearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalize how Tracker looks and feels.'**
  String get settingsSectionAppearanceDescription;

  /// No description provided for @settingsAppearanceTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsAppearanceTheme;

  /// No description provided for @settingsAppearanceThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose system, light, or dark mode.'**
  String get settingsAppearanceThemeDescription;

  /// No description provided for @settingsAppearanceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsAppearanceLanguage;

  /// No description provided for @settingsAppearanceLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch between German, English, or Swedish.'**
  String get settingsAppearanceLanguageDescription;

  /// No description provided for @settingsAppearanceAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settingsAppearanceAccent;

  /// No description provided for @settingsAppearanceAccentDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a color palette that matches your mood.'**
  String get settingsAppearanceAccentDescription;

  /// No description provided for @settingsSectionSync.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get settingsSectionSync;

  /// No description provided for @settingsSectionSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Control when data syncs with the backend service.'**
  String get settingsSectionSyncDescription;

  /// No description provided for @settingsSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Enable synchronization'**
  String get settingsSyncStatus;

  /// No description provided for @settingsSyncStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep data up to date across devices when signed in.'**
  String get settingsSyncStatusDescription;

  /// No description provided for @settingsSyncAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get settingsSyncAuto;

  /// No description provided for @settingsSyncAutoDescription.
  ///
  /// In en, this message translates to:
  /// **'Send changes in the background when connected to Wi‑Fi.'**
  String get settingsSyncAutoDescription;

  /// No description provided for @settingsSyncAutoDisabled.
  ///
  /// In en, this message translates to:
  /// **'Activate synchronization to manage automatic backups.'**
  String get settingsSyncAutoDisabled;

  /// No description provided for @settingsSectionSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsSectionSubscription;

  /// No description provided for @settingsSectionSubscriptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Tracker Sync costs €1/month or €10/year after the trial.'**
  String get settingsSectionSubscriptionDescription;

  /// No description provided for @settingsSubscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Manage plan'**
  String get settingsSubscriptionPlan;

  /// No description provided for @settingsSubscriptionPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'View your current tier and renewal date.'**
  String get settingsSubscriptionPlanDescription;

  /// No description provided for @settingsSubscriptionPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get settingsSubscriptionPaymentMethods;

  /// No description provided for @settingsSubscriptionPaymentMethodsDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay with PayPal or Bitcoin.'**
  String get settingsSubscriptionPaymentMethodsDescription;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsSectionPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Export or delete your stored information.'**
  String get settingsSectionPrivacyDescription;

  /// No description provided for @settingsPrivacyExport.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsPrivacyExport;

  /// No description provided for @settingsPrivacyExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Download a copy of tasks, notes, and finances.'**
  String get settingsPrivacyExportDescription;

  /// No description provided for @settingsPrivacyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsPrivacyDelete;

  /// No description provided for @settingsPrivacyDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Request removal of all synced data.'**
  String get settingsPrivacyDeleteDescription;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get settingsLanguageSwedish;

  /// No description provided for @settingsColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Ocean teal'**
  String get settingsColorTeal;

  /// No description provided for @settingsColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Sky blue'**
  String get settingsColorBlue;

  /// No description provided for @settingsColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Warm amber'**
  String get settingsColorAmber;

  /// No description provided for @settingsColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Berry purple'**
  String get settingsColorPurple;

  /// No description provided for @settingsColorForest.
  ///
  /// In en, this message translates to:
  /// **'Forest green'**
  String get settingsColorForest;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This option will arrive soon.'**
  String get settingsComingSoon;

  /// No description provided for @settingsAccountSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your account'**
  String get settingsAccountSignInTitle;

  /// No description provided for @settingsAccountSignInLongDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to unlock secure backups and synchronization across devices.'**
  String get settingsAccountSignInLongDescription;

  /// No description provided for @settingsAccountSignInOptionEmail.
  ///
  /// In en, this message translates to:
  /// **'Email & password'**
  String get settingsAccountSignInOptionEmail;

  /// No description provided for @settingsAccountSignInOptionGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google account'**
  String get settingsAccountSignInOptionGoogle;

  /// No description provided for @settingsAccountSignInOptionApple.
  ///
  /// In en, this message translates to:
  /// **'Apple ID'**
  String get settingsAccountSignInOptionApple;

  /// No description provided for @settingsAccountSignInOptionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Available soon'**
  String get settingsAccountSignInOptionComingSoon;

  /// No description provided for @settingsAccountSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Start sign-in flow'**
  String get settingsAccountSignInButton;

  /// No description provided for @settingsAccountPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsAccountPasswordLabel;

  /// No description provided for @settingsAccountPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get settingsAccountPasswordConfirmLabel;

  /// No description provided for @settingsAccountRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get settingsAccountRegisterButton;

  /// No description provided for @settingsAccountLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get settingsAccountLoginButton;

  /// No description provided for @settingsAccountValidationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password.'**
  String get settingsAccountValidationEmpty;

  /// No description provided for @settingsAccountValidationMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get settingsAccountValidationMismatch;

  /// No description provided for @settingsAccountUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get settingsAccountUnknownError;

  /// No description provided for @settingsAccountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security & providers'**
  String get settingsAccountSecurityTitle;

  /// No description provided for @settingsAccountSecurityManageProviders.
  ///
  /// In en, this message translates to:
  /// **'Manage linked providers'**
  String get settingsAccountSecurityManageProviders;

  /// No description provided for @settingsSubscriptionPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker Sync subscription'**
  String get settingsSubscriptionPlanTitle;

  /// No description provided for @settingsSubscriptionPlanPricing.
  ///
  /// In en, this message translates to:
  /// **'€1 / month • €10 / year'**
  String get settingsSubscriptionPlanPricing;

  /// No description provided for @settingsSubscriptionPlanBenefits.
  ///
  /// In en, this message translates to:
  /// **'Your benefits'**
  String get settingsSubscriptionPlanBenefits;

  /// No description provided for @settingsSubscriptionBenefitSync.
  ///
  /// In en, this message translates to:
  /// **'Unlimited data synchronization across all devices'**
  String get settingsSubscriptionBenefitSync;

  /// No description provided for @settingsSubscriptionBenefitBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic encrypted backups'**
  String get settingsSubscriptionBenefitBackup;

  /// No description provided for @settingsSubscriptionBenefitSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support for subscribers'**
  String get settingsSubscriptionBenefitSupport;

  /// No description provided for @settingsSubscriptionPlanButton.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsSubscriptionPlanButton;

  /// No description provided for @settingsPaymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get settingsPaymentMethodsTitle;

  /// No description provided for @settingsPaymentMethodsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select which payment options you want to use for renewals.'**
  String get settingsPaymentMethodsDescription;

  /// No description provided for @settingsPaymentMethodsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage payment methods'**
  String get settingsPaymentMethodsManage;

  /// No description provided for @settingsPaymentMethodsPaypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get settingsPaymentMethodsPaypal;

  /// No description provided for @settingsPaymentMethodsBitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get settingsPaymentMethodsBitcoin;

  /// No description provided for @settingsPrivacyExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export your data'**
  String get settingsPrivacyExportTitle;

  /// No description provided for @settingsPrivacyExportDescriptionLong.
  ///
  /// In en, this message translates to:
  /// **'Download all synced entries as a secure archive. We\'ll notify you when the export is ready.'**
  String get settingsPrivacyExportDescriptionLong;

  /// No description provided for @settingsPrivacyExportButton.
  ///
  /// In en, this message translates to:
  /// **'Request export'**
  String get settingsPrivacyExportButton;

  /// No description provided for @settingsPrivacyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete synced data'**
  String get settingsPrivacyDeleteTitle;

  /// No description provided for @settingsPrivacyDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account removes all synchronized information.'**
  String get settingsPrivacyDeleteWarning;

  /// No description provided for @settingsPrivacyDeleteDescriptionLong.
  ///
  /// In en, this message translates to:
  /// **'This action keeps local data on your device but erases notes, tasks, and backups from the server.'**
  String get settingsPrivacyDeleteDescriptionLong;

  /// No description provided for @settingsPrivacyDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Request deletion'**
  String get settingsPrivacyDeleteButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
