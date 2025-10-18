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
  String get navTimeTracking => 'Zeiterfassung';

  @override
  String get navJournal => 'Journal';

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
  String dashboardNotesCount(int count) {
    return 'Notizen insgesamt: $count';
  }

  @override
  String get dashboardNotesTopTags => 'Beliebteste Tags';

  @override
  String get dashboardNotesNoTags => 'Keine Tags vorhanden.';

  @override
  String get dashboardTasksSummaryTitle => 'Aufgabenüberblick';

  @override
  String dashboardTasksTotal(int count) {
    return 'Alle Aufgaben: $count';
  }

  @override
  String dashboardTasksInProgress(int count) {
    return 'In Bearbeitung: $count';
  }

  @override
  String dashboardTasksHighPriority(int count) {
    return 'Hohe Priorität: $count';
  }

  @override
  String dashboardTasksNextDue(String title, String date) {
    return 'Nächste fällige Aufgabe: $title (fällig am $date)';
  }

  @override
  String get dashboardTasksNoUpcoming => 'Keine anstehenden Aufgaben.';

  @override
  String get dashboardOpenTasksTooltip => 'Aufgaben öffnen';

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
  String get notesCreateButtonLabel => 'Neue Notiz';

  @override
  String get notesCreateMarkdown => 'Markdown-Notiz';

  @override
  String get notesCreateDrawing => 'Zeichnung';

  @override
  String get notesClearFiltersTooltip => 'Filter zurücksetzen';

  @override
  String get notesSearchHint => 'Notizen durchsuchen';

  @override
  String get notesSearchTagHint => 'Nach Tags filtern';

  @override
  String get notesTagFilterLabel => 'Tag-Filter';

  @override
  String get notesTagFilterAll => 'Alle Tags';

  @override
  String get notesTagSuggestionsLabel => 'Vorschläge';

  @override
  String get notesEmptyPlaceholder =>
      'Noch keine Notizen vorhanden. Lege deine erste Notiz an, um Ideen zu sammeln.';

  @override
  String get notesUntitled => 'Unbenannte Notiz';

  @override
  String get notesTitleLabel => 'Titel';

  @override
  String get notesTitleHint =>
      'Optionaler Titel (erste Zeile wird sonst verwendet)';

  @override
  String get notesTagLabel => 'Tags';

  @override
  String get notesTagHint => 'Tags, durch Kommas getrennt';

  @override
  String get notesMarkdownLabel => 'Markdown-Inhalt';

  @override
  String get notesMarkdownHint => 'Schreibe deine Notiz in Markdown.';

  @override
  String get notesMarkdownTabEdit => 'Markdown';

  @override
  String get notesMarkdownTabPreview => 'Vorschau';

  @override
  String get notesMarkdownPreviewEmpty => 'Noch nichts zum Anzeigen vorhanden.';

  @override
  String get notesMarkdownEmptyWarning =>
      'Bitte füge Inhalt hinzu, bevor du die Notiz speicherst.';

  @override
  String get notesEditorTitleNew => 'Neue Notiz';

  @override
  String get notesEditorTitleEdit => 'Notiz bearbeiten';

  @override
  String get notesEditorSave => 'Speichern';

  @override
  String get notesDeleteTooltip => 'Notiz löschen';

  @override
  String get notesDeleteDialogTitle => 'Notiz löschen?';

  @override
  String get notesDeleteDialogMessage =>
      'Diese Notiz wird auf diesem Gerät entfernt. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get notesDeleteDialogConfirm => 'Löschen';

  @override
  String get notesDrawingTitleNew => 'Neue Zeichnung';

  @override
  String get notesDrawingTitleEdit => 'Zeichnung bearbeiten';

  @override
  String get notesDrawingTitleHint => 'Optionaler Titel für diese Zeichnung';

  @override
  String get notesDrawingEmptyWarning =>
      'Füge mindestens einen Strich hinzu, bevor du speicherst.';

  @override
  String get notesDrawingUndo => 'Letzten Strich rückgängig';

  @override
  String get notesDrawingClear => 'Zeichenfläche leeren';

  @override
  String get notesDrawingHideDetails => 'Details ausblenden';

  @override
  String get notesDrawingShowDetails => 'Details einblenden';

  @override
  String get notesDrawingToolPen => 'Stift';

  @override
  String get notesDrawingToolEraser => 'Radiergummi';

  @override
  String get notesDrawingToolLine => 'Linie';

  @override
  String get notesDrawingToolRectangle => 'Rechteck';

  @override
  String get notesDrawingToolEllipse => 'Ellipse';

  @override
  String get notesDrawingStrokeLabel => 'Strichstärke';

  @override
  String get genericCancel => 'Abbrechen';

  @override
  String get tasksPlaceholder => 'Plane und strukturiere hier deine Aufgaben.';

  @override
  String get tasksTabList => 'Liste';

  @override
  String get tasksTabCalendar => 'Kalender';

  @override
  String get tasksCreateButton => 'Neue Aufgabe';

  @override
  String get tasksEmptyPlaceholder =>
      'Noch keine Aufgaben. Erstelle deine erste Aufgabe, um den Überblick zu behalten.';

  @override
  String get tasksCalendarEmpty => 'Für diesen Tag sind keine Aufgaben fällig.';

  @override
  String get tasksCreateTitle => 'Neue Aufgabe';

  @override
  String get tasksEditTitle => 'Aufgabe bearbeiten';

  @override
  String get tasksSaveButton => 'Speichern';

  @override
  String get tasksTitleLabel => 'Titel';

  @override
  String get tasksTitleHint => 'Was soll erledigt werden?';

  @override
  String get tasksTitleValidationError =>
      'Bitte gib einen Titel für die Aufgabe ein.';

  @override
  String get tasksStatusLabel => 'Status';

  @override
  String get tasksPriorityLabel => 'Priorität';

  @override
  String get tasksDueDateLabel => 'Fälligkeitsdatum';

  @override
  String get tasksDueDateHelper =>
      'Aufgaben werden im Kalender anhand ihres Fälligkeitsdatums angezeigt.';

  @override
  String get tasksPickDateButton => 'Datum wählen';

  @override
  String get tasksReminderToggleLabel => 'Erinnerung aktivieren';

  @override
  String get tasksReminderToggleDescription =>
      'Zeigt zum gewählten Zeitpunkt eine Gerätebenachrichtigung an.';

  @override
  String get tasksReminderScheduleLabel => 'Erinnerungszeit';

  @override
  String get tasksReminderScheduleHelper =>
      'Lege fest, wann das Gerät dich erinnern soll.';

  @override
  String get tasksReminderUnset => 'Noch keine Erinnerung festgelegt.';

  @override
  String get tasksReminderPickDateButton => 'Erinnerungsdatum wählen';

  @override
  String get tasksReminderPickTimeButton => 'Erinnerungszeit wählen';

  @override
  String get tasksReminderClearButton => 'Erinnerung entfernen';

  @override
  String get tasksReminderValidationMissing =>
      'Bitte wähle Datum und Uhrzeit für die Erinnerung.';

  @override
  String get tasksReminderValidationPast =>
      'Die Erinnerung muss in der Zukunft liegen.';

  @override
  String get tasksTagsLabel => 'Tags';

  @override
  String get tasksTagsHint => 'Tags, durch Kommas getrennt';

  @override
  String get tasksTagSuggestionsLabel => 'Vorschläge';

  @override
  String get tasksFiltersReset => 'Zurücksetzen';

  @override
  String get tasksShowFiltersTooltip => 'Filter einblenden';

  @override
  String get tasksHideFiltersTooltip => 'Filter ausblenden';

  @override
  String get tasksSortLabel => 'Sortieren nach';

  @override
  String get tasksSortDueDateAsc => 'Fälligkeit ↑';

  @override
  String get tasksSortDueDateDesc => 'Fälligkeit ↓';

  @override
  String get tasksSortPriority => 'Priorität';

  @override
  String get tasksSortStatus => 'Status';

  @override
  String get tasksLinkedNoteLabel => 'Verknüpfte Notiz';

  @override
  String get tasksNoNoteLinked => 'Noch keine Notiz verknüpft.';

  @override
  String get tasksRemoveNoteTooltip => 'Verknüpfte Notiz entfernen';

  @override
  String get tasksSelectNoteButton => 'Bestehende Notiz verknüpfen';

  @override
  String get tasksCreateNoteButton => 'Neue Notiz erstellen';

  @override
  String get tasksCreateMarkdownNote => 'Markdown-Notiz erstellen';

  @override
  String get tasksCreateDrawingNote => 'Zeichnungsnotiz erstellen';

  @override
  String get tasksNoNotesFound => 'Es sind noch keine Notizen vorhanden.';

  @override
  String get tasksOpenLinkedNoteButton => 'Notiz öffnen';

  @override
  String get tasksTrackedTimePlaceholder =>
      'Sobald die Zeiterfassung verbunden ist, erscheinen hier die erfassten Zeiten.';

  @override
  String get tasksReminderNotificationGenericTitle => 'Aufgaben-Erinnerung';

  @override
  String tasksReminderNotificationBody(String date, String time) {
    return 'Erinnerung für $date um $time.';
  }

  @override
  String tasksDueDateLabelValue(String date) {
    return 'Fällig: $date';
  }

  @override
  String tasksReminderLabelValue(String date, String time) {
    return 'Erinnerung: $date um $time';
  }

  @override
  String get tasksStatusTodo => 'Offen';

  @override
  String get tasksStatusInProgress => 'In Arbeit';

  @override
  String get tasksStatusDone => 'Erledigt';

  @override
  String get tasksPriorityLow => 'Niedrige Priorität';

  @override
  String get tasksPriorityMedium => 'Mittlere Priorität';

  @override
  String get tasksPriorityHigh => 'Hohe Priorität';

  @override
  String get tasksPreviewOpenEditor => 'Im Editor öffnen';

  @override
  String get timeTrackingPlaceholder =>
      'Erfasse deine Arbeitszeiten bald direkt hier und verknüpfe sie über gemeinsame Tags mit den Aufgaben.';

  @override
  String get journalPlaceholder =>
      'Halte deine Einträge hier fest und verbinde sie über Tags mit Notizen, Aufgaben und der Zeiterfassung.';

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

  @override
  String get settingsAppearanceSectionTitle => 'Darstellung';

  @override
  String get settingsThemeModeLabel => 'Designmodus';

  @override
  String get settingsThemeModeSystem => 'Systemstandard';

  @override
  String get settingsThemeModeLight => 'Hell';

  @override
  String get settingsThemeModeDark => 'Dunkel';

  @override
  String get settingsSeedColorLabel => 'Akzentfarbe';

  @override
  String get settingsSeedColorDescription => 'Wähle die Akzentfarbe der App.';

  @override
  String get settingsModulesSectionTitle => 'Module';

  @override
  String get settingsModulesDescription =>
      'Lege fest, welche Module im Menü sichtbar sind.';

  @override
  String get settingsModulesDragHint =>
      'Ziehe am Griff, um die Reihenfolge zu ändern.';

  @override
  String get settingsSyncInfoTitle => 'Verschlüsselte Synchronisierung';

  @override
  String get settingsSyncInfoDescription =>
      'Melde dich nur an, wenn du deine Daten mit dem Backend synchronisieren möchtest. Ohne Anmeldung bleiben alle Daten auf diesem Gerät.';

  @override
  String get settingsSyncMembershipInfo =>
      'Die Synchronisierung wird freigeschaltet, sobald eine Mitgliedschaft aktiv ist.';

  @override
  String get guestUserName => 'Gast';

  @override
  String get guestUserEmail => 'Lokales Gerät';

  @override
  String get dashboardStatusGuest =>
      'Synchronisation steht erst nach Anmeldung zur Verfügung.';

  @override
  String get dashboardGuestIntro =>
      'Nutze die App offline oder melde dich an, um Synchronisation und Mitgliedschaften freizuschalten.';

  @override
  String get dashboardGuestSyncTitle => 'Synchronisierung freischalten';

  @override
  String get dashboardGuestSyncDescription =>
      'Erstelle ein kostenloses Konto, um nach Abschluss einer Mitgliedschaft die verschlüsselte Synchronisierung zu aktivieren.';

  @override
  String get dashboardGuestSyncButton => 'Zu den Einstellungen';

  @override
  String get membershipSectionTitle => 'Mitgliedschaft';

  @override
  String get membershipStatusUnknown => 'Mitgliedschaftsstatus unbekannt.';

  @override
  String membershipStatusActive(String date) {
    return 'Mitgliedschaft aktiv bis $date.';
  }

  @override
  String membershipStatusActiveShort(String date) {
    return 'Aktiv bis $date';
  }

  @override
  String get membershipStatusInactive => 'Keine aktive Mitgliedschaft.';

  @override
  String get membershipSyncEnabled => 'Synchronisierung ist aktiviert.';

  @override
  String get membershipSyncDisabled => 'Synchronisierung ist deaktiviert.';

  @override
  String membershipLastPayment(String method) {
    return 'Letzte Zahlung über $method.';
  }

  @override
  String membershipRetentionInfo(String date) {
    return 'Synchronisierte Daten werden bis $date aufbewahrt.';
  }

  @override
  String get membershipActionsTitle => 'Tarif auswählen';

  @override
  String membershipSubscribeMonthly(String price) {
    return 'Monatliche Mitgliedschaft ($price)';
  }

  @override
  String membershipSubscribeYearly(String price) {
    return 'Jährliche Mitgliedschaft ($price)';
  }

  @override
  String get membershipPayWithPaypal => 'Mit PayPal bezahlen';

  @override
  String get membershipPayWithBitcoin => 'Mit Bitcoin bezahlen';

  @override
  String get membershipCancelButton => 'Mitgliedschaft kündigen';

  @override
  String get membershipDeleteDataButton =>
      'Synchronisierte Daten jetzt löschen';

  @override
  String get membershipSubscribeSuccess => 'Mitgliedschaft wurde aktualisiert.';

  @override
  String get membershipCancelSuccess => 'Mitgliedschaft wurde beendet.';

  @override
  String get membershipDeleteSuccess =>
      'Synchronisierte Daten wurden gelöscht.';

  @override
  String get membershipPlanMonthlyLabel => 'Monatliche Mitgliedschaft';

  @override
  String get membershipPlanYearlyLabel => 'Jährliche Mitgliedschaft';

  @override
  String get membershipPlanNoneLabel => 'Keine Mitgliedschaft';

  @override
  String get membershipPaymentMethodPaypal => 'PayPal';

  @override
  String get membershipPaymentMethodBitcoin => 'Bitcoin';

  @override
  String get settingsSignInPrompt =>
      'Melde dich an, um deine Daten zwischen Geräten zu synchronisieren.';

  @override
  String get settingsOpenLogin => 'Login öffnen';

  @override
  String get syncNowButton => 'Jetzt synchronisieren';

  @override
  String get syncInProgress => 'Synchronisiere …';

  @override
  String get syncSuccess => 'Synchronisation abgeschlossen.';

  @override
  String get syncNotReady => 'Bitte melde dich an, bevor du synchronisierst.';

  @override
  String get syncConflictTitle => 'Synchronisationskonflikt';

  @override
  String get syncConflictMessage =>
      'Wähle, welche Version behalten werden soll.';

  @override
  String get syncConflictKeepLocal => 'Geräteversion behalten';

  @override
  String get syncConflictKeepServer => 'Serverversion übernehmen';

  @override
  String get syncConflictResolved => 'Konflikte wurden gelöst.';

  @override
  String get syncConflictDeviceLabel => 'Gerät';

  @override
  String get syncConflictServerLabel => 'Server';
}
