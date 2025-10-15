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
  String get navDashboard => 'Dashboard';

  @override
  String get navNotes => 'Notes';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navTimeTracking => 'Time tracking';

  @override
  String get navJournal => 'Journal';

  @override
  String get navHabits => 'Habits';

  @override
  String get navLedger => 'Household Ledger';

  @override
  String get navSettings => 'Settings';

  @override
  String get navigationMenu => 'Navigation';

  @override
  String get navigationUserTooltip => 'Logged-in user';

  @override
  String get navLogout => 'Sign out';

  @override
  String get navClearHistory => 'Clear local history';

  @override
  String dashboardWelcome(String name) {
    return 'Welcome to the dashboard, $name';
  }

  @override
  String dashboardSignedInAs(String email) {
    return 'Signed in as $email. Keep track of your backend communication and trigger actions right from here.';
  }

  @override
  String get dashboardCardStoredResponses => 'Stored responses';

  @override
  String get dashboardCardLatestMessage => 'Latest message';

  @override
  String get dashboardCardBackendUrl => 'Backend URL';

  @override
  String get dashboardCardUser => 'User';

  @override
  String get dashboardCardStatus => 'Status';

  @override
  String get dashboardQuickActionTitle => 'Quick action';

  @override
  String get dashboardQuickActionDescription =>
      'Fetch a new greeting from the backend and store it locally.';

  @override
  String get dashboardQuickActionButton => 'Contact backend';

  @override
  String get dashboardQuickActionLoading => 'Loading...';

  @override
  String get dashboardLatestEntriesTitle => 'Recent responses';

  @override
  String get dashboardLatestEntriesEmpty => 'No responses stored yet.';

  @override
  String get statusNotContacted => 'The backend has not been contacted yet.';

  @override
  String statusSendingRequest(String url) {
    return 'Sending request to $url...';
  }

  @override
  String statusError(String description) {
    return 'Error: $description';
  }

  @override
  String get statusHistoryCleared => 'All local entries have been deleted.';

  @override
  String get communicationHeading => 'Basic communication with the backend';

  @override
  String communicationBackendUrl(String url) {
    return 'Current backend URL: $url';
  }

  @override
  String get communicationNameLabel => 'Name';

  @override
  String get communicationButton => 'Contact backend';

  @override
  String get notesPlaceholder => 'Your notes will appear here soon.';

  @override
  String get notesCreateButtonLabel => 'New note';

  @override
  String get notesCreateMarkdown => 'Markdown note';

  @override
  String get notesCreateDrawing => 'Drawing note';

  @override
  String get notesClearFiltersTooltip => 'Clear filters';

  @override
  String get notesSearchHint => 'Search notes';

  @override
  String get notesSearchTagHint => 'Filter tags';

  @override
  String get notesTagFilterLabel => 'Tag filter';

  @override
  String get notesTagFilterAll => 'All tags';

  @override
  String get notesTagSuggestionsLabel => 'Suggestions';

  @override
  String get notesEmptyPlaceholder =>
      'No notes yet. Create the first one to start collecting ideas.';

  @override
  String get notesUntitled => 'Untitled note';

  @override
  String get notesTitleLabel => 'Title';

  @override
  String get notesTitleHint => 'Optional title (first line used if empty)';

  @override
  String get notesTagLabel => 'Tags';

  @override
  String get notesTagHint => 'Comma-separated tags';

  @override
  String get notesMarkdownLabel => 'Markdown content';

  @override
  String get notesMarkdownHint => 'Write your note using Markdown formatting.';

  @override
  String get notesMarkdownTabEdit => 'Markdown';

  @override
  String get notesMarkdownTabPreview => 'Preview';

  @override
  String get notesMarkdownPreviewEmpty => 'Nothing to preview yet.';

  @override
  String get notesMarkdownEmptyWarning =>
      'Add some content before saving the note.';

  @override
  String get notesEditorTitleNew => 'New note';

  @override
  String get notesEditorTitleEdit => 'Edit note';

  @override
  String get notesEditorSave => 'Save';

  @override
  String get notesDeleteTooltip => 'Delete note';

  @override
  String get notesDeleteDialogTitle => 'Delete note?';

  @override
  String get notesDeleteDialogMessage =>
      'This note will be removed from this device. This action cannot be undone.';

  @override
  String get notesDeleteDialogConfirm => 'Delete';

  @override
  String get notesDrawingTitleNew => 'New drawing';

  @override
  String get notesDrawingTitleEdit => 'Edit drawing';

  @override
  String get notesDrawingTitleHint => 'Optional title for this drawing';

  @override
  String get notesDrawingEmptyWarning =>
      'Add at least one stroke before saving.';

  @override
  String get notesDrawingUndo => 'Undo last stroke';

  @override
  String get notesDrawingClear => 'Clear canvas';

  @override
  String get notesDrawingToolPen => 'Pen';

  @override
  String get notesDrawingToolLine => 'Line';

  @override
  String get notesDrawingToolRectangle => 'Rectangle';

  @override
  String get notesDrawingToolEllipse => 'Ellipse';

  @override
  String get notesDrawingStrokeLabel => 'Stroke width';

  @override
  String get genericCancel => 'Cancel';

  @override
  String get tasksPlaceholder => 'Organise upcoming tasks here.';

  @override
  String get timeTrackingPlaceholder =>
      'Track your work sessions here soon and link them directly to tasks with shared tags.';

  @override
  String get journalPlaceholder =>
      'Capture your journal entries here and connect them with every module through shared tags.';

  @override
  String get habitsPlaceholder => 'Track your habits here.';

  @override
  String get ledgerPlaceholder => 'Manage your household budget here.';

  @override
  String historySubtitle(String name, String source, String timestamp) {
    return 'Name: $name, Source: $source, Time: $timestamp';
  }

  @override
  String get historyEmpty => 'No stored responses yet.';

  @override
  String get loginTabSignIn => 'Sign in';

  @override
  String get loginTabRegister => 'Register';

  @override
  String get loginHeading => 'Sign in with your email address and password.';

  @override
  String get loginEmailLabel => 'Email address';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginGoogleButton => 'Sign in with Google (coming soon)';

  @override
  String get registerHeading => 'Create a new account with email and password.';

  @override
  String get registerDisplayNameLabel => 'Display name (optional)';

  @override
  String get registerPasswordLabel => 'Password (min. 8 characters)';

  @override
  String get registerButton => 'Create account';

  @override
  String get registerGoogleButton => 'Register with Google (coming soon)';

  @override
  String get authErrorInvalidEmailPassword =>
      'Please enter a valid email address and a password with at least 8 characters.';

  @override
  String get authErrorMissingCredentials =>
      'Please enter an email address and password.';

  @override
  String get authErrorEmailExists =>
      'This email address is already registered.';

  @override
  String authErrorGeneric(String description) {
    return 'Authentication error: $description';
  }

  @override
  String get authStatusSubmitting => 'Submitting...';

  @override
  String get googlePlaceholder => 'Google Sign-In will be added soon.';

  @override
  String get errorBadRequest => 'The request was not valid.';

  @override
  String get errorUnauthorized => 'Invalid credentials.';

  @override
  String get errorConflict => 'This email address is already registered.';

  @override
  String errorUnexpectedStatus(int status) {
    return 'Unexpected error (status $status).';
  }

  @override
  String get settingsLanguageSectionTitle => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Select the language used in the app.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageGerman => 'German';

  @override
  String get settingsLanguageSwedish => 'Swedish';

  @override
  String get settingsLanguageApply => 'Apply language';

  @override
  String settingsCurrentLanguage(String language) {
    return 'Current language: $language';
  }

  @override
  String get guestUserName => 'Guest';

  @override
  String get guestUserEmail => 'Local device';

  @override
  String get dashboardStatusGuest => 'Sync is only available after sign-in.';

  @override
  String get dashboardGuestIntro =>
      'Use the app offline or sign in to unlock sync and membership benefits.';

  @override
  String get dashboardGuestSyncTitle => 'Unlock sync and backup';

  @override
  String get dashboardGuestSyncDescription =>
      'Create a free account to enable encrypted sync once you start a membership.';

  @override
  String get dashboardGuestSyncButton => 'Go to settings';

  @override
  String get membershipSectionTitle => 'Membership';

  @override
  String get membershipStatusUnknown => 'Membership status unknown.';

  @override
  String membershipStatusActive(String date) {
    return 'Membership active until $date.';
  }

  @override
  String membershipStatusActiveShort(String date) {
    return 'Active until $date';
  }

  @override
  String get membershipStatusInactive => 'No active membership.';

  @override
  String get membershipSyncEnabled => 'Sync is enabled.';

  @override
  String get membershipSyncDisabled => 'Sync is disabled.';

  @override
  String membershipLastPayment(String method) {
    return 'Last payment via $method.';
  }

  @override
  String membershipRetentionInfo(String date) {
    return 'Synced data will remain available until $date.';
  }

  @override
  String get membershipActionsTitle => 'Choose a plan';

  @override
  String membershipSubscribeMonthly(String price) {
    return 'Monthly membership ($price)';
  }

  @override
  String membershipSubscribeYearly(String price) {
    return 'Yearly membership ($price)';
  }

  @override
  String get membershipPayWithPaypal => 'Pay with PayPal';

  @override
  String get membershipPayWithBitcoin => 'Pay with Bitcoin';

  @override
  String get membershipCancelButton => 'Cancel membership';

  @override
  String get membershipDeleteDataButton => 'Delete synced data now';

  @override
  String get membershipSubscribeSuccess => 'Membership updated successfully.';

  @override
  String get membershipCancelSuccess => 'Membership cancelled.';

  @override
  String get membershipDeleteSuccess => 'Synced data deleted.';

  @override
  String get membershipPlanMonthlyLabel => 'Monthly membership';

  @override
  String get membershipPlanYearlyLabel => 'Yearly membership';

  @override
  String get membershipPlanNoneLabel => 'No membership';

  @override
  String get membershipPaymentMethodPaypal => 'PayPal';

  @override
  String get membershipPaymentMethodBitcoin => 'Bitcoin';

  @override
  String get settingsSignInPrompt =>
      'Sign in to sync your notes across devices.';

  @override
  String get settingsOpenLogin => 'Open login';
}
