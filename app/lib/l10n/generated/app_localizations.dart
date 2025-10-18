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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navTimeTracking.
  ///
  /// In en, this message translates to:
  /// **'Time tracking'**
  String get navTimeTracking;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get navHabits;

  /// No description provided for @navLedger.
  ///
  /// In en, this message translates to:
  /// **'Household Ledger'**
  String get navLedger;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navigationMenu.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigationMenu;

  /// No description provided for @navigationUserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Logged-in user'**
  String get navigationUserTooltip;

  /// No description provided for @navLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get navLogout;

  /// No description provided for @navClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear local history'**
  String get navClearHistory;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the dashboard, {name}'**
  String dashboardWelcome(String name);

  /// No description provided for @dashboardSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}. Keep track of your backend communication and trigger actions right from here.'**
  String dashboardSignedInAs(String email);

  /// No description provided for @dashboardCardStoredResponses.
  ///
  /// In en, this message translates to:
  /// **'Stored responses'**
  String get dashboardCardStoredResponses;

  /// No description provided for @dashboardCardLatestMessage.
  ///
  /// In en, this message translates to:
  /// **'Latest message'**
  String get dashboardCardLatestMessage;

  /// No description provided for @dashboardCardBackendUrl.
  ///
  /// In en, this message translates to:
  /// **'Backend URL'**
  String get dashboardCardBackendUrl;

  /// No description provided for @dashboardCardUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get dashboardCardUser;

  /// No description provided for @dashboardCardStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashboardCardStatus;

  /// No description provided for @dashboardQuickActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick action'**
  String get dashboardQuickActionTitle;

  /// No description provided for @dashboardQuickActionDescription.
  ///
  /// In en, this message translates to:
  /// **'Fetch a new greeting from the backend and store it locally.'**
  String get dashboardQuickActionDescription;

  /// No description provided for @dashboardQuickActionButton.
  ///
  /// In en, this message translates to:
  /// **'Contact backend'**
  String get dashboardQuickActionButton;

  /// No description provided for @dashboardQuickActionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get dashboardQuickActionLoading;

  /// No description provided for @dashboardLatestEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent responses'**
  String get dashboardLatestEntriesTitle;

  /// No description provided for @dashboardLatestEntriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No responses stored yet.'**
  String get dashboardLatestEntriesEmpty;

  /// Displays the total number of notes on the dashboard card.
  ///
  /// In en, this message translates to:
  /// **'Total notes: {count}'**
  String dashboardNotesCount(int count);

  /// Heading for the most frequently used tags in the notes dashboard card.
  ///
  /// In en, this message translates to:
  /// **'Top tags'**
  String get dashboardNotesTopTags;

  /// Shown when there are no tags to display in the dashboard notes card.
  ///
  /// In en, this message translates to:
  /// **'No tags yet.'**
  String get dashboardNotesNoTags;

  /// No description provided for @dashboardTasksSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks overview'**
  String get dashboardTasksSummaryTitle;

  /// No description provided for @dashboardTasksTotal.
  ///
  /// In en, this message translates to:
  /// **'All tasks: {count}'**
  String dashboardTasksTotal(int count);

  /// No description provided for @dashboardTasksInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress: {count}'**
  String dashboardTasksInProgress(int count);

  /// No description provided for @dashboardTasksHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High priority: {count}'**
  String dashboardTasksHighPriority(int count);

  /// No description provided for @dashboardTasksNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due: {title} (due {date})'**
  String dashboardTasksNextDue(String title, String date);

  /// No description provided for @dashboardTasksNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks.'**
  String get dashboardTasksNoUpcoming;

  /// No description provided for @dashboardOpenTasksTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get dashboardOpenTasksTooltip;

  /// No description provided for @statusNotContacted.
  ///
  /// In en, this message translates to:
  /// **'The backend has not been contacted yet.'**
  String get statusNotContacted;

  /// No description provided for @statusSendingRequest.
  ///
  /// In en, this message translates to:
  /// **'Sending request to {url}...'**
  String statusSendingRequest(String url);

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'Error: {description}'**
  String statusError(String description);

  /// No description provided for @statusHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'All local entries have been deleted.'**
  String get statusHistoryCleared;

  /// No description provided for @communicationHeading.
  ///
  /// In en, this message translates to:
  /// **'Basic communication with the backend'**
  String get communicationHeading;

  /// No description provided for @communicationBackendUrl.
  ///
  /// In en, this message translates to:
  /// **'Current backend URL: {url}'**
  String communicationBackendUrl(String url);

  /// No description provided for @communicationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get communicationNameLabel;

  /// No description provided for @communicationButton.
  ///
  /// In en, this message translates to:
  /// **'Contact backend'**
  String get communicationButton;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your notes will appear here soon.'**
  String get notesPlaceholder;

  /// No description provided for @notesCreateButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesCreateButtonLabel;

  /// No description provided for @notesCreateMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Markdown note'**
  String get notesCreateMarkdown;

  /// No description provided for @notesCreateDrawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing note'**
  String get notesCreateDrawing;

  /// No description provided for @notesClearFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get notesClearFiltersTooltip;

  /// No description provided for @notesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get notesSearchHint;

  /// No description provided for @notesSearchTagHint.
  ///
  /// In en, this message translates to:
  /// **'Filter tags'**
  String get notesSearchTagHint;

  /// No description provided for @notesTagFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag filter'**
  String get notesTagFilterLabel;

  /// No description provided for @notesTagFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get notesTagFilterAll;

  /// No description provided for @notesTagSuggestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get notesTagSuggestionsLabel;

  /// No description provided for @notesEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Create the first one to start collecting ideas.'**
  String get notesEmptyPlaceholder;

  /// No description provided for @notesUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled note'**
  String get notesUntitled;

  /// No description provided for @notesTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notesTitleLabel;

  /// No description provided for @notesTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Optional title (first line used if empty)'**
  String get notesTitleHint;

  /// No description provided for @notesTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get notesTagLabel;

  /// No description provided for @notesTagHint.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated tags'**
  String get notesTagHint;

  /// No description provided for @notesMarkdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Markdown content'**
  String get notesMarkdownLabel;

  /// No description provided for @notesMarkdownHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note using Markdown formatting.'**
  String get notesMarkdownHint;

  /// No description provided for @notesMarkdownTabEdit.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get notesMarkdownTabEdit;

  /// No description provided for @notesMarkdownTabPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get notesMarkdownTabPreview;

  /// No description provided for @notesMarkdownPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to preview yet.'**
  String get notesMarkdownPreviewEmpty;

  /// No description provided for @notesMarkdownEmptyWarning.
  ///
  /// In en, this message translates to:
  /// **'Add some content before saving the note.'**
  String get notesMarkdownEmptyWarning;

  /// No description provided for @notesEditorTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesEditorTitleNew;

  /// No description provided for @notesEditorTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get notesEditorTitleEdit;

  /// No description provided for @notesEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get notesEditorSave;

  /// No description provided for @notesDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get notesDeleteTooltip;

  /// No description provided for @notesDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get notesDeleteDialogTitle;

  /// No description provided for @notesDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This note will be removed from this device. This action cannot be undone.'**
  String get notesDeleteDialogMessage;

  /// No description provided for @notesDeleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notesDeleteDialogConfirm;

  /// No description provided for @notesDrawingTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New drawing'**
  String get notesDrawingTitleNew;

  /// No description provided for @notesDrawingTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit drawing'**
  String get notesDrawingTitleEdit;

  /// No description provided for @notesDrawingTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Optional title for this drawing'**
  String get notesDrawingTitleHint;

  /// No description provided for @notesDrawingEmptyWarning.
  ///
  /// In en, this message translates to:
  /// **'Add at least one stroke before saving.'**
  String get notesDrawingEmptyWarning;

  /// No description provided for @notesDrawingUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo last stroke'**
  String get notesDrawingUndo;

  /// No description provided for @notesDrawingClear.
  ///
  /// In en, this message translates to:
  /// **'Clear canvas'**
  String get notesDrawingClear;

  /// No description provided for @notesDrawingHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get notesDrawingHideDetails;

  /// No description provided for @notesDrawingShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get notesDrawingShowDetails;

  /// No description provided for @notesDrawingToolPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get notesDrawingToolPen;

  /// No description provided for @notesDrawingToolEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get notesDrawingToolEraser;

  /// No description provided for @notesDrawingToolLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get notesDrawingToolLine;

  /// No description provided for @notesDrawingToolRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get notesDrawingToolRectangle;

  /// No description provided for @notesDrawingToolEllipse.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get notesDrawingToolEllipse;

  /// No description provided for @notesDrawingStrokeLabel.
  ///
  /// In en, this message translates to:
  /// **'Stroke width'**
  String get notesDrawingStrokeLabel;

  /// No description provided for @genericCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get genericCancel;

  /// No description provided for @tasksPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Organise upcoming tasks here.'**
  String get tasksPlaceholder;

  /// No description provided for @tasksTabList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tasksTabList;

  /// No description provided for @tasksTabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tasksTabCalendar;

  /// No description provided for @tasksCreateButton.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksCreateButton;

  /// No description provided for @tasksEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. Create your first task to stay organised.'**
  String get tasksEmptyPlaceholder;

  /// No description provided for @tasksCalendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks are due on this day.'**
  String get tasksCalendarEmpty;

  /// No description provided for @tasksCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksCreateTitle;

  /// No description provided for @tasksEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get tasksEditTitle;

  /// No description provided for @tasksSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tasksSaveButton;

  /// No description provided for @tasksTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksTitleLabel;

  /// No description provided for @tasksTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get tasksTitleHint;

  /// No description provided for @tasksTitleValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title for the task.'**
  String get tasksTitleValidationError;

  /// No description provided for @tasksStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tasksStatusLabel;

  /// No description provided for @tasksPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksPriorityLabel;

  /// No description provided for @tasksDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksDueDateLabel;

  /// No description provided for @tasksDueDateHelper.
  ///
  /// In en, this message translates to:
  /// **'Tasks are shown in the calendar by their due date.'**
  String get tasksDueDateHelper;

  /// No description provided for @tasksPickDateButton.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get tasksPickDateButton;

  /// No description provided for @tasksReminderToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable reminder'**
  String get tasksReminderToggleLabel;

  /// No description provided for @tasksReminderToggleDescription.
  ///
  /// In en, this message translates to:
  /// **'Show a device notification at a custom time.'**
  String get tasksReminderToggleDescription;

  /// No description provided for @tasksReminderScheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get tasksReminderScheduleLabel;

  /// No description provided for @tasksReminderScheduleHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose when the device should notify you.'**
  String get tasksReminderScheduleHelper;

  /// No description provided for @tasksReminderUnset.
  ///
  /// In en, this message translates to:
  /// **'No reminder selected yet.'**
  String get tasksReminderUnset;

  /// No description provided for @tasksReminderPickDateButton.
  ///
  /// In en, this message translates to:
  /// **'Select reminder date'**
  String get tasksReminderPickDateButton;

  /// No description provided for @tasksReminderPickTimeButton.
  ///
  /// In en, this message translates to:
  /// **'Select reminder time'**
  String get tasksReminderPickTimeButton;

  /// No description provided for @tasksReminderClearButton.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get tasksReminderClearButton;

  /// No description provided for @tasksReminderValidationMissing.
  ///
  /// In en, this message translates to:
  /// **'Please choose a reminder date and time.'**
  String get tasksReminderValidationMissing;

  /// No description provided for @tasksReminderValidationPast.
  ///
  /// In en, this message translates to:
  /// **'Reminder time must be in the future.'**
  String get tasksReminderValidationPast;

  /// No description provided for @tasksTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tasksTagsLabel;

  /// No description provided for @tasksTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Tags separated by commas'**
  String get tasksTagsHint;

  /// No description provided for @tasksTagSuggestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get tasksTagSuggestionsLabel;

  /// No description provided for @tasksFiltersReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasksFiltersReset;

  /// No description provided for @tasksShowFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show filters'**
  String get tasksShowFiltersTooltip;

  /// No description provided for @tasksHideFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide filters'**
  String get tasksHideFiltersTooltip;

  /// No description provided for @tasksSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get tasksSortLabel;

  /// No description provided for @tasksSortDueDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Due date ↑'**
  String get tasksSortDueDateAsc;

  /// No description provided for @tasksSortDueDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Due date ↓'**
  String get tasksSortDueDateDesc;

  /// No description provided for @tasksSortPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksSortPriority;

  /// No description provided for @tasksSortStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tasksSortStatus;

  /// No description provided for @tasksLinkedNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked note'**
  String get tasksLinkedNoteLabel;

  /// No description provided for @tasksNoNoteLinked.
  ///
  /// In en, this message translates to:
  /// **'No note linked yet.'**
  String get tasksNoNoteLinked;

  /// No description provided for @tasksRemoveNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove linked note'**
  String get tasksRemoveNoteTooltip;

  /// No description provided for @tasksSelectNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Link existing note'**
  String get tasksSelectNoteButton;

  /// No description provided for @tasksCreateNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Create new note'**
  String get tasksCreateNoteButton;

  /// No description provided for @tasksCreateMarkdownNote.
  ///
  /// In en, this message translates to:
  /// **'Create Markdown note'**
  String get tasksCreateMarkdownNote;

  /// No description provided for @tasksCreateDrawingNote.
  ///
  /// In en, this message translates to:
  /// **'Create drawing note'**
  String get tasksCreateDrawingNote;

  /// No description provided for @tasksNoNotesFound.
  ///
  /// In en, this message translates to:
  /// **'No notes available yet.'**
  String get tasksNoNotesFound;

  /// No description provided for @tasksOpenLinkedNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Open note'**
  String get tasksOpenLinkedNoteButton;

  /// No description provided for @tasksTrackedTimePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tracked time will appear here once time tracking is connected.'**
  String get tasksTrackedTimePlaceholder;

  /// No description provided for @tasksReminderNotificationGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get tasksReminderNotificationGenericTitle;

  /// No description provided for @tasksReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Reminder scheduled for {date} at {time}.'**
  String tasksReminderNotificationBody(String date, String time);

  /// No description provided for @tasksDueDateLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String tasksDueDateLabelValue(String date);

  /// No description provided for @tasksReminderLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Reminder: {date} at {time}'**
  String tasksReminderLabelValue(String date, String time);

  /// No description provided for @tasksStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get tasksStatusTodo;

  /// No description provided for @tasksStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tasksStatusInProgress;

  /// No description provided for @tasksStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksStatusDone;

  /// No description provided for @tasksPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low priority'**
  String get tasksPriorityLow;

  /// No description provided for @tasksPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium priority'**
  String get tasksPriorityMedium;

  /// No description provided for @tasksPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get tasksPriorityHigh;

  /// No description provided for @tasksPreviewOpenEditor.
  ///
  /// In en, this message translates to:
  /// **'Open in editor'**
  String get tasksPreviewOpenEditor;

  /// No description provided for @timeTrackingPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Track your work sessions here soon and link them directly to tasks with shared tags.'**
  String get timeTrackingPlaceholder;

  /// No description provided for @journalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Capture your journal entries here and connect them with every module through shared tags.'**
  String get journalPlaceholder;

  /// No description provided for @habitsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Track your habits here.'**
  String get habitsPlaceholder;

  /// No description provided for @ledgerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Manage your household budget here.'**
  String get ledgerPlaceholder;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name: {name}, Source: {source}, Time: {timestamp}'**
  String historySubtitle(String name, String source, String timestamp);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stored responses yet.'**
  String get historyEmpty;

  /// No description provided for @loginTabSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTabSignIn;

  /// No description provided for @loginTabRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginTabRegister;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email address and password.'**
  String get loginHeading;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google (coming soon)'**
  String get loginGoogleButton;

  /// No description provided for @registerHeading.
  ///
  /// In en, this message translates to:
  /// **'Create a new account with email and password.'**
  String get registerHeading;

  /// No description provided for @registerDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name (optional)'**
  String get registerDisplayNameLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password (min. 8 characters)'**
  String get registerPasswordLabel;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @registerGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Register with Google (coming soon)'**
  String get registerGoogleButton;

  /// No description provided for @authErrorInvalidEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address and a password with at least 8 characters.'**
  String get authErrorInvalidEmailPassword;

  /// No description provided for @authErrorMissingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address and password.'**
  String get authErrorMissingCredentials;

  /// No description provided for @authErrorEmailExists.
  ///
  /// In en, this message translates to:
  /// **'This email address is already registered.'**
  String get authErrorEmailExists;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Authentication error: {description}'**
  String authErrorGeneric(String description);

  /// No description provided for @authStatusSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get authStatusSubmitting;

  /// No description provided for @googlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In will be added soon.'**
  String get googlePlaceholder;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'The request was not valid.'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get errorUnauthorized;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'This email address is already registered.'**
  String get errorConflict;

  /// No description provided for @errorUnexpectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error (status {status}).'**
  String errorUnexpectedStatus(int status);

  /// No description provided for @settingsLanguageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSectionTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the language used in the app.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get settingsLanguageSwedish;

  /// No description provided for @settingsLanguageApply.
  ///
  /// In en, this message translates to:
  /// **'Apply language'**
  String get settingsLanguageApply;

  /// No description provided for @settingsCurrentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current language: {language}'**
  String settingsCurrentLanguage(String language);

  /// No description provided for @settingsAppearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSectionTitle;

  /// No description provided for @settingsThemeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get settingsThemeModeLabel;

  /// No description provided for @settingsThemeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeModeSystem;

  /// No description provided for @settingsThemeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLight;

  /// No description provided for @settingsThemeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDark;

  /// No description provided for @settingsSeedColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get settingsSeedColorLabel;

  /// No description provided for @settingsSeedColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a highlight color for the app.'**
  String get settingsSeedColorDescription;

  /// No description provided for @settingsModulesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get settingsModulesSectionTitle;

  /// No description provided for @settingsModulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which modules are visible in the menu.'**
  String get settingsModulesDescription;

  /// No description provided for @settingsModulesDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the handle to reorder.'**
  String get settingsModulesDragHint;

  /// No description provided for @settingsSyncInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted synchronisation'**
  String get settingsSyncInfoTitle;

  /// No description provided for @settingsSyncInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in only if you want to synchronise your data with the backend. Without sign-in, everything stays on this device.'**
  String get settingsSyncInfoDescription;

  /// No description provided for @settingsSyncMembershipInfo.
  ///
  /// In en, this message translates to:
  /// **'Sync becomes available after you start a membership.'**
  String get settingsSyncMembershipInfo;

  /// No description provided for @guestUserName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUserName;

  /// No description provided for @guestUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Local device'**
  String get guestUserEmail;

  /// No description provided for @dashboardStatusGuest.
  ///
  /// In en, this message translates to:
  /// **'Sync is only available after sign-in.'**
  String get dashboardStatusGuest;

  /// No description provided for @dashboardGuestIntro.
  ///
  /// In en, this message translates to:
  /// **'Use the app offline or sign in to unlock sync and membership benefits.'**
  String get dashboardGuestIntro;

  /// No description provided for @dashboardGuestSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock sync and backup'**
  String get dashboardGuestSyncTitle;

  /// No description provided for @dashboardGuestSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a free account to enable encrypted sync once you start a membership.'**
  String get dashboardGuestSyncDescription;

  /// No description provided for @dashboardGuestSyncButton.
  ///
  /// In en, this message translates to:
  /// **'Go to settings'**
  String get dashboardGuestSyncButton;

  /// No description provided for @membershipSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membershipSectionTitle;

  /// No description provided for @membershipStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Membership status unknown.'**
  String get membershipStatusUnknown;

  /// No description provided for @membershipStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Membership active until {date}.'**
  String membershipStatusActive(String date);

  /// No description provided for @membershipStatusActiveShort.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String membershipStatusActiveShort(String date);

  /// No description provided for @membershipStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'No active membership.'**
  String get membershipStatusInactive;

  /// No description provided for @membershipSyncEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sync is enabled.'**
  String get membershipSyncEnabled;

  /// No description provided for @membershipSyncDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sync is disabled.'**
  String get membershipSyncDisabled;

  /// No description provided for @membershipLastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last payment via {method}.'**
  String membershipLastPayment(String method);

  /// No description provided for @membershipRetentionInfo.
  ///
  /// In en, this message translates to:
  /// **'Synced data will remain available until {date}.'**
  String membershipRetentionInfo(String date);

  /// No description provided for @membershipActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get membershipActionsTitle;

  /// No description provided for @membershipSubscribeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly membership ({price})'**
  String membershipSubscribeMonthly(String price);

  /// No description provided for @membershipSubscribeYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly membership ({price})'**
  String membershipSubscribeYearly(String price);

  /// No description provided for @membershipPayWithPaypal.
  ///
  /// In en, this message translates to:
  /// **'Pay with PayPal'**
  String get membershipPayWithPaypal;

  /// No description provided for @membershipPayWithBitcoin.
  ///
  /// In en, this message translates to:
  /// **'Pay with Bitcoin'**
  String get membershipPayWithBitcoin;

  /// No description provided for @membershipCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel membership'**
  String get membershipCancelButton;

  /// No description provided for @membershipDeleteDataButton.
  ///
  /// In en, this message translates to:
  /// **'Delete synced data now'**
  String get membershipDeleteDataButton;

  /// No description provided for @membershipSubscribeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership updated successfully.'**
  String get membershipSubscribeSuccess;

  /// No description provided for @membershipCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership cancelled.'**
  String get membershipCancelSuccess;

  /// No description provided for @membershipDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Synced data deleted.'**
  String get membershipDeleteSuccess;

  /// No description provided for @membershipPlanMonthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly membership'**
  String get membershipPlanMonthlyLabel;

  /// No description provided for @membershipPlanYearlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Yearly membership'**
  String get membershipPlanYearlyLabel;

  /// No description provided for @membershipPlanNoneLabel.
  ///
  /// In en, this message translates to:
  /// **'No membership'**
  String get membershipPlanNoneLabel;

  /// No description provided for @membershipPaymentMethodPaypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get membershipPaymentMethodPaypal;

  /// No description provided for @membershipPaymentMethodBitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get membershipPaymentMethodBitcoin;

  /// No description provided for @settingsSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your notes across devices.'**
  String get settingsSignInPrompt;

  /// No description provided for @settingsOpenLogin.
  ///
  /// In en, this message translates to:
  /// **'Open login'**
  String get settingsOpenLogin;

  /// No description provided for @syncNowButton.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNowButton;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncInProgress;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync completed.'**
  String get syncSuccess;

  /// No description provided for @syncNotReady.
  ///
  /// In en, this message translates to:
  /// **'Please sign in before synchronising.'**
  String get syncNotReady;

  /// No description provided for @syncConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Synchronisation conflict'**
  String get syncConflictTitle;

  /// No description provided for @syncConflictMessage.
  ///
  /// In en, this message translates to:
  /// **'Select which version should be kept.'**
  String get syncConflictMessage;

  /// No description provided for @syncConflictKeepLocal.
  ///
  /// In en, this message translates to:
  /// **'Keep device version'**
  String get syncConflictKeepLocal;

  /// No description provided for @syncConflictKeepServer.
  ///
  /// In en, this message translates to:
  /// **'Keep server version'**
  String get syncConflictKeepServer;

  /// No description provided for @syncConflictResolved.
  ///
  /// In en, this message translates to:
  /// **'Conflicts resolved.'**
  String get syncConflictResolved;

  /// No description provided for @syncConflictDeviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get syncConflictDeviceLabel;

  /// No description provided for @syncConflictServerLabel.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get syncConflictServerLabel;
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
