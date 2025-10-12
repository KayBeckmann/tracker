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
  String get navDashboard => 'Instrumentpanel';

  @override
  String get navNotes => 'Anteckningar';

  @override
  String get navTasks => 'Uppgifter';

  @override
  String get navHabits => 'Vanor';

  @override
  String get navLedger => 'Hushållsbok';

  @override
  String get navSettings => 'Inställningar';

  @override
  String get navigationMenu => 'Navigering';

  @override
  String get navigationUserTooltip => 'Inloggad användare';

  @override
  String get navLogout => 'Logga ut';

  @override
  String get navClearHistory => 'Rensa lokal historik';

  @override
  String dashboardWelcome(String name) {
    return 'Välkommen till instrumentpanelen, $name';
  }

  @override
  String dashboardSignedInAs(String email) {
    return 'Inloggad som $email. Följ din backend-kommunikation och starta åtgärder direkt härifrån.';
  }

  @override
  String get dashboardCardStoredResponses => 'Sparade svar';

  @override
  String get dashboardCardLatestMessage => 'Senaste meddelande';

  @override
  String get dashboardCardBackendUrl => 'Backend-URL';

  @override
  String get dashboardCardUser => 'Användare';

  @override
  String get dashboardCardStatus => 'Status';

  @override
  String get dashboardQuickActionTitle => 'Snabb åtgärd';

  @override
  String get dashboardQuickActionDescription =>
      'Hämta en ny hälsning från backend och spara den lokalt.';

  @override
  String get dashboardQuickActionButton => 'Kontakta backend';

  @override
  String get dashboardQuickActionLoading => 'Laddar...';

  @override
  String get dashboardLatestEntriesTitle => 'Senaste svar';

  @override
  String get dashboardLatestEntriesEmpty => 'Inga svar har sparats ännu.';

  @override
  String get statusNotContacted => 'Backend har ännu inte kontaktats.';

  @override
  String statusSendingRequest(String url) {
    return 'Skickar förfrågan till $url...';
  }

  @override
  String statusError(String description) {
    return 'Fel: $description';
  }

  @override
  String get statusHistoryCleared => 'Alla lokala poster har raderats.';

  @override
  String get communicationHeading => 'Grundläggande kommunikation med backend';

  @override
  String communicationBackendUrl(String url) {
    return 'Aktuell backend-URL: $url';
  }

  @override
  String get communicationNameLabel => 'Namn';

  @override
  String get communicationButton => 'Kontakta backend';

  @override
  String get notesPlaceholder => 'Dina anteckningar visas här snart.';

  @override
  String get tasksPlaceholder => 'Organisera kommande uppgifter här.';

  @override
  String get habitsPlaceholder => 'Följ dina vanor här.';

  @override
  String get ledgerPlaceholder => 'Hantera hushållsbudgeten här.';

  @override
  String historySubtitle(String name, String source, String timestamp) {
    return 'Namn: $name, Källa: $source, Tid: $timestamp';
  }

  @override
  String get historyEmpty => 'Inga sparade svar ännu.';

  @override
  String get loginTabSignIn => 'Logga in';

  @override
  String get loginTabRegister => 'Registrera';

  @override
  String get loginHeading => 'Logga in med din e-postadress och ditt lösenord.';

  @override
  String get loginEmailLabel => 'E-postadress';

  @override
  String get loginPasswordLabel => 'Lösenord';

  @override
  String get loginButton => 'Logga in';

  @override
  String get loginGoogleButton => 'Logga in med Google (kommer snart)';

  @override
  String get registerHeading =>
      'Skapa ett nytt konto med e-postadress och lösenord.';

  @override
  String get registerDisplayNameLabel => 'Visningsnamn (valfritt)';

  @override
  String get registerPasswordLabel => 'Lösenord (minst 8 tecken)';

  @override
  String get registerButton => 'Skapa konto';

  @override
  String get registerGoogleButton => 'Registrera med Google (kommer snart)';

  @override
  String get authErrorInvalidEmailPassword =>
      'Ange en giltig e-postadress och ett lösenord med minst 8 tecken.';

  @override
  String get authErrorMissingCredentials => 'Ange e-postadress och lösenord.';

  @override
  String get authErrorEmailExists =>
      'Den här e-postadressen är redan registrerad.';

  @override
  String authErrorGeneric(String description) {
    return 'Autentiseringsfel: $description';
  }

  @override
  String get authStatusSubmitting => 'Skickar...';

  @override
  String get googlePlaceholder => 'Google-inloggning läggs till snart.';

  @override
  String get errorBadRequest => 'Förfrågan var inte giltig.';

  @override
  String get errorUnauthorized => 'Ogiltiga inloggningsuppgifter.';

  @override
  String get errorConflict => 'Den här e-postadressen är redan registrerad.';

  @override
  String errorUnexpectedStatus(int status) {
    return 'Oväntat fel (status $status).';
  }

  @override
  String get settingsLanguageSectionTitle => 'Språk';

  @override
  String get settingsLanguageDescription =>
      'Välj vilket språk appen ska använda.';

  @override
  String get settingsLanguageEnglish => 'Engelska';

  @override
  String get settingsLanguageGerman => 'Tyska';

  @override
  String get settingsLanguageSwedish => 'Svenska';

  @override
  String get settingsLanguageApply => 'Använd språk';

  @override
  String settingsCurrentLanguage(String language) {
    return 'Aktuellt språk: $language';
  }
}
