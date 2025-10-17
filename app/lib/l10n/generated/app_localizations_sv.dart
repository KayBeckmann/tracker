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
  String get notesTagFilterLabel => 'Taggfilter';

  @override
  String get notesTagFilterAll => 'Alla taggar';

  @override
  String get notesTagSuggestionsLabel => 'Förslag';

  @override
  String get notesEmptyPlaceholder =>
      'Inga anteckningar ännu. Skapa din första anteckning för att samla idéer.';

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
  String get tasksTagsLabel => 'Taggar';

  @override
  String get tasksTagsHint => 'Taggar separerade med kommatecken';

  @override
  String get tasksTagSuggestionsLabel => 'Förslag';

  @override
  String get tasksFiltersReset => 'Återställ';

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
  String get tasksTrackedTimePlaceholder =>
      'När tidrapporteringen kopplats visas registrerade tider här.';

  @override
  String tasksDueDateLabelValue(String date) {
    return 'Förfallodatum: $date';
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
  String get timeTrackingPlaceholder =>
      'Registrera dina arbetspass här snart och koppla ihop dem med uppgifter genom gemensamma taggar.';

  @override
  String get journalPlaceholder =>
      'Samla dina journalanteckningar här och länka dem till alla moduler via delade taggar.';

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
}
