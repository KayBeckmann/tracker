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
