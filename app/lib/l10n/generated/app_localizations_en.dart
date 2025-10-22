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
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonEdit => 'Edit';

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
  String dashboardNotesCount(int count) {
    return 'Total notes: $count';
  }

  @override
  String get dashboardNotesTopTags => 'Top tags';

  @override
  String get dashboardNotesNoTags => 'No tags yet.';

  @override
  String get dashboardTasksSummaryTitle => 'Tasks overview';

  @override
  String dashboardTasksTotal(int count) {
    return 'All tasks: $count';
  }

  @override
  String dashboardTasksInProgress(int count) {
    return 'In progress: $count';
  }

  @override
  String dashboardTasksHighPriority(int count) {
    return 'High priority: $count';
  }

  @override
  String dashboardTasksNextDue(String title, String date) {
    return 'Next due: $title (due $date)';
  }

  @override
  String get dashboardTasksNoUpcoming => 'No upcoming tasks.';

  @override
  String get dashboardOpenTasksTooltip => 'Open tasks';

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
  String get notesDrawingHideDetails => 'Hide details';

  @override
  String get notesDrawingShowDetails => 'Show details';

  @override
  String get notesDrawingToolPen => 'Pen';

  @override
  String get notesDrawingToolEraser => 'Eraser';

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
  String get tasksTabList => 'List';

  @override
  String get tasksTabCalendar => 'Calendar';

  @override
  String get tasksCreateButton => 'New task';

  @override
  String get tasksEmptyPlaceholder =>
      'No tasks yet. Create your first task to stay organised.';

  @override
  String get tasksCalendarEmpty => 'No tasks are due on this day.';

  @override
  String get tasksCreateTitle => 'New task';

  @override
  String get tasksEditTitle => 'Edit task';

  @override
  String get tasksSaveButton => 'Save';

  @override
  String get tasksTitleLabel => 'Title';

  @override
  String get tasksTitleHint => 'What needs to be done?';

  @override
  String get tasksTitleValidationError => 'Please enter a title for the task.';

  @override
  String get tasksStatusLabel => 'Status';

  @override
  String get tasksPriorityLabel => 'Priority';

  @override
  String get tasksDueDateLabel => 'Due date';

  @override
  String get tasksDueDateHelper =>
      'Tasks are shown in the calendar by their due date.';

  @override
  String get tasksPickDateButton => 'Select date';

  @override
  String get tasksReminderToggleLabel => 'Enable reminder';

  @override
  String get tasksReminderToggleDescription =>
      'Show a device notification at a custom time.';

  @override
  String get tasksReminderScheduleLabel => 'Reminder time';

  @override
  String get tasksReminderScheduleHelper =>
      'Choose when the device should notify you.';

  @override
  String get tasksReminderUnset => 'No reminder selected yet.';

  @override
  String get tasksReminderPickDateButton => 'Select reminder date';

  @override
  String get tasksReminderPickTimeButton => 'Select reminder time';

  @override
  String get tasksReminderClearButton => 'Remove reminder';

  @override
  String get tasksReminderValidationMissing =>
      'Please choose a reminder date and time.';

  @override
  String get tasksReminderValidationPast =>
      'Reminder time must be in the future.';

  @override
  String get tasksTagsLabel => 'Tags';

  @override
  String get tasksTagsHint => 'Tags separated by commas';

  @override
  String get tasksTagSuggestionsLabel => 'Suggestions';

  @override
  String get tasksFiltersReset => 'Reset';

  @override
  String get tasksShowFiltersTooltip => 'Show filters';

  @override
  String get tasksHideFiltersTooltip => 'Hide filters';

  @override
  String get tasksSortLabel => 'Sort by';

  @override
  String get tasksSortDueDateAsc => 'Due date ↑';

  @override
  String get tasksSortDueDateDesc => 'Due date ↓';

  @override
  String get tasksSortPriority => 'Priority';

  @override
  String get tasksSortStatus => 'Status';

  @override
  String get tasksLinkedNoteLabel => 'Linked note';

  @override
  String get tasksNoNoteLinked => 'No note linked yet.';

  @override
  String get tasksRemoveNoteTooltip => 'Remove linked note';

  @override
  String get tasksSelectNoteButton => 'Link existing note';

  @override
  String get tasksCreateNoteButton => 'Create new note';

  @override
  String get tasksCreateMarkdownNote => 'Create Markdown note';

  @override
  String get tasksCreateDrawingNote => 'Create drawing note';

  @override
  String get tasksNoNotesFound => 'No notes available yet.';

  @override
  String get tasksOpenLinkedNoteButton => 'Open note';

  @override
  String get tasksTrackedTimeEmpty => 'No time entries linked yet.';

  @override
  String tasksTrackedTimeTotal(String duration) {
    return 'Tracked work time: $duration';
  }

  @override
  String tasksTrackedTimeMore(int count) {
    return '$count more entries';
  }

  @override
  String get tasksReminderNotificationGenericTitle => 'Task reminder';

  @override
  String tasksReminderNotificationBody(String date, String time) {
    return 'Reminder scheduled for $date at $time.';
  }

  @override
  String tasksDueDateLabelValue(String date) {
    return 'Due: $date';
  }

  @override
  String tasksReminderLabelValue(String date, String time) {
    return 'Reminder: $date at $time';
  }

  @override
  String get tasksStatusTodo => 'To do';

  @override
  String get tasksStatusInProgress => 'In progress';

  @override
  String get tasksStatusDone => 'Done';

  @override
  String get tasksPriorityLow => 'Low priority';

  @override
  String get tasksPriorityMedium => 'Medium priority';

  @override
  String get tasksPriorityHigh => 'High priority';

  @override
  String get tasksPreviewOpenEditor => 'Open in editor';

  @override
  String get timeTrackingSettingsTitle => 'Time tracking';

  @override
  String get timeTrackingSettingsRoundingLabel => 'Rounding interval';

  @override
  String get timeTrackingRoundingMinute => 'To the minute';

  @override
  String get timeTrackingRoundingFive => '5-minute steps';

  @override
  String get timeTrackingRoundingTen => '10-minute steps';

  @override
  String get timeTrackingRoundingQuarter => 'Quarter-hour steps';

  @override
  String get timeTrackingSettingsTargetLabel => 'Target hours';

  @override
  String get timeTrackingSettingsTargetNone => 'No target';

  @override
  String get timeTrackingSettingsTargetDaily => 'Daily target';

  @override
  String get timeTrackingSettingsTargetWeekly => 'Weekly target';

  @override
  String get timeTrackingSettingsDailyHoursLabel => 'Target per day (HH:MM)';

  @override
  String get timeTrackingSettingsWeeklyHoursLabel => 'Target per week (HH:MM)';

  @override
  String get timeTrackingSettingsDurationHint =>
      'Use HH:MM format, for example 08:00 or 37:30.';

  @override
  String get timeTrackingSettingsInvalidDuration =>
      'Please enter a valid duration in HH:MM.';

  @override
  String timeTrackingSummaryDay(String date, String duration) {
    return 'Selected day: $date • Work: $duration';
  }

  @override
  String timeTrackingSummaryAllEntries(String duration) {
    return 'All entries: $duration';
  }

  @override
  String timeTrackingSummaryWeek(String start, String end, String duration) {
    return 'Week $start – $end: $duration';
  }

  @override
  String timeTrackingSummaryDelta(String delta) {
    return 'Delta: $delta';
  }

  @override
  String get timeTrackingCalendarPrevious => 'Previous month';

  @override
  String get timeTrackingCalendarNext => 'Next month';

  @override
  String get timeTrackingStartNowButton => 'Clock in now';

  @override
  String get timeTrackingStopNowButton => 'Clock out now';

  @override
  String get timeTrackingAddManualButton => 'Add manual entry';

  @override
  String get timeTrackingNoEntriesForDay => 'No entries for the selected day.';

  @override
  String get timeTrackingManualEntrySaved => 'Time entry saved.';

  @override
  String get timeTrackingDeleteEntryTitle => 'Delete time entry';

  @override
  String get timeTrackingDeleteEntryMessage =>
      'Do you want to delete this time entry?';

  @override
  String get timeTrackingDeleteEntryConfirm => 'Delete';

  @override
  String get timeTrackingEntryDeleted => 'Time entry deleted.';

  @override
  String get timeTrackingKindWork => 'Work';

  @override
  String get timeTrackingKindVacation => 'Vacation';

  @override
  String get timeTrackingKindDayOff => 'Day off';

  @override
  String get timeTrackingKindSick => 'Sick leave';

  @override
  String timeTrackingEntryInterval(String start, String end, String duration) {
    return '$start – $end • $duration';
  }

  @override
  String timeTrackingEntryRunning(String start, String duration) {
    return '$start • Running ($duration)';
  }

  @override
  String timeTrackingLinkedTask(String title) {
    return 'Linked task: $title';
  }

  @override
  String get timeTrackingEditEntryTooltip => 'Edit entry';

  @override
  String get timeTrackingDeleteEntryTooltip => 'Delete entry';

  @override
  String get timeTrackingFormTitle => 'Time entry';

  @override
  String get timeTrackingFormStartLabel => 'Start';

  @override
  String get timeTrackingFormEndLabel => 'End';

  @override
  String timeTrackingFormDurationLabel(String value) {
    return 'Duration: $value';
  }

  @override
  String get timeTrackingFormKindLabel => 'Type';

  @override
  String get timeTrackingFormTaskLabel => 'Linked task';

  @override
  String get timeTrackingFormNoTask => 'No task';

  @override
  String get timeTrackingFormNoteLabel => 'Note';

  @override
  String get timeTrackingFormCancel => 'Cancel';

  @override
  String get timeTrackingFormSave => 'Save';

  @override
  String get timeTrackingFormInvalidDuration =>
      'Please choose an end after the start time.';

  @override
  String get timeTrackingDashboardTitle => 'Time tracking';

  @override
  String timeTrackingDashboardToday(String duration) {
    return 'Today: $duration';
  }

  @override
  String timeTrackingDashboardWeek(String start, String end, String duration) {
    return 'Week $start – $end: $duration';
  }

  @override
  String timeTrackingDashboardDeltaDaily(String value) {
    return 'Daily delta: $value';
  }

  @override
  String timeTrackingDashboardDeltaWeekly(String value) {
    return 'Weekly delta: $value';
  }

  @override
  String get timeTrackingDashboardNoTarget => 'No target configured.';

  @override
  String get timeTrackingDashboardOpenModule => 'Open time tracking';

  @override
  String get timeTrackingAlreadyRunning => 'A timer is already running.';

  @override
  String get timeTrackingClockInSuccess => 'Started tracking.';

  @override
  String get timeTrackingNoActiveEntry => 'No active timer.';

  @override
  String timeTrackingClockOutSuccess(String duration) {
    return 'Stopped tracking ($duration).';
  }

  @override
  String get journalPlaceholder =>
      'Capture your journal entries here and connect them with every module through shared tags.';

  @override
  String get journalUnsavedChangesTitle => 'Unsaved changes';

  @override
  String get journalUnsavedChangesMessage =>
      'You have unsaved changes for this day. What would you like to do?';

  @override
  String get journalDiscardChanges => 'Discard';

  @override
  String get journalEntrySaved => 'Journal entry saved.';

  @override
  String get journalEntrySaveError =>
      'Could not save the entry. Please try again.';

  @override
  String get journalDeleteEntryTitle => 'Delete entry';

  @override
  String get journalDeleteEntryMessage =>
      'Delete the journal entry for this day?';

  @override
  String get journalEntryDeleted => 'Journal entry deleted.';

  @override
  String get journalApplyTemplateTitle => 'Apply daily template';

  @override
  String get journalApplyTemplateMessage =>
      'Replace the current content with your daily template?';

  @override
  String get journalApplyTemplateButton => 'Apply template';

  @override
  String get journalNoEntryForDay => 'No entry for this day yet.';

  @override
  String journalLastUpdated(String timestamp) {
    return 'Last updated $timestamp';
  }

  @override
  String get journalTabEdit => 'Edit';

  @override
  String get journalTabPreview => 'Preview';

  @override
  String get journalEditorHint =>
      'Write your journal entry using Markdown formatting.';

  @override
  String get journalPreviewEmpty => 'Nothing to preview yet.';

  @override
  String get journalTrendsTitle => 'Recent trends';

  @override
  String get journalTrendsDescription => 'Tracker values for the last 30 days.';

  @override
  String get journalTrendsEmpty => 'Add trackers to see trend charts.';

  @override
  String journalTrendDateRange(String start, String end) {
    return '$start - $end';
  }

  @override
  String get journalTrendNoData => 'No entries yet.';

  @override
  String get journalTrendLegendCheckbox => '0 = no, 1 = yes';

  @override
  String get journalTrendLegendRating => 'Range 0-5';

  @override
  String get journalDashboardEntryDone => 'Today\'s entry is complete.';

  @override
  String get journalDashboardEntryMissing =>
      'You haven\'t written anything today yet.';

  @override
  String get journalDashboardLocked =>
      'Unlock the journal to view today\'s status.';

  @override
  String get journalDashboardOpenButton => 'Open journal';

  @override
  String get journalTrackersSectionTitle => 'Trackers';

  @override
  String get journalAddTrackerButton => 'Add tracker';

  @override
  String get journalTrackersEmpty =>
      'No trackers yet. Create one to start tracking your routines.';

  @override
  String get journalAddTrackerTitle => 'Add tracker';

  @override
  String get journalEditTrackerTitle => 'Edit tracker';

  @override
  String get journalDeleteTrackerTitle => 'Delete tracker';

  @override
  String journalDeleteTrackerMessage(String name) {
    return 'Delete the tracker \"$name\" and all recorded values?';
  }

  @override
  String get journalTrackerNameLabel => 'Name';

  @override
  String get journalTrackerNameError => 'Enter a tracker name.';

  @override
  String get journalTrackerKindLabel => 'Tracker type';

  @override
  String get journalTrackerKindCheckbox => 'Yes / No';

  @override
  String get journalTrackerKindRating => 'Rating (0-5)';

  @override
  String get journalTrackerDescriptionLabel => 'Description (optional)';

  @override
  String journalTrackerRatingTooltip(int rating) {
    return 'Set rating to $rating stars';
  }

  @override
  String get journalTrackerClearTooltip => 'Clear value';

  @override
  String get journalCalendarPrevious => 'Previous month';

  @override
  String get journalCalendarNext => 'Next month';

  @override
  String get journalLockTooltip => 'Lock journal';

  @override
  String get journalLockedTitle => 'Journal locked';

  @override
  String get journalLockedMessage =>
      'Unlock the journal with your PIN or biometrics to view your entries.';

  @override
  String get journalPinLabel => 'PIN';

  @override
  String get journalUnlockWithPin => 'Unlock with PIN';

  @override
  String get journalUnlockWithBiometrics => 'Use biometrics';

  @override
  String get journalPinRequired => 'Enter your PIN.';

  @override
  String get journalUnlockSuccess => 'Journal unlocked.';

  @override
  String get journalUnlockFailed => 'Incorrect PIN. Try again.';

  @override
  String get journalNoProtectionConfigured =>
      'No protection is configured for the journal.';

  @override
  String get journalBiometricUnavailable =>
      'Biometric authentication is not available on this device.';

  @override
  String get journalBiometricPrompt => 'Authenticate to unlock the journal.';

  @override
  String get journalBiometricError => 'Biometric authentication failed.';

  @override
  String get journalTemplateSaved => 'Daily template saved.';

  @override
  String get journalTemplateCleared => 'Daily template cleared.';

  @override
  String get journalChangePinDialogTitle => 'Change PIN';

  @override
  String get journalSetPinDialogTitle => 'Set PIN';

  @override
  String get journalNewPinLabel => 'New PIN (4-12 digits)';

  @override
  String get journalPinValidationError => 'Enter 4-12 digits.';

  @override
  String get journalConfirmPinLabel => 'Confirm PIN';

  @override
  String get journalPinMismatchError => 'PINs do not match.';

  @override
  String get journalPinSetSuccess => 'PIN saved.';

  @override
  String get journalRemovePinTitle => 'Remove PIN';

  @override
  String get journalRemovePinDescription =>
      'Enter your current PIN to remove it from the journal.';

  @override
  String get journalCurrentPinLabel => 'Current PIN';

  @override
  String get journalRemovePinError => 'PIN is incorrect.';

  @override
  String get journalPinRemoved => 'PIN removed.';

  @override
  String get journalBiometricEnabledMessage => 'Biometric unlock enabled.';

  @override
  String get journalBiometricDisabledMessage => 'Biometric unlock disabled.';

  @override
  String get journalSettingsTitle => 'Journal';

  @override
  String get journalSettingsDescription =>
      'Configure the daily template and security options for your journal.';

  @override
  String get journalTemplateLabel => 'Daily template';

  @override
  String get journalTemplateHint =>
      'Template text that will be pre-filled for new days.';

  @override
  String get journalTemplateClear => 'Clear template';

  @override
  String get journalPinStatusSet => 'PIN protection enabled';

  @override
  String get journalPinStatusUnset => 'PIN protection disabled';

  @override
  String get journalPinStatusDescription =>
      'A PIN is required to open the journal.';

  @override
  String get journalPinStatusDescriptionUnset =>
      'Set a PIN to protect your journal entries.';

  @override
  String get journalChangePinButton => 'Change PIN';

  @override
  String get journalSetPinButton => 'Set PIN';

  @override
  String get journalRemovePinButton => 'Remove PIN';

  @override
  String get journalBiometricToggleTitle => 'Unlock with biometrics';

  @override
  String get journalBiometricToggleSubtitle =>
      'Allow fingerprint or face recognition to unlock the journal.';

  @override
  String get journalLockNowButton => 'Lock journal now';

  @override
  String get journalLockedStatus => 'Journal is locked.';

  @override
  String get journalUnlockedStatus => 'Journal is unlocked.';

  @override
  String get journalProtectionDisabledHint =>
      'Enable a PIN or biometrics to protect your journal.';

  @override
  String get journalLockedNotice =>
      'Journal locked. Unlock it from the module.';

  @override
  String get habitsAddHabitButton => 'Add habit';

  @override
  String get habitsCreateTitle => 'New habit';

  @override
  String get habitsEditTitle => 'Edit habit';

  @override
  String get habitsNameLabel => 'Name';

  @override
  String get habitsDescriptionLabel => 'Description';

  @override
  String get habitsNameRequired => 'Please enter a name.';

  @override
  String get habitsIntervalLabel => 'Interval';

  @override
  String get habitsMeasurementLabel => 'Value type';

  @override
  String get habitsTargetOccurrences => 'Times per interval';

  @override
  String get habitsInvalidNumber => 'Please enter a valid number.';

  @override
  String get habitsTargetValueLabel => 'Target value per interval';

  @override
  String get habitsCancelButton => 'Cancel';

  @override
  String get habitsSaveButton => 'Save';

  @override
  String get habitsIntervalDaily => 'Daily';

  @override
  String get habitsIntervalMultiplePerDay => 'Multiple times per day';

  @override
  String get habitsIntervalWeekly => 'Weekly';

  @override
  String get habitsIntervalMultiplePerWeek => 'Multiple times per week';

  @override
  String get habitsMeasurementBoolean => 'Completed / not completed';

  @override
  String get habitsMeasurementInteger => 'Integer value';

  @override
  String get habitsMeasurementDecimal => 'Decimal value';

  @override
  String habitsCreateSuccess(String name) {
    return 'Created \"$name\".';
  }

  @override
  String habitsUpdateSuccess(String name) {
    return 'Updated \"$name\".';
  }

  @override
  String get habitsDeleteHabit => 'Delete habit';

  @override
  String habitsDeleteHabitConfirm(String name) {
    return 'Delete \"$name\" and all its entries?';
  }

  @override
  String get habitsDeleteHabitAction => 'Delete';

  @override
  String habitsDeleteHabitSuccess(String name) {
    return 'Deleted \"$name\".';
  }

  @override
  String get habitsEmptyTitle => 'Track your habits';

  @override
  String get habitsEmptyDescription =>
      'Create your first habit to follow your routines and see your progress.';

  @override
  String get habitsOpenDetails => 'View details';

  @override
  String habitsSubtitleBooleanSingle(String interval) {
    return '$interval · Completed';
  }

  @override
  String habitsSubtitleBooleanMultiple(String interval, int count) {
    return '$interval · $count× per interval';
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
    return '$interval · $measurement · Target $target';
  }

  @override
  String get habitsMarkDoneButton => 'Mark as done';

  @override
  String get habitsUndoTodayButton => 'Undo completion';

  @override
  String get habitsAddCompletion => 'Add completion';

  @override
  String get habitsAddMeasurement => 'Add measurement';

  @override
  String habitsLogValueTitle(String name) {
    return 'Log value for \"$name\"';
  }

  @override
  String get habitsValueHint => 'Enter a value';

  @override
  String habitsProgressCompleted(int count, int target, String period) {
    return '$count of $target completions $period';
  }

  @override
  String habitsProgressValue(String total, String target, String period) {
    return '$total of $target $period';
  }

  @override
  String habitsProgressValueNoTarget(String total, String period) {
    return '$total logged $period';
  }

  @override
  String get habitsPeriodDay => 'today';

  @override
  String get habitsPeriodWeek => 'this week';

  @override
  String get habitsCurrentProgress => 'Current progress';

  @override
  String get habitsHistorySectionTitle => 'History';

  @override
  String get habitsNoEntriesYet => 'No entries yet.';

  @override
  String get habitsChartTitle => 'Progress over time';

  @override
  String get habitsChartEmpty =>
      'Add a few days of data to see your progress curve.';

  @override
  String get habitsLogBooleanValue => 'Completed';

  @override
  String get habitsDeleteEntryTooltip => 'Delete entry';

  @override
  String dashboardHabitsOnTrack(int completed, int total) {
    return '$completed of $total habits on track.';
  }

  @override
  String get dashboardHabitsEmpty =>
      'Create your first habit to start tracking progress here.';

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
  String get settingsAppearanceSectionTitle => 'Appearance';

  @override
  String get settingsThemeModeLabel => 'Theme mode';

  @override
  String get settingsThemeModeSystem => 'System default';

  @override
  String get settingsThemeModeLight => 'Light';

  @override
  String get settingsThemeModeDark => 'Dark';

  @override
  String get settingsSeedColorLabel => 'Accent color';

  @override
  String get settingsSeedColorDescription =>
      'Pick a highlight color for the app.';

  @override
  String get settingsModulesSectionTitle => 'Modules';

  @override
  String get settingsModulesDescription =>
      'Choose which modules are visible in the menu.';

  @override
  String get settingsModulesDragHint => 'Drag the handle to reorder.';

  @override
  String get settingsSyncInfoTitle => 'Encrypted synchronisation';

  @override
  String get settingsSyncInfoDescription =>
      'Sign in only if you want to synchronise your data with the backend. Without sign-in, everything stays on this device.';

  @override
  String get settingsSyncMembershipInfo =>
      'Sync becomes available after you start a membership.';

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

  @override
  String get syncNowButton => 'Sync now';

  @override
  String get syncInProgress => 'Syncing…';

  @override
  String get syncSuccess => 'Sync completed.';

  @override
  String get syncNotReady => 'Please sign in before synchronising.';

  @override
  String get syncConflictTitle => 'Synchronisation conflict';

  @override
  String get syncConflictMessage => 'Select which version should be kept.';

  @override
  String get syncConflictKeepLocal => 'Keep device version';

  @override
  String get syncConflictKeepServer => 'Keep server version';

  @override
  String get syncConflictResolved => 'Conflicts resolved.';

  @override
  String get syncConflictDeviceLabel => 'Device';

  @override
  String get syncConflictServerLabel => 'Server';
}
