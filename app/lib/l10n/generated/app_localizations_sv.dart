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
  String get navTimeTracking => 'Tidsspårning';

  @override
  String get navJournal => 'Journal';

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
  String get commonCancel => 'Avbryt';

  @override
  String get commonSave => 'Spara';

  @override
  String get commonDelete => 'Ta bort';

  @override
  String get commonCreate => 'Skapa';

  @override
  String get commonEdit => 'Redigera';

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
  String dashboardNotesCount(int count) {
    return 'Totalt antal anteckningar: $count';
  }

  @override
  String get dashboardNotesTopTags => 'Populäraste taggarna';

  @override
  String get dashboardNotesNoTags => 'Inga taggar ännu.';

  @override
  String get dashboardTasksSummaryTitle => 'Översikt över uppgifter';

  @override
  String dashboardTasksTotal(int count) {
    return 'Alla uppgifter: $count';
  }

  @override
  String dashboardTasksInProgress(int count) {
    return 'Pågår: $count';
  }

  @override
  String dashboardTasksHighPriority(int count) {
    return 'Hög prioritet: $count';
  }

  @override
  String dashboardTasksNextDue(String title, String date) {
    return 'Nästa förfallande: $title (förfaller $date)';
  }

  @override
  String get dashboardTasksNoUpcoming => 'Inga kommande uppgifter.';

  @override
  String get dashboardOpenTasksTooltip => 'Öppna uppgifter';

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
  String get notesCreateButtonLabel => 'Ny anteckning';

  @override
  String get notesCreateMarkdown => 'Markdown-anteckning';

  @override
  String get notesCreateDrawing => 'Teckning';

  @override
  String get notesClearFiltersTooltip => 'Rensa filter';

  @override
  String get notesSearchHint => 'Sök anteckningar';

  @override
  String get notesSearchTagHint => 'Filtrera taggar';

  @override
  String get notesTabActive => 'Anteckningar';

  @override
  String get notesTabArchive => 'Arkiv';

  @override
  String get notesTagFilterLabel => 'Taggfilter';

  @override
  String get notesTagFilterAll => 'Alla taggar';

  @override
  String get notesTagSuggestionsLabel => 'Förslag';

  @override
  String get notesEmptyPlaceholder =>
      'Inga anteckningar ännu. Skapa din första anteckning för att samla idéer.';

  @override
  String get notesArchiveEmpty => 'Inga arkiverade anteckningar.';

  @override
  String get notesUntitled => 'Namnlös anteckning';

  @override
  String get notesTitleLabel => 'Titel';

  @override
  String get notesTitleHint => 'Valfri titel (första raden används annars)';

  @override
  String get notesTagLabel => 'Taggar';

  @override
  String get notesTagHint => 'Taggar separerade med komma';

  @override
  String get notesMarkdownLabel => 'Markdown-innehåll';

  @override
  String get notesMarkdownHint => 'Skriv din anteckning med Markdown.';

  @override
  String get notesMarkdownTabEdit => 'Markdown';

  @override
  String get notesMarkdownTabPreview => 'Förhandsgranska';

  @override
  String get notesMarkdownPreviewEmpty => 'Inget att visa ännu.';

  @override
  String get notesMarkdownEmptyWarning =>
      'Lägg till innehåll innan du sparar anteckningen.';

  @override
  String get notesEditorTitleNew => 'Ny anteckning';

  @override
  String get notesEditorTitleEdit => 'Redigera anteckning';

  @override
  String get notesEditorSave => 'Spara';

  @override
  String get notesDeleteTooltip => 'Ta bort anteckning';

  @override
  String get notesDeleteDialogTitle => 'Ta bort anteckning?';

  @override
  String get notesDeleteDialogMessage =>
      'Den här anteckningen tas bort från den här enheten. Åtgärden kan inte ångras.';

  @override
  String get notesDeleteDialogConfirm => 'Ta bort';

  @override
  String get notesArchiveTooltip => 'Arkivera anteckning';

  @override
  String get notesUnarchiveTooltip => 'Återställ anteckning';

  @override
  String get notesDrawingTitleNew => 'Ny teckning';

  @override
  String get notesDrawingTitleEdit => 'Redigera teckning';

  @override
  String get notesDrawingTitleHint => 'Valfri titel för teckningen';

  @override
  String get notesDrawingEmptyWarning =>
      'Lägg till minst ett streck innan du sparar.';

  @override
  String get notesDrawingUndo => 'Ångra senaste streck';

  @override
  String get notesDrawingClear => 'Rensa ritfält';

  @override
  String get notesDrawingHideDetails => 'Dölj detaljer';

  @override
  String get notesDrawingShowDetails => 'Visa detaljer';

  @override
  String get notesDrawingToolPen => 'Penna';

  @override
  String get notesDrawingToolEraser => 'Suddgummi';

  @override
  String get notesDrawingToolLine => 'Linje';

  @override
  String get notesDrawingToolRectangle => 'Rektangel';

  @override
  String get notesDrawingToolEllipse => 'Ellips';

  @override
  String get notesDrawingStrokeLabel => 'Linjebredd';

  @override
  String get genericCancel => 'Avbryt';

  @override
  String get tasksPlaceholder => 'Organisera kommande uppgifter här.';

  @override
  String get tasksTabList => 'Lista';

  @override
  String get tasksTabCalendar => 'Kalender';

  @override
  String get tasksTabArchive => 'Arkiv';

  @override
  String get tasksCreateButton => 'Ny uppgift';

  @override
  String get tasksEmptyPlaceholder =>
      'Inga uppgifter ännu. Skapa din första uppgift för att hålla koll.';

  @override
  String get tasksCalendarEmpty => 'Inga uppgifter förfaller den här dagen.';

  @override
  String get tasksCreateTitle => 'Ny uppgift';

  @override
  String get tasksEditTitle => 'Redigera uppgift';

  @override
  String get tasksSaveButton => 'Spara';

  @override
  String get tasksTitleLabel => 'Titel';

  @override
  String get tasksTitleHint => 'Vad behöver göras?';

  @override
  String get tasksTitleValidationError => 'Ange en titel för uppgiften.';

  @override
  String get tasksStatusLabel => 'Status';

  @override
  String get tasksPriorityLabel => 'Prioritet';

  @override
  String get tasksDueDateLabel => 'Förfallodatum';

  @override
  String get tasksDueDateHelper =>
      'Uppgifter visas i kalendern baserat på förfallodatum.';

  @override
  String get tasksPickDateButton => 'Välj datum';

  @override
  String get tasksReminderToggleLabel => 'Aktivera påminnelse';

  @override
  String get tasksReminderToggleDescription =>
      'Visa en enhetspåminnelse vid en tid du väljer.';

  @override
  String get tasksReminderScheduleLabel => 'Tid för påminnelse';

  @override
  String get tasksReminderScheduleHelper => 'Välj när enheten ska påminna dig.';

  @override
  String get tasksReminderUnset => 'Ingen påminnelse vald ännu.';

  @override
  String get tasksReminderPickDateButton => 'Välj datum för påminnelse';

  @override
  String get tasksReminderPickTimeButton => 'Välj tid för påminnelse';

  @override
  String get tasksReminderClearButton => 'Ta bort påminnelsen';

  @override
  String get tasksReminderValidationMissing =>
      'Välj datum och tid för påminnelsen.';

  @override
  String get tasksReminderValidationPast =>
      'Påminnelsen måste ligga i framtiden.';

  @override
  String get tasksTagsLabel => 'Taggar';

  @override
  String get tasksTagsHint => 'Taggar separerade med kommatecken';

  @override
  String get tasksTagSuggestionsLabel => 'Förslag';

  @override
  String get tasksFiltersReset => 'Återställ';

  @override
  String get tasksShowFiltersTooltip => 'Visa filter';

  @override
  String get tasksHideFiltersTooltip => 'Dölj filter';

  @override
  String get tasksArchiveTooltip => 'Flytta till arkivet';

  @override
  String get tasksUnarchiveTooltip => 'Återställ från arkivet';

  @override
  String get tasksSortLabel => 'Sortera efter';

  @override
  String get tasksSortDueDateAsc => 'Förfallodatum ↑';

  @override
  String get tasksSortDueDateDesc => 'Förfallodatum ↓';

  @override
  String get tasksSortPriority => 'Prioritet';

  @override
  String get tasksSortStatus => 'Status';

  @override
  String get tasksLinkedNoteLabel => 'Länkad anteckning';

  @override
  String get tasksNoNoteLinked => 'Ingen anteckning länkad ännu.';

  @override
  String get tasksRemoveNoteTooltip => 'Ta bort länkad anteckning';

  @override
  String get tasksSelectNoteButton => 'Länka befintlig anteckning';

  @override
  String get tasksCreateNoteButton => 'Skapa ny anteckning';

  @override
  String get tasksCreateMarkdownNote => 'Skapa Markdown-anteckning';

  @override
  String get tasksCreateDrawingNote => 'Skapa teckningsanteckning';

  @override
  String get tasksNoNotesFound => 'Inga anteckningar tillgängliga ännu.';

  @override
  String get tasksOpenLinkedNoteButton => 'Öppna anteckning';

  @override
  String get tasksTrackedTimeEmpty => 'Inga tider kopplade ännu.';

  @override
  String tasksTrackedTimeTotal(String duration) {
    return 'Registrerad arbetstid: $duration';
  }

  @override
  String tasksTrackedTimeMore(int count) {
    return '$count ytterligare poster';
  }

  @override
  String get tasksReminderNotificationGenericTitle => 'Uppgiftspåminnelse';

  @override
  String tasksReminderNotificationBody(String date, String time) {
    return 'Påminnelse för $date kl. $time.';
  }

  @override
  String tasksDueDateLabelValue(String date) {
    return 'Förfallodatum: $date';
  }

  @override
  String tasksReminderLabelValue(String date, String time) {
    return 'Påminnelse: $date kl. $time';
  }

  @override
  String get tasksStatusTodo => 'Att göra';

  @override
  String get tasksStatusInProgress => 'Pågår';

  @override
  String get tasksStatusDone => 'Klar';

  @override
  String get tasksPriorityLow => 'Låg prioritet';

  @override
  String get tasksPriorityMedium => 'Medelhög prioritet';

  @override
  String get tasksPriorityHigh => 'Hög prioritet';

  @override
  String get tasksPreviewOpenEditor => 'Öppna i redigerare';

  @override
  String get timeTrackingSettingsTitle => 'Tidrapportering';

  @override
  String get timeTrackingSettingsRoundingLabel => 'Avrundningsintervall';

  @override
  String get timeTrackingRoundingMinute => 'På minuten';

  @override
  String get timeTrackingRoundingFive => '5-minuterssteg';

  @override
  String get timeTrackingRoundingTen => '10-minuterssteg';

  @override
  String get timeTrackingRoundingQuarter => 'Kvartsteg';

  @override
  String get timeTrackingSettingsTargetLabel => 'Måltimmar';

  @override
  String get timeTrackingSettingsTargetNone => 'Inget mål';

  @override
  String get timeTrackingSettingsTargetDaily => 'Dagligt mål';

  @override
  String get timeTrackingSettingsTargetWeekly => 'Veckomål';

  @override
  String get timeTrackingSettingsDailyHoursLabel => 'Mål per dag (HH:MM)';

  @override
  String get timeTrackingSettingsWeeklyHoursLabel => 'Mål per vecka (HH:MM)';

  @override
  String get timeTrackingSettingsDurationHint =>
      'Ange i formatet HH:MM, till exempel 08:00 eller 37:30.';

  @override
  String get timeTrackingSettingsInvalidDuration =>
      'Ange en giltig tid i formatet HH:MM.';

  @override
  String timeTrackingSummaryDay(String date, String duration) {
    return 'Vald dag: $date • Arbete: $duration';
  }

  @override
  String timeTrackingSummaryAllEntries(String duration) {
    return 'Alla poster: $duration';
  }

  @override
  String timeTrackingSummaryWeek(String start, String end, String duration) {
    return 'Vecka $start – $end: $duration';
  }

  @override
  String timeTrackingSummaryDelta(String delta) {
    return 'Differens: $delta';
  }

  @override
  String get timeTrackingCalendarPrevious => 'Föregående månad';

  @override
  String get timeTrackingCalendarNext => 'Nästa månad';

  @override
  String get timeTrackingStartNowButton => 'Starta nu';

  @override
  String get timeTrackingStopNowButton => 'Stoppa nu';

  @override
  String get timeTrackingAddManualButton => 'Lägg till manuellt';

  @override
  String get timeTrackingNoEntriesForDay => 'Inga poster för vald dag.';

  @override
  String get timeTrackingManualEntrySaved => 'Tid sparad.';

  @override
  String get timeTrackingDeleteEntryTitle => 'Ta bort tidspost';

  @override
  String get timeTrackingDeleteEntryMessage =>
      'Vill du ta bort den här posten?';

  @override
  String get timeTrackingDeleteEntryConfirm => 'Ta bort';

  @override
  String get timeTrackingEntryDeleted => 'Tidsposten togs bort.';

  @override
  String get timeTrackingKindWork => 'Arbete';

  @override
  String get timeTrackingKindVacation => 'Semester';

  @override
  String get timeTrackingKindDayOff => 'Ledig dag';

  @override
  String get timeTrackingKindSick => 'Sjukfrånvaro';

  @override
  String timeTrackingEntryInterval(String start, String end, String duration) {
    return '$start – $end • $duration';
  }

  @override
  String timeTrackingEntryRunning(String start, String duration) {
    return '$start • Pågår ($duration)';
  }

  @override
  String timeTrackingLinkedTask(String title) {
    return 'Kopplad uppgift: $title';
  }

  @override
  String get timeTrackingEditEntryTooltip => 'Redigera post';

  @override
  String get timeTrackingDeleteEntryTooltip => 'Ta bort post';

  @override
  String get timeTrackingFormTitle => 'Tidspost';

  @override
  String get timeTrackingFormStartLabel => 'Start';

  @override
  String get timeTrackingFormEndLabel => 'Slut';

  @override
  String timeTrackingFormDurationLabel(String value) {
    return 'Varaktighet: $value';
  }

  @override
  String get timeTrackingFormKindLabel => 'Typ';

  @override
  String get timeTrackingFormTaskLabel => 'Kopplad uppgift';

  @override
  String get timeTrackingFormNoTask => 'Ingen uppgift';

  @override
  String get timeTrackingFormNoteLabel => 'Notering';

  @override
  String get timeTrackingFormCancel => 'Avbryt';

  @override
  String get timeTrackingFormSave => 'Spara';

  @override
  String get timeTrackingFormInvalidDuration =>
      'Välj en sluttid efter starttiden.';

  @override
  String get timeTrackingDashboardTitle => 'Tidrapportering';

  @override
  String timeTrackingDashboardToday(String duration) {
    return 'Idag: $duration';
  }

  @override
  String timeTrackingDashboardWeek(String start, String end, String duration) {
    return 'Vecka $start – $end: $duration';
  }

  @override
  String timeTrackingDashboardDeltaDaily(String value) {
    return 'Daglig differens: $value';
  }

  @override
  String timeTrackingDashboardDeltaWeekly(String value) {
    return 'Veckodifferens: $value';
  }

  @override
  String get timeTrackingDashboardNoTarget => 'Inget mål angivet.';

  @override
  String get timeTrackingDashboardOpenModule => 'Öppna tidrapporteringen';

  @override
  String get timeTrackingAlreadyRunning => 'En registrering pågår redan.';

  @override
  String get timeTrackingClockInSuccess => 'Registrering startad.';

  @override
  String get timeTrackingNoActiveEntry => 'Ingen aktiv registrering.';

  @override
  String timeTrackingClockOutSuccess(String duration) {
    return 'Registreringen stoppades ($duration).';
  }

  @override
  String get journalPlaceholder =>
      'Samla dina journalanteckningar här och länka dem till alla moduler via delade taggar.';

  @override
  String get journalUnsavedChangesTitle => 'Osparade ändringar';

  @override
  String get journalUnsavedChangesMessage =>
      'Du har osparade ändringar för den här dagen. Hur vill du gå vidare?';

  @override
  String get journalDiscardChanges => 'Ignorera';

  @override
  String get journalEntrySaved => 'Dagboksinlägget sparades.';

  @override
  String get journalEntrySaveError =>
      'Det gick inte att spara inlägget. Försök igen.';

  @override
  String get journalDeleteEntryTitle => 'Ta bort inlägg';

  @override
  String get journalDeleteEntryMessage =>
      'Vill du ta bort dagboksinlägget för den här dagen?';

  @override
  String get journalEntryDeleted => 'Dagboksinlägget har tagits bort.';

  @override
  String get journalApplyTemplateTitle => 'Använd dagmall';

  @override
  String get journalApplyTemplateMessage =>
      'Vill du ersätta innehållet med din dagliga mall?';

  @override
  String get journalApplyTemplateButton => 'Använd mall';

  @override
  String get journalNoEntryForDay => 'Inget inlägg för den här dagen ännu.';

  @override
  String journalLastUpdated(String timestamp) {
    return 'Senast uppdaterad $timestamp';
  }

  @override
  String get journalTabEdit => 'Redigera';

  @override
  String get journalTabPreview => 'Förhandsvisa';

  @override
  String get journalEditorHint => 'Skriv ditt inlägg med Markdown-format.';

  @override
  String get journalPreviewEmpty => 'Inget att visa ännu.';

  @override
  String get journalTrendsTitle => 'Senaste trender';

  @override
  String get journalTrendsDescription =>
      'Tracker-värden för de senaste 30 dagarna.';

  @override
  String get journalTrendsEmpty => 'Lägg till tracker för att se trender.';

  @override
  String journalTrendDateRange(String start, String end) {
    return '$start - $end';
  }

  @override
  String get journalTrendNoData => 'Inga inlägg ännu.';

  @override
  String get journalTrendLegendCheckbox => '0 = nej, 1 = ja';

  @override
  String get journalTrendLegendRating => 'Intervall 0-5';

  @override
  String get journalDashboardEntryDone => 'Dagens inlägg är klart.';

  @override
  String get journalDashboardEntryMissing =>
      'Du har inte skrivit något i dag ännu.';

  @override
  String get journalDashboardLocked =>
      'Lås upp journalen för att se dagens status.';

  @override
  String get journalDashboardOpenButton => 'Öppna journal';

  @override
  String get journalTrackersSectionTitle => 'Tracker';

  @override
  String get journalAddTrackerButton => 'Lägg till tracker';

  @override
  String get journalTrackersEmpty =>
      'Inga tracker ännu. Skapa en för att följa dina rutiner.';

  @override
  String get journalAddTrackerTitle => 'Lägg till tracker';

  @override
  String get journalEditTrackerTitle => 'Redigera tracker';

  @override
  String get journalDeleteTrackerTitle => 'Ta bort tracker';

  @override
  String journalDeleteTrackerMessage(String name) {
    return 'Vill du ta bort trackern \"$name\" och alla sparade värden?';
  }

  @override
  String get journalTrackerNameLabel => 'Namn';

  @override
  String get journalTrackerNameError => 'Ange ett namn.';

  @override
  String get journalTrackerKindLabel => 'Trackertyp';

  @override
  String get journalTrackerKindCheckbox => 'Ja / Nej';

  @override
  String get journalTrackerKindRating => 'Betyg (0-5)';

  @override
  String get journalTrackerDescriptionLabel => 'Beskrivning (valfritt)';

  @override
  String journalTrackerRatingTooltip(int rating) {
    return 'Sätt betyg till $rating stjärnor';
  }

  @override
  String get journalTrackerClearTooltip => 'Rensa värde';

  @override
  String get journalCalendarPrevious => 'Föregående månad';

  @override
  String get journalCalendarNext => 'Nästa månad';

  @override
  String get journalLockTooltip => 'Lås journalen';

  @override
  String get journalLockedTitle => 'Journalen är låst';

  @override
  String get journalLockedMessage =>
      'Lås upp journalen med din PIN-kod eller biometrik för att visa inläggen.';

  @override
  String get journalPinLabel => 'PIN-kod';

  @override
  String get journalUnlockWithPin => 'Lås upp med PIN';

  @override
  String get journalUnlockWithBiometrics => 'Använd biometrik';

  @override
  String get journalPinRequired => 'Ange din PIN-kod.';

  @override
  String get journalUnlockSuccess => 'Journalen är upplåst.';

  @override
  String get journalUnlockFailed => 'Fel PIN-kod. Försök igen.';

  @override
  String get journalNoProtectionConfigured =>
      'Journalen har inget skydd konfigurerat.';

  @override
  String get journalBiometricUnavailable =>
      'Biometrisk autentisering är inte tillgänglig på den här enheten.';

  @override
  String get journalBiometricPrompt =>
      'Autentisera dig för att låsa upp journalen.';

  @override
  String get journalBiometricError => 'Biometrisk autentisering misslyckades.';

  @override
  String get journalTemplateSaved => 'Daglig mall sparad.';

  @override
  String get journalTemplateCleared => 'Daglig mall rensad.';

  @override
  String get journalChangePinDialogTitle => 'Ändra PIN-kod';

  @override
  String get journalSetPinDialogTitle => 'Ställ in PIN-kod';

  @override
  String get journalNewPinLabel => 'Ny PIN-kod (4-12 siffror)';

  @override
  String get journalPinValidationError => 'Ange 4-12 siffror.';

  @override
  String get journalConfirmPinLabel => 'Bekräfta PIN-kod';

  @override
  String get journalPinMismatchError => 'PIN-koderna matchar inte.';

  @override
  String get journalPinSetSuccess => 'PIN-koden sparades.';

  @override
  String get journalRemovePinTitle => 'Ta bort PIN-kod';

  @override
  String get journalRemovePinDescription =>
      'Ange din nuvarande PIN-kod för att ta bort den.';

  @override
  String get journalCurrentPinLabel => 'Nuvarande PIN-kod';

  @override
  String get journalRemovePinError => 'PIN-koden är felaktig.';

  @override
  String get journalPinRemoved => 'PIN-koden har tagits bort.';

  @override
  String get journalBiometricEnabledMessage =>
      'Biometrisk upplåsning har aktiverats.';

  @override
  String get journalBiometricDisabledMessage =>
      'Biometrisk upplåsning har inaktiverats.';

  @override
  String get journalSettingsTitle => 'Journal';

  @override
  String get journalSettingsDescription =>
      'Konfigurera daglig mall och säkerhet för din journal.';

  @override
  String get journalTemplateLabel => 'Daglig mall';

  @override
  String get journalTemplateHint => 'Malltext som fylls i för nya dagar.';

  @override
  String get journalTemplateClear => 'Rensa mall';

  @override
  String get journalPinStatusSet => 'PIN-skydd aktiverat';

  @override
  String get journalPinStatusUnset => 'PIN-skydd inaktiverat';

  @override
  String get journalPinStatusDescription =>
      'En PIN-kod krävs för att öppna journalen.';

  @override
  String get journalPinStatusDescriptionUnset =>
      'Ställ in en PIN-kod för att skydda journalen.';

  @override
  String get journalChangePinButton => 'Ändra PIN-kod';

  @override
  String get journalSetPinButton => 'Ställ in PIN-kod';

  @override
  String get journalRemovePinButton => 'Ta bort PIN-kod';

  @override
  String get journalBiometricToggleTitle => 'Lås upp med biometrik';

  @override
  String get journalBiometricToggleSubtitle =>
      'Tillåt fingeravtryck eller ansiktsigenkänning för att låsa upp journalen.';

  @override
  String get journalLockNowButton => 'Lås journalen nu';

  @override
  String get journalLockedStatus => 'Journalen är låst.';

  @override
  String get journalUnlockedStatus => 'Journalen är upplåst.';

  @override
  String get journalProtectionDisabledHint =>
      'Aktivera PIN-kod eller biometrik för att skydda journalen.';

  @override
  String get journalLockedNotice => 'Journalen är låst. Lås upp den i modulen.';

  @override
  String get habitsAddHabitButton => 'Lägg till vana';

  @override
  String get habitsCreateTitle => 'Ny vana';

  @override
  String get habitsEditTitle => 'Redigera vana';

  @override
  String get habitsNameLabel => 'Namn';

  @override
  String get habitsDescriptionLabel => 'Beskrivning';

  @override
  String get habitsNameRequired => 'Ange ett namn.';

  @override
  String get habitsIntervalLabel => 'Intervall';

  @override
  String get habitsMeasurementLabel => 'Värdetyp';

  @override
  String get habitsTargetOccurrences => 'Antal per intervall';

  @override
  String get habitsInvalidNumber => 'Ange ett giltigt tal.';

  @override
  String get habitsTargetValueLabel => 'Målvärde per intervall';

  @override
  String get habitsCancelButton => 'Avbryt';

  @override
  String get habitsSaveButton => 'Spara';

  @override
  String get habitsIntervalDaily => 'Dagligen';

  @override
  String get habitsIntervalMultiplePerDay => 'Flera gånger per dag';

  @override
  String get habitsIntervalWeekly => 'Varje vecka';

  @override
  String get habitsIntervalMultiplePerWeek => 'Flera gånger per vecka';

  @override
  String get habitsMeasurementBoolean => 'Genomfört / ej genomfört';

  @override
  String get habitsMeasurementInteger => 'Heltalsvärde';

  @override
  String get habitsMeasurementDecimal => 'Decimalt värde';

  @override
  String habitsCreateSuccess(String name) {
    return '\"$name\" har skapats.';
  }

  @override
  String habitsUpdateSuccess(String name) {
    return '\"$name\" har uppdaterats.';
  }

  @override
  String get habitsDeleteHabit => 'Ta bort vana';

  @override
  String habitsDeleteHabitConfirm(String name) {
    return 'Ta bort \"$name\" och alla poster?';
  }

  @override
  String get habitsDeleteHabitAction => 'Ta bort';

  @override
  String habitsDeleteHabitSuccess(String name) {
    return '\"$name\" har tagits bort.';
  }

  @override
  String get habitsEmptyTitle => 'Följ dina vanor';

  @override
  String get habitsEmptyDescription =>
      'Skapa din första vana för att följa rutiner och se dina framsteg.';

  @override
  String get habitsOpenDetails => 'Visa detaljer';

  @override
  String habitsSubtitleBooleanSingle(String interval) {
    return '$interval · Genomfört';
  }

  @override
  String habitsSubtitleBooleanMultiple(String interval, int count) {
    return '$interval · $count× per intervall';
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
    return '$interval · $measurement · Mål $target';
  }

  @override
  String get habitsMarkDoneButton => 'Markera som klar';

  @override
  String get habitsUndoTodayButton => 'Ångra markering';

  @override
  String get habitsAddCompletion => 'Lägg till genomförande';

  @override
  String get habitsAddMeasurement => 'Lägg till värde';

  @override
  String habitsLogValueTitle(String name) {
    return 'Registrera värde för \"$name\"';
  }

  @override
  String get habitsValueHint => 'Ange ett värde';

  @override
  String habitsProgressCompleted(int count, int target, String period) {
    return '$count av $target genomföranden $period';
  }

  @override
  String habitsProgressValue(String total, String target, String period) {
    return '$total av $target $period';
  }

  @override
  String habitsProgressValueNoTarget(String total, String period) {
    return '$total registrerat $period';
  }

  @override
  String get habitsPeriodDay => 'i dag';

  @override
  String get habitsPeriodWeek => 'denna vecka';

  @override
  String get habitsCurrentProgress => 'Aktuell utveckling';

  @override
  String get habitsHistorySectionTitle => 'Historik';

  @override
  String get habitsNoEntriesYet => 'Inga poster ännu.';

  @override
  String get habitsChartTitle => 'Utveckling över tid';

  @override
  String get habitsChartEmpty =>
      'Lägg till några dagar för att se utvecklingskurvan.';

  @override
  String get habitsLogBooleanValue => 'Genomfört';

  @override
  String get habitsDeleteEntryTooltip => 'Ta bort post';

  @override
  String dashboardHabitsOnTrack(int completed, int total) {
    return '$completed av $total vanor följer planen.';
  }

  @override
  String get dashboardHabitsEmpty =>
      'Skapa din första vana för att se utveckling här.';

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

  @override
  String get settingsGeneralTitle => 'Inställningar';

  @override
  String get settingsAppearanceSectionTitle => 'Utseende';

  @override
  String get settingsThemeModeLabel => 'Temaläge';

  @override
  String get settingsThemeModeSystem => 'Systemstandard';

  @override
  String get settingsThemeModeLight => 'Ljust';

  @override
  String get settingsThemeModeDark => 'Mörkt';

  @override
  String get settingsSeedColorLabel => 'Accentfärg';

  @override
  String get settingsSeedColorDescription => 'Välj en accentfärg för appen.';

  @override
  String get settingsModulesSectionTitle => 'Moduler';

  @override
  String get settingsModulesDescription =>
      'Välj vilka moduler som ska visas i menyn.';

  @override
  String get settingsModulesDragHint =>
      'Dra i handtaget för att ändra ordningen.';

  @override
  String get settingsSyncInfoTitle => 'Krypterad synkronisering';

  @override
  String get settingsSyncInfoDescription =>
      'Logga bara in om du vill synkronisera dina data med backend. Utan inloggning stannar allt på den här enheten.';

  @override
  String get settingsSyncMembershipInfo =>
      'Synkningen blir tillgänglig när du har ett aktivt medlemskap.';

  @override
  String get guestUserName => 'Gäst';

  @override
  String get guestUserEmail => 'Lokal enhet';

  @override
  String get dashboardStatusGuest =>
      'Synkronisering är endast tillgänglig efter inloggning.';

  @override
  String get dashboardGuestIntro =>
      'Använd appen offline eller logga in för att låsa upp synkronisering och medlemsförmåner.';

  @override
  String get dashboardGuestSyncTitle => 'Lås upp synkronisering';

  @override
  String get dashboardGuestSyncDescription =>
      'Skapa ett kostnadsfritt konto för att aktivera krypterad synkronisering när du startar ett medlemskap.';

  @override
  String get dashboardGuestSyncButton => 'Gå till inställningar';

  @override
  String get membershipSectionTitle => 'Medlemskap';

  @override
  String get membershipStatusUnknown => 'Medlemsstatus okänd.';

  @override
  String membershipStatusActive(String date) {
    return 'Medlemskapet är aktivt till $date.';
  }

  @override
  String membershipStatusActiveShort(String date) {
    return 'Aktivt till $date';
  }

  @override
  String membershipDaysRemaining(int days) {
    return 'Återstående dagar: $days';
  }

  @override
  String get membershipStatusInactive => 'Inget aktivt medlemskap.';

  @override
  String get membershipSyncEnabled => 'Synkronisering är aktiverad.';

  @override
  String get membershipSyncDisabled => 'Synkronisering är inaktiverad.';

  @override
  String membershipLastPayment(String method) {
    return 'Senaste betalningen via $method.';
  }

  @override
  String membershipRetentionInfo(String date) {
    return 'Synkade data sparas till $date.';
  }

  @override
  String get membershipActionsTitle => 'Välj ett abonnemang';

  @override
  String membershipSubscribeMonthly(String price) {
    return 'Månadsmedlemskap ($price)';
  }

  @override
  String membershipSubscribeYearly(String price) {
    return 'Årsmedlemskap ($price)';
  }

  @override
  String get membershipPayWithPaypal => 'Betala med PayPal';

  @override
  String get membershipPayWithBitcoin => 'Betala med Bitcoin';

  @override
  String get membershipCancelButton => 'Avsluta medlemskap';

  @override
  String get membershipDeleteDataButton => 'Radera synkade data nu';

  @override
  String get membershipSubscribeSuccess => 'Medlemskapet uppdaterades.';

  @override
  String get membershipCancelSuccess => 'Medlemskapet har avslutats.';

  @override
  String get membershipDeleteSuccess => 'Synkade data har raderats.';

  @override
  String get membershipPlanMonthlyLabel => 'Månadsmedlemskap';

  @override
  String get membershipPlanYearlyLabel => 'Årsmedlemskap';

  @override
  String get membershipPlanNoneLabel => 'Inget medlemskap';

  @override
  String get membershipPaymentMethodPaypal => 'PayPal';

  @override
  String get membershipPaymentMethodBitcoin => 'Bitcoin';

  @override
  String get settingsSignInPrompt =>
      'Logga in för att synka dina data mellan enheter.';

  @override
  String get settingsOpenLogin => 'Öppna inloggning';

  @override
  String get syncNowButton => 'Synka nu';

  @override
  String get syncInProgress => 'Synkroniserar …';

  @override
  String get syncSuccess => 'Synkroniseringen är klar.';

  @override
  String get syncNotReady => 'Logga in innan du synkroniserar.';

  @override
  String get syncConflictTitle => 'Synkroniseringskonflikt';

  @override
  String get syncConflictMessage => 'Välj vilken version som ska behållas.';

  @override
  String get syncConflictKeepLocal => 'Behåll enhetens version';

  @override
  String get syncConflictKeepServer => 'Behåll serverversionen';

  @override
  String get syncConflictResolved => 'Konflikter lösta.';

  @override
  String get syncConflictDeviceLabel => 'Enhet';

  @override
  String get syncConflictServerLabel => 'Server';

  @override
  String get validationRequiredField => 'Fyll i det här fältet.';

  @override
  String get validationNumberField => 'Ange ett giltigt tal.';

  @override
  String get ledgerAccountCreateTitle => 'Skapa konto';

  @override
  String get ledgerAccountEditTitle => 'Redigera konto';

  @override
  String get ledgerAccountNameLabel => 'Kontonamn';

  @override
  String get ledgerAccountKindLabel => 'Kontotyp';

  @override
  String get ledgerAccountCurrencyLabel => 'Valuta';

  @override
  String get ledgerValidationCurrencyCode => 'Ange en tresiffrig valutakod.';

  @override
  String get ledgerAccountInitialBalanceLabel => 'Startsaldo';

  @override
  String get ledgerAccountIncludeInNetWorthLabel => 'Ta med i totalsaldo';

  @override
  String get ledgerAccountCreateButton => 'Lägg till konto';

  @override
  String ledgerAccountCreateSuccess(String name) {
    return 'Konto \"$name\" har skapats.';
  }

  @override
  String ledgerAccountUpdateSuccess(String name) {
    return 'Konto \"$name\" har uppdaterats.';
  }

  @override
  String get ledgerAccountDeleteTitle => 'Ta bort konto?';

  @override
  String ledgerAccountDeleteMessage(String name) {
    return 'Ta bort kontot \"$name\"? Tillhörande transaktioner finns kvar på enheten.';
  }

  @override
  String ledgerAccountDeleteSuccess(String name) {
    return 'Konto \"$name\" har tagits bort.';
  }

  @override
  String ledgerAccountActualBalance(String amount, String currency) {
    return 'Saldo: $amount $currency';
  }

  @override
  String ledgerAccountPlannedIncome(String amount, String currency) {
    return 'Planerade inkomster: $amount $currency';
  }

  @override
  String ledgerAccountPlannedExpense(String amount, String currency) {
    return 'Planerade utgifter: $amount $currency';
  }

  @override
  String get ledgerAccountEmptyTitle => 'Skapa ditt första konto';

  @override
  String get ledgerAccountEmptyDescription =>
      'Hantera kontanter, bankkonton, depåer, tillgångar eller kryptoplånböcker.';

  @override
  String get ledgerAccountKindCash => 'Kontanter';

  @override
  String get ledgerAccountKindBank => 'Bankkonto';

  @override
  String get ledgerAccountKindDepot => 'Depå';

  @override
  String get ledgerAccountKindAsset => 'Tillgång';

  @override
  String get ledgerAccountKindCrypto => 'Kryptoplånbok';

  @override
  String get ledgerTransactionCreateTitle => 'Ny transaktion';

  @override
  String get ledgerTransactionEditTitle => 'Redigera transaktion';

  @override
  String get ledgerTransactionKindLabel => 'Transaktionstyp';

  @override
  String get ledgerTransactionAccountLabel => 'Konto';

  @override
  String get ledgerTransactionSourceAccountLabel => 'Från konto';

  @override
  String get ledgerTransactionTargetAccountLabel => 'Till konto';

  @override
  String get ledgerValidationDifferentAccounts => 'Välj två olika konton.';

  @override
  String get ledgerTransactionCategoryLabel => 'Kategori';

  @override
  String get ledgerTransactionSubcategoryLabel => 'Underkategori';

  @override
  String get ledgerTransactionNoSubcategory => 'Ingen underkategori';

  @override
  String get ledgerTransactionAmountLabel => 'Belopp';

  @override
  String get ledgerTransactionCurrencyLabel => 'Valuta';

  @override
  String ledgerTransactionDateLabel(String date) {
    return 'Bokföringsdatum: $date';
  }

  @override
  String get ledgerTransactionDescriptionLabel => 'Beskrivning';

  @override
  String get ledgerTransactionCryptoSymbolLabel => 'Kryptosymbol';

  @override
  String get ledgerTransactionCryptoQuantityLabel => 'Kryptomängd';

  @override
  String get ledgerTransactionCryptoPriceLabel => 'Pris per enhet';

  @override
  String get ledgerTransactionPlannedLabel => 'Planerad transaktion';

  @override
  String get ledgerTransactionCreateButton => 'Lägg till transaktion';

  @override
  String get ledgerTransactionNoAccountsWarning =>
      'Skapa ett konto innan du registrerar transaktioner.';

  @override
  String get ledgerTransactionDeleteTitle => 'Ta bort transaktion?';

  @override
  String get ledgerTransactionDeleteMessage =>
      'Vill du ta bort den här transaktionen från enheten?';

  @override
  String get ledgerTransactionMarkExecuted => 'Markera som utförd';

  @override
  String get ledgerTransactionFilterType => 'Typ';

  @override
  String get ledgerTransactionFilterAll => 'Alla typer';

  @override
  String get ledgerTransactionFilterStatus => 'Status';

  @override
  String get ledgerTransactionFilterAllStatuses => 'Alla statusar';

  @override
  String get ledgerTransactionFilterExecuted => 'Utförd';

  @override
  String get ledgerTransactionFilterPlanned => 'Planerad';

  @override
  String get ledgerTransactionStatusPlanned => 'Planerad';

  @override
  String get ledgerTransactionEmptyTitle => 'Inga transaktioner ännu';

  @override
  String get ledgerTransactionEmptyDescription =>
      'Lägg till inkomster, utgifter eller överföringar för att börja följa din ekonomi.';

  @override
  String get ledgerTransactionKindIncome => 'Inkomst';

  @override
  String get ledgerTransactionKindExpense => 'Utgift';

  @override
  String get ledgerTransactionKindTransfer => 'Överföring';

  @override
  String get ledgerTransactionKindCryptoPurchase => 'Kryptoköp';

  @override
  String ledgerCryptoCurrentPriceLoading(String symbol) {
    return 'Hämtar aktuellt pris för $symbol …';
  }

  @override
  String ledgerCryptoProfit(String amount, String currency) {
    return 'Vinst $amount $currency';
  }

  @override
  String ledgerCryptoLoss(String amount, String currency) {
    return 'Förlust $amount $currency';
  }

  @override
  String ledgerCryptoCurrentPriceLabel(
    String price,
    String currency,
    String symbol,
  ) {
    return 'Aktuellt pris $price $currency ($symbol)';
  }

  @override
  String get ledgerBudgetCreateTitle => 'Ny budget';

  @override
  String get ledgerBudgetEditTitle => 'Redigera budget';

  @override
  String get ledgerBudgetCategoryLabel => 'Kategori eller underkategori';

  @override
  String get ledgerBudgetPeriodLabel => 'Period';

  @override
  String get ledgerBudgetYearLabel => 'År';

  @override
  String get ledgerBudgetMonthLabel => 'Månad';

  @override
  String get ledgerBudgetQuarterLabel => 'Kvartal';

  @override
  String get ledgerBudgetAmountLabel => 'Belopp';

  @override
  String get ledgerBudgetCurrencyLabel => 'Valuta';

  @override
  String get ledgerBudgetCreateButton => 'Lägg till budget';

  @override
  String get ledgerBudgetDeleteTitle => 'Ta bort budget?';

  @override
  String get ledgerBudgetDeleteMessage =>
      'Vill du ta bort den här budgeten från enheten?';

  @override
  String get ledgerBudgetUnknownCategory => 'Okänd kategori';

  @override
  String ledgerBudgetUsageSummary(
    String actual,
    String total,
    String currency,
  ) {
    return '$actual av $total $currency har använts';
  }

  @override
  String ledgerBudgetPlannedAmount(String amount, String currency) {
    return 'Planerat: $amount $currency';
  }

  @override
  String get ledgerBudgetEmptyTitle => 'Inga budgetar';

  @override
  String get ledgerBudgetEmptyDescription =>
      'Skapa budgetar för kategorier och underkategorier för att hålla koll på utgifterna.';

  @override
  String get ledgerBudgetPeriodMonthly => 'Månadsvis';

  @override
  String get ledgerBudgetPeriodQuarterly => 'Kvartalsvis';

  @override
  String get ledgerBudgetPeriodYearly => 'Årsvis';

  @override
  String ledgerBudgetQuarterName(int quarter, int year) {
    return 'Kvartal $quarter $year';
  }

  @override
  String ledgerBudgetYearName(int year) {
    return '$year';
  }

  @override
  String get ledgerCategoryCreateTitle => 'Ny kategori';

  @override
  String get ledgerCategoryEditTitle => 'Redigera kategori';

  @override
  String get ledgerCategoryNameLabel => 'Namn';

  @override
  String get ledgerCategoryParentLabel => 'Överordnad kategori';

  @override
  String get ledgerCategoryNoParent => 'Ingen överordnad';

  @override
  String get ledgerCategoryKindLabel => 'Typ';

  @override
  String get ledgerCategoryArchiveLabel => 'Arkivera kategori';

  @override
  String get ledgerCategoryCreateButton => 'Lägg till kategori';

  @override
  String get ledgerCategoryCreateSubButton => 'Lägg till underkategori';

  @override
  String get ledgerCategoryIncomeSection => 'Inkomstkategorier';

  @override
  String get ledgerCategoryExpenseSection => 'Utgiftskategorier';

  @override
  String get ledgerCategoryEmptySection => 'Inga kategorier ännu.';

  @override
  String get ledgerCategoryActiveLabel => 'Aktiv';

  @override
  String get ledgerCategoryArchivedLabel => 'Arkiverad';

  @override
  String get ledgerCategoryNoSubcategories => 'Inga underkategorier.';

  @override
  String get ledgerCategoryDeleteTitle => 'Ta bort kategori?';

  @override
  String ledgerCategoryDeleteMessage(String name) {
    return 'Vill du ta bort kategorin \"$name\"?';
  }

  @override
  String get ledgerCategoryKindIncome => 'Inkomst';

  @override
  String get ledgerCategoryKindExpense => 'Utgift';

  @override
  String get ledgerRecurringCreateTitle => 'Ny stående transaktion';

  @override
  String get ledgerRecurringEditTitle => 'Redigera stående transaktion';

  @override
  String get ledgerRecurringNameLabel => 'Namn';

  @override
  String get ledgerRecurringAmountLabel => 'Belopp';

  @override
  String get ledgerRecurringCurrencyLabel => 'Valuta';

  @override
  String get ledgerRecurringIntervalLabel => 'Intervall';

  @override
  String get ledgerRecurringIntervalCountLabel => 'Antal intervall';

  @override
  String ledgerRecurringNextOccurrenceLabel(String date) {
    return 'Nästa tillfälle: $date';
  }

  @override
  String get ledgerRecurringAutoApplyLabel => 'Skapa transaktioner automatiskt';

  @override
  String get ledgerRecurringMetadataLabel => 'Noteringar';

  @override
  String get ledgerRecurringCreateButton => 'Lägg till stående transaktion';

  @override
  String get ledgerRecurringDeleteTitle => 'Ta bort stående transaktion?';

  @override
  String get ledgerRecurringDeleteMessage =>
      'Vill du ta bort den här stående transaktionen?';

  @override
  String get ledgerRecurringApplyNow => 'Skapa transaktion nu';

  @override
  String get ledgerRecurringEmptyTitle => 'Inga stående transaktioner ännu';

  @override
  String get ledgerRecurringEmptyDescription =>
      'Skapa mallar för återkommande inkomster, utgifter eller överföringar.';

  @override
  String get ledgerRecurringIntervalDaily => 'Dagligen';

  @override
  String get ledgerRecurringIntervalWeekly => 'Veckovis';

  @override
  String get ledgerRecurringIntervalMonthly => 'Månadsvis';

  @override
  String get ledgerRecurringIntervalQuarterly => 'Kvartalsvis';

  @override
  String get ledgerRecurringIntervalYearly => 'Årsvis';

  @override
  String get ledgerRecurringIntervalCustom => 'Anpassat';

  @override
  String get ledgerTabAccounts => 'Konton';

  @override
  String get ledgerTabTransactions => 'Transaktioner';

  @override
  String get ledgerTabBudgets => 'Budgetar';

  @override
  String get ledgerTabRecurring => 'Stående transaktioner';

  @override
  String get ledgerTabCategories => 'Kategorier';

  @override
  String get ledgerDashboardNoAccounts =>
      'Skapa ett konto för att se din ekonomi här.';

  @override
  String get ledgerDashboardNoNetWorth => 'Inga saldon ännu.';

  @override
  String ledgerDashboardPlannedIncomeChip(String currency, String amount) {
    return '$currency inkomster $amount';
  }

  @override
  String ledgerDashboardPlannedExpenseChip(String currency, String amount) {
    return '$currency utgifter $amount';
  }

  @override
  String get ledgerDashboardBudgetsTitle => 'Budgetöversikt';

  @override
  String get ledgerDashboardNoBudgets =>
      'Inga budgetar för den aktuella perioden.';
}
