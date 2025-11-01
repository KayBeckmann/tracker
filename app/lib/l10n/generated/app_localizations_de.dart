// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Personal Tracker';

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
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonCreate => 'Erstellen';

  @override
  String get commonEdit => 'Bearbeiten';

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
  String get notesTabActive => 'Notizen';

  @override
  String get notesTabArchive => 'Archiv';

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
  String get notesArchiveEmpty => 'Keine archivierten Notizen.';

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
  String get notesArchiveTooltip => 'Notiz archivieren';

  @override
  String get notesUnarchiveTooltip => 'Notiz wiederherstellen';

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
  String get tasksTabArchive => 'Archiv';

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
  String get tasksArchiveTooltip => 'In Archiv verschieben';

  @override
  String get tasksUnarchiveTooltip => 'Aus Archiv wiederherstellen';

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
  String get tasksTrackedTimeEmpty => 'Noch keine Zeiten verknüpft.';

  @override
  String tasksTrackedTimeTotal(String duration) {
    return 'Erfasste Arbeitszeit: $duration';
  }

  @override
  String tasksTrackedTimeMore(int count) {
    return '$count weitere Buchungen';
  }

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
  String get timeTrackingSettingsTitle => 'Zeiterfassung';

  @override
  String get timeTrackingSettingsRoundingLabel => 'Rundungsintervall';

  @override
  String get timeTrackingRoundingMinute => 'Minutengenau';

  @override
  String get timeTrackingRoundingFive => '5-Minuten-Schritte';

  @override
  String get timeTrackingRoundingTen => '10-Minuten-Schritte';

  @override
  String get timeTrackingRoundingQuarter => 'Viertelstundenschritte';

  @override
  String get timeTrackingSettingsTargetLabel => 'Sollstunden';

  @override
  String get timeTrackingSettingsTargetNone => 'Kein Ziel';

  @override
  String get timeTrackingSettingsTargetDaily => 'Tagesziel';

  @override
  String get timeTrackingSettingsTargetWeekly => 'Wochenziel';

  @override
  String get timeTrackingSettingsDailyHoursLabel => 'Soll pro Tag (HH:MM)';

  @override
  String get timeTrackingSettingsWeeklyHoursLabel => 'Soll pro Woche (HH:MM)';

  @override
  String get timeTrackingSettingsDurationHint =>
      'Verwende das Format HH:MM, z. B. 08:00 oder 37:30.';

  @override
  String get timeTrackingSettingsInvalidDuration =>
      'Bitte gib eine gültige Dauer im Format HH:MM ein.';

  @override
  String timeTrackingSummaryDay(String date, String duration) {
    return 'Ausgewählter Tag: $date • Arbeit: $duration';
  }

  @override
  String timeTrackingSummaryAllEntries(String duration) {
    return 'Alle Einträge: $duration';
  }

  @override
  String timeTrackingSummaryWeek(String start, String end, String duration) {
    return 'Woche $start – $end: $duration';
  }

  @override
  String timeTrackingSummaryDelta(String delta) {
    return 'Delta: $delta';
  }

  @override
  String get timeTrackingCalendarPrevious => 'Vorheriger Monat';

  @override
  String get timeTrackingCalendarNext => 'Nächster Monat';

  @override
  String get timeTrackingStartNowButton => 'Jetzt einstempeln';

  @override
  String get timeTrackingStopNowButton => 'Jetzt ausstempeln';

  @override
  String get timeTrackingAddManualButton => 'Zeit nachtragen';

  @override
  String get timeTrackingNoEntriesForDay =>
      'Keine Einträge für den ausgewählten Tag.';

  @override
  String get timeTrackingManualEntrySaved => 'Zeiteintrag gespeichert.';

  @override
  String get timeTrackingDeleteEntryTitle => 'Zeiteintrag löschen';

  @override
  String get timeTrackingDeleteEntryMessage =>
      'Möchtest du diesen Zeiteintrag löschen?';

  @override
  String get timeTrackingDeleteEntryConfirm => 'Löschen';

  @override
  String get timeTrackingEntryDeleted => 'Zeiteintrag gelöscht.';

  @override
  String get timeTrackingKindWork => 'Arbeit';

  @override
  String get timeTrackingKindVacation => 'Urlaub';

  @override
  String get timeTrackingKindDayOff => 'Freier Tag';

  @override
  String get timeTrackingKindSick => 'Krankheit';

  @override
  String timeTrackingEntryInterval(String start, String end, String duration) {
    return '$start – $end • $duration';
  }

  @override
  String timeTrackingEntryRunning(String start, String duration) {
    return '$start • Laufend ($duration)';
  }

  @override
  String timeTrackingLinkedTask(String title) {
    return 'Verknüpfte Aufgabe: $title';
  }

  @override
  String get timeTrackingEditEntryTooltip => 'Eintrag bearbeiten';

  @override
  String get timeTrackingDeleteEntryTooltip => 'Eintrag löschen';

  @override
  String get timeTrackingFormTitle => 'Zeiteintrag';

  @override
  String get timeTrackingFormStartLabel => 'Start';

  @override
  String get timeTrackingFormEndLabel => 'Ende';

  @override
  String timeTrackingFormDurationLabel(String value) {
    return 'Dauer: $value';
  }

  @override
  String get timeTrackingFormKindLabel => 'Art';

  @override
  String get timeTrackingFormTaskLabel => 'Verknüpfte Aufgabe';

  @override
  String get timeTrackingFormNoTask => 'Keine Aufgabe';

  @override
  String get timeTrackingFormNoteLabel => 'Notiz';

  @override
  String get timeTrackingFormCancel => 'Abbrechen';

  @override
  String get timeTrackingFormSave => 'Speichern';

  @override
  String get timeTrackingFormInvalidDuration =>
      'Bitte ein Ende nach dem Start auswählen.';

  @override
  String get timeTrackingDashboardTitle => 'Zeiterfassung';

  @override
  String timeTrackingDashboardToday(String duration) {
    return 'Heute: $duration';
  }

  @override
  String timeTrackingDashboardWeek(String start, String end, String duration) {
    return 'Woche $start – $end: $duration';
  }

  @override
  String timeTrackingDashboardDeltaDaily(String value) {
    return 'Tages-Delta: $value';
  }

  @override
  String timeTrackingDashboardDeltaWeekly(String value) {
    return 'Wochen-Delta: $value';
  }

  @override
  String get timeTrackingDashboardNoTarget => 'Kein Ziel hinterlegt.';

  @override
  String get timeTrackingDashboardOpenModule => 'Zeiterfassung öffnen';

  @override
  String get timeTrackingAlreadyRunning => 'Eine Erfassung läuft bereits.';

  @override
  String get timeTrackingClockInSuccess => 'Erfassung gestartet.';

  @override
  String get timeTrackingNoActiveEntry => 'Keine laufende Erfassung.';

  @override
  String timeTrackingClockOutSuccess(String duration) {
    return 'Erfassung beendet ($duration).';
  }

  @override
  String get journalPlaceholder =>
      'Halte deine Einträge hier fest und verbinde sie über Tags mit Notizen, Aufgaben und der Zeiterfassung.';

  @override
  String get journalUnsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get journalUnsavedChangesMessage =>
      'Du hast ungespeicherte Änderungen für diesen Tag. Wie möchtest du fortfahren?';

  @override
  String get journalDiscardChanges => 'Verwerfen';

  @override
  String get journalEntrySaved => 'Tagebucheintrag gespeichert.';

  @override
  String get journalEntrySaveError =>
      'Der Eintrag konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get journalDeleteEntryTitle => 'Eintrag löschen';

  @override
  String get journalDeleteEntryMessage =>
      'Den Tagebucheintrag für diesen Tag löschen?';

  @override
  String get journalEntryDeleted => 'Tagebucheintrag gelöscht.';

  @override
  String get journalApplyTemplateTitle => 'Tagesvorlage übernehmen';

  @override
  String get journalApplyTemplateMessage =>
      'Den aktuellen Inhalt durch deine Tagesvorlage ersetzen?';

  @override
  String get journalApplyTemplateButton => 'Vorlage anwenden';

  @override
  String get journalNoEntryForDay =>
      'Für diesen Tag gibt es noch keinen Eintrag.';

  @override
  String journalLastUpdated(String timestamp) {
    return 'Zuletzt aktualisiert am $timestamp';
  }

  @override
  String get journalTabEdit => 'Bearbeiten';

  @override
  String get journalTabPreview => 'Vorschau';

  @override
  String get journalEditorHint =>
      'Schreibe deinen Eintrag mit Markdown-Formatierung.';

  @override
  String get journalPreviewEmpty => 'Noch nichts zum Anzeigen vorhanden.';

  @override
  String get journalTrendsTitle => 'Aktuelle Verläufe';

  @override
  String get journalTrendsDescription => 'Tracker-Werte der letzten 30 Tage.';

  @override
  String get journalTrendsEmpty => 'Füge Tracker hinzu, um Verläufe zu sehen.';

  @override
  String journalTrendDateRange(String start, String end) {
    return '$start - $end';
  }

  @override
  String get journalTrendNoData => 'Noch keine Einträge.';

  @override
  String get journalTrendLegendCheckbox => '0 = nein, 1 = ja';

  @override
  String get journalTrendLegendRating => 'Bereich 0-5';

  @override
  String get journalDashboardEntryDone =>
      'Für heute ist bereits ein Eintrag vorhanden.';

  @override
  String get journalDashboardEntryMissing =>
      'Heute wurde noch nichts eingetragen.';

  @override
  String get journalDashboardLocked =>
      'Entsperre das Journal, um den heutigen Status zu sehen.';

  @override
  String get journalDashboardOpenButton => 'Journal öffnen';

  @override
  String get journalTrackersSectionTitle => 'Tracker';

  @override
  String get journalAddTrackerButton => 'Tracker hinzufügen';

  @override
  String get journalTrackersEmpty =>
      'Es sind noch keine Tracker vorhanden. Lege einen an, um Routinen zu verfolgen.';

  @override
  String get journalAddTrackerTitle => 'Tracker hinzufügen';

  @override
  String get journalEditTrackerTitle => 'Tracker bearbeiten';

  @override
  String get journalDeleteTrackerTitle => 'Tracker löschen';

  @override
  String journalDeleteTrackerMessage(String name) {
    return 'Den Tracker \"$name\" und alle Werte löschen?';
  }

  @override
  String get journalTrackerNameLabel => 'Name';

  @override
  String get journalTrackerNameError => 'Bitte gib einen Namen ein.';

  @override
  String get journalTrackerKindLabel => 'Trackertyp';

  @override
  String get journalTrackerKindCheckbox => 'Ja / Nein';

  @override
  String get journalTrackerKindRating => 'Bewertung (0-5)';

  @override
  String get journalTrackerDescriptionLabel => 'Beschreibung (optional)';

  @override
  String journalTrackerRatingTooltip(int rating) {
    return 'Bewertung auf $rating Sterne setzen';
  }

  @override
  String get journalTrackerClearTooltip => 'Wert löschen';

  @override
  String get journalCalendarPrevious => 'Vorheriger Monat';

  @override
  String get journalCalendarNext => 'Nächster Monat';

  @override
  String get journalLockTooltip => 'Journal sperren';

  @override
  String get journalLockedTitle => 'Journal gesperrt';

  @override
  String get journalLockedMessage =>
      'Entsperre das Journal mit deiner PIN oder Biometrie, um die Einträge zu sehen.';

  @override
  String get journalPinLabel => 'PIN';

  @override
  String get journalUnlockWithPin => 'Mit PIN entsperren';

  @override
  String get journalUnlockWithBiometrics => 'Biometrie verwenden';

  @override
  String get journalPinRequired => 'Bitte gib deine PIN ein.';

  @override
  String get journalUnlockSuccess => 'Journal entsperrt.';

  @override
  String get journalUnlockFailed => 'Falsche PIN. Bitte erneut versuchen.';

  @override
  String get journalNoProtectionConfigured =>
      'Für das Journal ist kein Schutz konfiguriert.';

  @override
  String get journalBiometricUnavailable =>
      'Biometrische Authentifizierung ist auf diesem Gerät nicht verfügbar.';

  @override
  String get journalBiometricPrompt =>
      'Authentifiziere dich, um das Journal zu entsperren.';

  @override
  String get journalBiometricError =>
      'Biometrische Authentifizierung fehlgeschlagen.';

  @override
  String get journalTemplateSaved => 'Tagesvorlage gespeichert.';

  @override
  String get journalTemplateCleared => 'Tagesvorlage gelöscht.';

  @override
  String get journalChangePinDialogTitle => 'PIN ändern';

  @override
  String get journalSetPinDialogTitle => 'PIN festlegen';

  @override
  String get journalNewPinLabel => 'Neue PIN (4-12 Ziffern)';

  @override
  String get journalPinValidationError => 'Bitte gib 4-12 Ziffern ein.';

  @override
  String get journalConfirmPinLabel => 'PIN bestätigen';

  @override
  String get journalPinMismatchError => 'Die PINs stimmen nicht überein.';

  @override
  String get journalPinSetSuccess => 'PIN gespeichert.';

  @override
  String get journalRemovePinTitle => 'PIN entfernen';

  @override
  String get journalRemovePinDescription =>
      'Gib deine aktuelle PIN ein, um sie zu entfernen.';

  @override
  String get journalCurrentPinLabel => 'Aktuelle PIN';

  @override
  String get journalRemovePinError => 'Die PIN ist falsch.';

  @override
  String get journalPinRemoved => 'PIN entfernt.';

  @override
  String get journalBiometricEnabledMessage =>
      'Biometrische Entsperrung aktiviert.';

  @override
  String get journalBiometricDisabledMessage =>
      'Biometrische Entsperrung deaktiviert.';

  @override
  String get journalSettingsTitle => 'Journal';

  @override
  String get journalSettingsDescription =>
      'Konfiguriere Tagesvorlage und Sicherheit deines Journals.';

  @override
  String get journalTemplateLabel => 'Tagesvorlage';

  @override
  String get journalTemplateHint =>
      'Vorlagentext, der für neue Tage vorausgefüllt wird.';

  @override
  String get journalTemplateClear => 'Vorlage löschen';

  @override
  String get journalCategoriesTitle => 'Bereiche';

  @override
  String get journalCategoriesDescription =>
      'Wähle, welche Journalbereiche du nutzen möchtest.';

  @override
  String get journalCategorySelectionLabel => 'Journalbereich';

  @override
  String get journalCategoryPersonal => 'Privat';

  @override
  String get journalCategoryWork => 'Beruflich';

  @override
  String get journalCategoryPersonalDescription =>
      'Notiere persönliche Gedanken und Reflexionen.';

  @override
  String get journalCategoryWorkDescription =>
      'Halte berufliche Notizen und Entscheidungen fest.';

  @override
  String get journalCategoryDisableLastError =>
      'Mindestens ein Journalbereich muss aktiviert bleiben.';

  @override
  String journalTemplateSectionTitle(Object category) {
    return 'Vorlage für $category';
  }

  @override
  String journalTemplateLabelFor(Object category) {
    return 'Vorlage ($category)';
  }

  @override
  String journalTemplateHintFor(Object category) {
    return 'Standardinhalt für $category-Einträge.';
  }

  @override
  String journalTemplateSavedFor(Object category) {
    return 'Vorlage für $category gespeichert.';
  }

  @override
  String journalTemplateClearedFor(Object category) {
    return 'Vorlage für $category gelöscht.';
  }

  @override
  String get journalPinStatusSet => 'PIN-Schutz aktiviert';

  @override
  String get journalPinStatusUnset => 'PIN-Schutz deaktiviert';

  @override
  String get journalPinStatusDescription =>
      'Zum Öffnen des Journals wird eine PIN benötigt.';

  @override
  String get journalPinStatusDescriptionUnset =>
      'Lege eine PIN fest, um dein Journal zu schützen.';

  @override
  String get journalChangePinButton => 'PIN ändern';

  @override
  String get journalSetPinButton => 'PIN festlegen';

  @override
  String get journalRemovePinButton => 'PIN entfernen';

  @override
  String get journalBiometricToggleTitle => 'Mit Biometrie entsperren';

  @override
  String get journalBiometricToggleSubtitle =>
      'Fingerabdruck oder Gesichtserkennung zum Entsperren verwenden.';

  @override
  String get journalLockNowButton => 'Journal jetzt sperren';

  @override
  String get journalLockedStatus => 'Journal ist gesperrt.';

  @override
  String get journalUnlockedStatus => 'Journal ist entsperrt.';

  @override
  String get journalProtectionDisabledHint =>
      'Aktiviere eine PIN oder Biometrie, um dein Journal zu schützen.';

  @override
  String get journalLockedNotice => 'Journal gesperrt. Entsperre es im Modul.';

  @override
  String get habitsAddHabitButton => 'Gewohnheit hinzufügen';

  @override
  String get habitsCreateTitle => 'Neue Gewohnheit';

  @override
  String get habitsEditTitle => 'Gewohnheit bearbeiten';

  @override
  String get habitsNameLabel => 'Name';

  @override
  String get habitsDescriptionLabel => 'Beschreibung';

  @override
  String get habitsNameRequired => 'Bitte gib einen Namen ein.';

  @override
  String get habitsIntervalLabel => 'Intervall';

  @override
  String get habitsMeasurementLabel => 'Wertetyp';

  @override
  String get habitsTargetOccurrences => 'Anzahl pro Intervall';

  @override
  String get habitsInvalidNumber => 'Bitte gib eine gültige Zahl ein.';

  @override
  String get habitsTargetValueLabel => 'Zielwert pro Intervall';

  @override
  String get habitsCancelButton => 'Abbrechen';

  @override
  String get habitsSaveButton => 'Speichern';

  @override
  String get habitsIntervalDaily => 'Täglich';

  @override
  String get habitsIntervalMultiplePerDay => 'Mehrmals pro Tag';

  @override
  String get habitsIntervalWeekly => 'Wöchentlich';

  @override
  String get habitsIntervalMultiplePerWeek => 'Mehrmals pro Woche';

  @override
  String get habitsMeasurementBoolean => 'Erledigt / nicht erledigt';

  @override
  String get habitsMeasurementInteger => 'Ganzzahliger Wert';

  @override
  String get habitsMeasurementDecimal => 'Dezimalwert';

  @override
  String habitsCreateSuccess(String name) {
    return '„$name“ wurde erstellt.';
  }

  @override
  String habitsUpdateSuccess(String name) {
    return '„$name“ wurde aktualisiert.';
  }

  @override
  String get habitsDeleteHabit => 'Gewohnheit löschen';

  @override
  String habitsDeleteHabitConfirm(String name) {
    return '„$name“ und alle Einträge löschen?';
  }

  @override
  String get habitsDeleteHabitAction => 'Löschen';

  @override
  String habitsDeleteHabitSuccess(String name) {
    return '„$name“ wurde gelöscht.';
  }

  @override
  String get habitsEmptyTitle => 'Verfolge deine Gewohnheiten';

  @override
  String get habitsEmptyDescription =>
      'Lege deine erste Gewohnheit an, um Routinen zu verfolgen und Fortschritte zu sehen.';

  @override
  String get habitsOpenDetails => 'Details anzeigen';

  @override
  String habitsSubtitleBooleanSingle(String interval) {
    return '$interval · Erledigt';
  }

  @override
  String habitsSubtitleBooleanMultiple(String interval, int count) {
    return '$interval · $count× pro Intervall';
  }

  @override
  String habitsSubtitleNumeric(String interval, String measurement) {
    return '$interval · $measurement';
  }

  @override
  String habitsSubtitleNumericTarget(
    String interval,
    String measurement,
    String target,
  ) {
    return '$interval · $measurement · Ziel $target';
  }

  @override
  String get habitsMarkDoneButton => 'Als erledigt markieren';

  @override
  String get habitsUndoTodayButton => 'Erledigung zurücknehmen';

  @override
  String get habitsAddCompletion => 'Erledigung hinzufügen';

  @override
  String get habitsAddMeasurement => 'Messwert hinzufügen';

  @override
  String habitsLogValueTitle(String name) {
    return 'Wert für „$name“ erfassen';
  }

  @override
  String get habitsValueHint => 'Wert eingeben';

  @override
  String habitsProgressCompleted(int count, int target, String period) {
    return '$count von $target Erledigungen $period';
  }

  @override
  String habitsProgressValue(String total, String target, String period) {
    return '$total von $target $period';
  }

  @override
  String habitsProgressValueNoTarget(String total, String period) {
    return '$total erfasst $period';
  }

  @override
  String get habitsPeriodDay => 'heute';

  @override
  String get habitsPeriodWeek => 'in dieser Woche';

  @override
  String get habitsCurrentProgress => 'Aktueller Fortschritt';

  @override
  String get habitsHistorySectionTitle => 'Historie';

  @override
  String get habitsNoEntriesYet => 'Noch keine Einträge.';

  @override
  String get habitsChartTitle => 'Verlauf';

  @override
  String get habitsChartEmpty =>
      'Füge einige Tage hinzu, um den Verlauf zu sehen.';

  @override
  String get habitsLogBooleanValue => 'Erledigt';

  @override
  String get habitsDeleteEntryTooltip => 'Eintrag löschen';

  @override
  String dashboardHabitsOnTrack(int completed, int total) {
    return '$completed von $total Gewohnheiten im Plan.';
  }

  @override
  String get dashboardHabitsEmpty =>
      'Lege deine erste Gewohnheit an, um hier Fortschritte zu sehen.';

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
  String get settingsGeneralTitle => 'Einstellungen';

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
  String membershipDaysRemaining(int days) {
    return 'Restlaufzeit: $days Tage';
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

  @override
  String get validationRequiredField => 'Bitte fülle dieses Feld aus.';

  @override
  String get validationNumberField => 'Bitte gib eine gültige Zahl ein.';

  @override
  String get ledgerAccountCreateTitle => 'Konto erstellen';

  @override
  String get ledgerAccountEditTitle => 'Konto bearbeiten';

  @override
  String get ledgerAccountNameLabel => 'Kontoname';

  @override
  String get ledgerAccountKindLabel => 'Kontotyp';

  @override
  String get ledgerAccountCurrencyLabel => 'Währung';

  @override
  String get ledgerValidationCurrencyCode =>
      'Bitte gib einen dreistelligen Währungscode ein.';

  @override
  String get ledgerAccountInitialBalanceLabel => 'Anfangssaldo';

  @override
  String get ledgerAccountIncludeInNetWorthLabel =>
      'In Gesamtsumme berücksichtigen';

  @override
  String get ledgerAccountCreateButton => 'Konto hinzufügen';

  @override
  String ledgerAccountCreateSuccess(String name) {
    return 'Konto \"$name\" erstellt.';
  }

  @override
  String ledgerAccountUpdateSuccess(String name) {
    return 'Konto \"$name\" aktualisiert.';
  }

  @override
  String get ledgerAccountDeleteTitle => 'Konto löschen?';

  @override
  String ledgerAccountDeleteMessage(String name) {
    return 'Soll das Konto \"$name\" gelöscht werden? Zugehörige Buchungen bleiben auf diesem Gerät.';
  }

  @override
  String ledgerAccountDeleteSuccess(String name) {
    return 'Konto \"$name\" gelöscht.';
  }

  @override
  String ledgerAccountActualBalance(String amount, String currency) {
    return 'Saldo: $amount $currency';
  }

  @override
  String ledgerAccountPlannedIncome(String amount, String currency) {
    return 'Geplante Einnahmen: $amount $currency';
  }

  @override
  String ledgerAccountPlannedExpense(String amount, String currency) {
    return 'Geplante Ausgaben: $amount $currency';
  }

  @override
  String get ledgerAccountEmptyTitle => 'Lege dein erstes Konto an';

  @override
  String get ledgerAccountEmptyDescription =>
      'Verwalte Bargeld, Bankkonten, Depots, Anlagewerte oder Kryptos.';

  @override
  String get ledgerAccountKindCash => 'Bargeld';

  @override
  String get ledgerAccountKindBank => 'Bankkonto';

  @override
  String get ledgerAccountKindDepot => 'Depot';

  @override
  String get ledgerAccountKindAsset => 'Anlagewert';

  @override
  String get ledgerAccountKindCrypto => 'Kryptowallet';

  @override
  String get ledgerTransactionCreateTitle => 'Neue Buchung';

  @override
  String get ledgerTransactionEditTitle => 'Buchung bearbeiten';

  @override
  String get ledgerTransactionKindLabel => 'Buchungstyp';

  @override
  String get ledgerTransactionAccountLabel => 'Konto';

  @override
  String get ledgerTransactionSourceAccountLabel => 'Quellkonto';

  @override
  String get ledgerTransactionTargetAccountLabel => 'Zielkonto';

  @override
  String get ledgerValidationDifferentAccounts =>
      'Wähle zwei unterschiedliche Konten.';

  @override
  String get ledgerTransactionCategoryLabel => 'Kategorie';

  @override
  String get ledgerTransactionSubcategoryLabel => 'Unterkategorie';

  @override
  String get ledgerTransactionNoSubcategory => 'Keine Unterkategorie';

  @override
  String get ledgerTransactionAmountLabel => 'Betrag';

  @override
  String get ledgerTransactionCurrencyLabel => 'Währung';

  @override
  String ledgerTransactionDateLabel(String date) {
    return 'Buchungsdatum: $date';
  }

  @override
  String get ledgerTransactionDescriptionLabel => 'Beschreibung';

  @override
  String get ledgerTransactionCryptoSymbolLabel => 'Kryptosymbol';

  @override
  String get ledgerTransactionCryptoQuantityLabel => 'Kryptomenge';

  @override
  String get ledgerTransactionCryptoPriceLabel => 'Preis je Einheit';

  @override
  String get ledgerTransactionPlannedLabel => 'Geplante Buchung';

  @override
  String get ledgerTransactionCreateButton => 'Buchung hinzufügen';

  @override
  String get ledgerTransactionNoAccountsWarning =>
      'Lege zuerst ein Konto an, bevor du Buchungen erfasst.';

  @override
  String get ledgerTransactionDeleteTitle => 'Buchung löschen?';

  @override
  String get ledgerTransactionDeleteMessage =>
      'Soll diese Buchung von diesem Gerät entfernt werden?';

  @override
  String get ledgerTransactionMarkExecuted => 'Als ausgeführt markieren';

  @override
  String get ledgerTransactionFilterType => 'Typ';

  @override
  String get ledgerTransactionFilterAll => 'Alle Typen';

  @override
  String get ledgerTransactionFilterStatus => 'Status';

  @override
  String get ledgerTransactionFilterAllStatuses => 'Alle Status';

  @override
  String get ledgerTransactionFilterExecuted => 'Ausgeführt';

  @override
  String get ledgerTransactionFilterPlanned => 'Geplant';

  @override
  String get ledgerTransactionStatusPlanned => 'Geplant';

  @override
  String get ledgerTransactionEmptyTitle => 'Noch keine Buchungen';

  @override
  String get ledgerTransactionEmptyDescription =>
      'Erfasse Einnahmen, Ausgaben oder Umbuchungen, um deine Finanzen zu verfolgen.';

  @override
  String get ledgerTransactionKindIncome => 'Einnahme';

  @override
  String get ledgerTransactionKindExpense => 'Ausgabe';

  @override
  String get ledgerTransactionKindTransfer => 'Umbuchung';

  @override
  String get ledgerTransactionKindCryptoPurchase => 'Kryptokauf';

  @override
  String ledgerCryptoCurrentPriceLoading(String symbol) {
    return 'Aktuellen Kurs für $symbol laden …';
  }

  @override
  String ledgerCryptoProfit(String amount, String currency) {
    return 'Gewinn $amount $currency';
  }

  @override
  String ledgerCryptoLoss(String amount, String currency) {
    return 'Verlust $amount $currency';
  }

  @override
  String ledgerCryptoCurrentPriceLabel(
    String price,
    String currency,
    String symbol,
  ) {
    return 'Aktueller Kurs $price $currency ($symbol)';
  }

  @override
  String get ledgerBudgetCreateTitle => 'Neues Budget';

  @override
  String get ledgerBudgetEditTitle => 'Budget bearbeiten';

  @override
  String get ledgerBudgetCategoryLabel => 'Kategorie oder Unterkategorie';

  @override
  String get ledgerBudgetPeriodLabel => 'Zeitraum';

  @override
  String get ledgerBudgetYearLabel => 'Jahr';

  @override
  String get ledgerBudgetMonthLabel => 'Monat';

  @override
  String get ledgerBudgetQuarterLabel => 'Quartal';

  @override
  String get ledgerBudgetAmountLabel => 'Betrag';

  @override
  String get ledgerBudgetCurrencyLabel => 'Währung';

  @override
  String get ledgerBudgetCreateButton => 'Budget hinzufügen';

  @override
  String get ledgerBudgetDeleteTitle => 'Budget löschen?';

  @override
  String get ledgerBudgetDeleteMessage =>
      'Soll dieses Budget von diesem Gerät entfernt werden?';

  @override
  String get ledgerBudgetUnknownCategory => 'Unbekannte Kategorie';

  @override
  String ledgerBudgetUsageSummary(
    String actual,
    String total,
    String currency,
  ) {
    return '$actual von $total $currency ausgegeben';
  }

  @override
  String ledgerBudgetPlannedAmount(String amount, String currency) {
    return 'Geplant: $amount $currency';
  }

  @override
  String get ledgerBudgetEmptyTitle => 'Keine Budgets vorhanden';

  @override
  String get ledgerBudgetEmptyDescription =>
      'Lege Budgets für Kategorien und Unterkategorien fest, um deine Ausgaben im Blick zu behalten.';

  @override
  String get ledgerBudgetPeriodMonthly => 'Monatlich';

  @override
  String get ledgerBudgetPeriodQuarterly => 'Vierteljährlich';

  @override
  String get ledgerBudgetPeriodYearly => 'Jährlich';

  @override
  String ledgerBudgetQuarterName(int quarter, int year) {
    return 'Quartal $quarter $year';
  }

  @override
  String ledgerBudgetYearName(int year) {
    return '$year';
  }

  @override
  String get ledgerCategoryCreateTitle => 'Neue Kategorie';

  @override
  String get ledgerCategoryEditTitle => 'Kategorie bearbeiten';

  @override
  String get ledgerCategoryNameLabel => 'Name';

  @override
  String get ledgerCategoryParentLabel => 'Überkategorie';

  @override
  String get ledgerCategoryNoParent => 'Keine Überkategorie';

  @override
  String get ledgerCategoryKindLabel => 'Typ';

  @override
  String get ledgerCategoryArchiveLabel => 'Kategorie archivieren';

  @override
  String get ledgerCategoryCreateButton => 'Kategorie hinzufügen';

  @override
  String get ledgerCategoryCreateSubButton => 'Unterkategorie hinzufügen';

  @override
  String get ledgerCategoryIncomeSection => 'Einnahmekategorien';

  @override
  String get ledgerCategoryExpenseSection => 'Ausgabekategorien';

  @override
  String get ledgerCategoryEmptySection => 'Noch keine Kategorien.';

  @override
  String get ledgerCategoryActiveLabel => 'Aktiv';

  @override
  String get ledgerCategoryArchivedLabel => 'Archiviert';

  @override
  String get ledgerCategoryNoSubcategories => 'Keine Unterkategorien.';

  @override
  String get ledgerCategoryDeleteTitle => 'Kategorie löschen?';

  @override
  String ledgerCategoryDeleteMessage(String name) {
    return 'Soll die Kategorie \"$name\" gelöscht werden?';
  }

  @override
  String get ledgerCategoryKindIncome => 'Einnahme';

  @override
  String get ledgerCategoryKindExpense => 'Ausgabe';

  @override
  String get ledgerRecurringCreateTitle => 'Neuer Dauerauftrag';

  @override
  String get ledgerRecurringEditTitle => 'Dauerauftrag bearbeiten';

  @override
  String get ledgerRecurringNameLabel => 'Name';

  @override
  String get ledgerRecurringAmountLabel => 'Betrag';

  @override
  String get ledgerRecurringCurrencyLabel => 'Währung';

  @override
  String get ledgerRecurringIntervalLabel => 'Intervall';

  @override
  String get ledgerRecurringIntervalCountLabel => 'Intervallanzahl';

  @override
  String ledgerRecurringNextOccurrenceLabel(String date) {
    return 'Nächste Ausführung: $date';
  }

  @override
  String get ledgerRecurringAutoApplyLabel => 'Buchungen automatisch erzeugen';

  @override
  String get ledgerRecurringMetadataLabel => 'Notizen';

  @override
  String get ledgerRecurringCreateButton => 'Dauerauftrag hinzufügen';

  @override
  String get ledgerRecurringDeleteTitle => 'Dauerauftrag löschen?';

  @override
  String get ledgerRecurringDeleteMessage =>
      'Soll dieser Dauerauftrag entfernt werden?';

  @override
  String get ledgerRecurringApplyNow => 'Buchung jetzt erstellen';

  @override
  String get ledgerRecurringEmptyTitle => 'Noch keine Daueraufträge';

  @override
  String get ledgerRecurringEmptyDescription =>
      'Erstelle Vorlagen für wiederkehrende Einnahmen, Ausgaben oder Umbuchungen.';

  @override
  String get ledgerRecurringIntervalDaily => 'Täglich';

  @override
  String get ledgerRecurringIntervalWeekly => 'Wöchentlich';

  @override
  String get ledgerRecurringIntervalMonthly => 'Monatlich';

  @override
  String get ledgerRecurringIntervalQuarterly => 'Vierteljährlich';

  @override
  String get ledgerRecurringIntervalYearly => 'Jährlich';

  @override
  String get ledgerRecurringIntervalCustom => 'Benutzerdefiniert';

  @override
  String get ledgerTabAccounts => 'Konten';

  @override
  String get ledgerTabTransactions => 'Buchungen';

  @override
  String get ledgerTabBudgets => 'Budgets';

  @override
  String get ledgerTabRecurring => 'Daueraufträge';

  @override
  String get ledgerTabCategories => 'Kategorien';

  @override
  String get ledgerDashboardNoAccounts =>
      'Lege ein Konto an, um deine Finanzen hier zu sehen.';

  @override
  String get ledgerDashboardNoNetWorth => 'Noch keine Salden vorhanden.';

  @override
  String ledgerDashboardPlannedIncomeChip(String currency, String amount) {
    return '$currency Einnahmen $amount';
  }

  @override
  String ledgerDashboardPlannedExpenseChip(String currency, String amount) {
    return '$currency Ausgaben $amount';
  }

  @override
  String get ledgerDashboardBudgetsTitle => 'Budgetübersicht';

  @override
  String get ledgerDashboardNoBudgets =>
      'Keine Budgets für den aktuellen Zeitraum.';
}
