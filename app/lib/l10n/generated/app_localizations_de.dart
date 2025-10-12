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
  String get navDashboard => 'Dashboard';

  @override
  String get navNotes => 'Notizen';

  @override
  String get navTasks => 'Aufgaben';

  @override
  String get navHabits => 'Gewohnheiten';

  @override
  String get navLedger => 'Haushaltsbuch';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navigationMenu => 'Navigation';

  @override
  String get navigationUserTooltip => 'Angemeldeter Benutzer';

  @override
  String get navLogout => 'Abmelden';

  @override
  String get navClearHistory => 'Lokale Historie löschen';

  @override
  String dashboardWelcome(String name) {
    return 'Willkommen im Dashboard, $name';
  }

  @override
  String dashboardSignedInAs(String email) {
    return 'Angemeldet als $email. Behalte deine Backend-Kommunikation im Blick und starte Aktionen direkt von hier.';
  }

  @override
  String get dashboardCardStoredResponses => 'Gespeicherte Antworten';

  @override
  String get dashboardCardLatestMessage => 'Letzte Nachricht';

  @override
  String get dashboardCardBackendUrl => 'Backend-URL';

  @override
  String get dashboardCardUser => 'Benutzer';

  @override
  String get dashboardCardStatus => 'Status';

  @override
  String get dashboardQuickActionTitle => 'Schnelle Aktion';

  @override
  String get dashboardQuickActionDescription =>
      'Hole eine neue Begrüßung vom Backend und speichere sie lokal.';

  @override
  String get dashboardQuickActionButton => 'Backend kontaktieren';

  @override
  String get dashboardQuickActionLoading => 'Wird geladen...';

  @override
  String get dashboardLatestEntriesTitle => 'Aktuelle Antworten';

  @override
  String get dashboardLatestEntriesEmpty =>
      'Es sind noch keine Antworten gespeichert.';

  @override
  String get statusNotContacted => 'Das Backend wurde noch nicht kontaktiert.';

  @override
  String statusSendingRequest(String url) {
    return 'Sende Anfrage an $url...';
  }

  @override
  String statusError(String description) {
    return 'Fehler: $description';
  }

  @override
  String get statusHistoryCleared => 'Alle lokalen Einträge wurden gelöscht.';

  @override
  String get communicationHeading => 'Basiskommunikation mit dem Backend';

  @override
  String communicationBackendUrl(String url) {
    return 'Aktuelle Backend-URL: $url';
  }

  @override
  String get communicationNameLabel => 'Name';

  @override
  String get communicationButton => 'Backend kontaktieren';

  @override
  String get notesPlaceholder =>
      'Hier werden demnächst deine Notizen erscheinen.';

  @override
  String get tasksPlaceholder => 'Plane und strukturiere hier deine Aufgaben.';

  @override
  String get habitsPlaceholder =>
      'Verfolge deine Gewohnheiten an dieser Stelle.';

  @override
  String get ledgerPlaceholder => 'Verwalte hier dein Haushaltsbudget.';

  @override
  String historySubtitle(String name, String source, String timestamp) {
    return 'Name: $name, Quelle: $source, Zeit: $timestamp';
  }

  @override
  String get historyEmpty =>
      'Es sind noch keine gespeicherten Antworten vorhanden.';

  @override
  String get loginTabSignIn => 'Anmelden';

  @override
  String get loginTabRegister => 'Registrieren';

  @override
  String get loginHeading =>
      'Melde dich mit deiner E-Mail-Adresse und deinem Passwort an.';

  @override
  String get loginEmailLabel => 'E-Mail-Adresse';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get loginGoogleButton => 'Mit Google anmelden (bald verfügbar)';

  @override
  String get registerHeading =>
      'Erstelle ein neues Konto mit E-Mail-Adresse und Passwort.';

  @override
  String get registerDisplayNameLabel => 'Anzeigename (optional)';

  @override
  String get registerPasswordLabel => 'Passwort (mind. 8 Zeichen)';

  @override
  String get registerButton => 'Konto erstellen';

  @override
  String get registerGoogleButton => 'Mit Google registrieren (bald verfügbar)';

  @override
  String get authErrorInvalidEmailPassword =>
      'Bitte gib eine gültige E-Mail-Adresse und ein Passwort mit mindestens 8 Zeichen an.';

  @override
  String get authErrorMissingCredentials =>
      'Bitte gib E-Mail-Adresse und Passwort ein.';

  @override
  String get authErrorEmailExists =>
      'Diese E-Mail-Adresse ist bereits registriert.';

  @override
  String authErrorGeneric(String description) {
    return 'Authentifizierungsfehler: $description';
  }

  @override
  String get authStatusSubmitting => 'Wird gesendet...';

  @override
  String get googlePlaceholder => 'Google Sign-In wird demnächst hinzugefügt.';

  @override
  String get errorBadRequest => 'Die Anfrage war nicht gültig.';

  @override
  String get errorUnauthorized => 'Ungültige Zugangsdaten.';

  @override
  String get errorConflict => 'Diese E-Mail-Adresse ist bereits registriert.';

  @override
  String errorUnexpectedStatus(int status) {
    return 'Unerwarteter Fehler (Status $status).';
  }

  @override
  String get settingsLanguageSectionTitle => 'Sprache';

  @override
  String get settingsLanguageDescription => 'Wähle die Sprache der App.';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageSwedish => 'Schwedisch';

  @override
  String get settingsLanguageApply => 'Sprache übernehmen';

  @override
  String settingsCurrentLanguage(String language) {
    return 'Aktuelle Sprache: $language';
  }
}
