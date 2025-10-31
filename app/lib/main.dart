import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cryptography/cryptography.dart';
import 'package:local_auth/local_auth.dart';

import 'data/local/app_database.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/membership_status.dart';
import 'notes/notes_page.dart';
import 'habits/habits_page.dart';
import 'habits/habit_form.dart';
import 'habits/habit_utils.dart';
import 'journal/journal_lock_view.dart';
import 'journal/journal_page.dart';
import 'tasks/tasks_page.dart';
import 'settings/settings_keys.dart';
import 'sync/encryption_service.dart';
import 'sync/sync_api_client.dart';
import 'sync/sync_engine.dart';
import 'tasks/task_reminder_service.dart';
import 'time_tracking/time_tracking_page.dart';
import 'time_tracking/time_tracking_summary.dart';
import 'time_tracking/time_tracking_types.dart';
import 'ledger/ledger_models.dart';
import 'ledger/ledger_page.dart';
import 'ledger/ledger_utils.dart';

const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'https://api.personal-tracker.life',
);

const List<Locale> supportedAppLocales = <Locale>[
  Locale('en'),
  Locale('de'),
  Locale('sv'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(trackerBoxName);
  final database = AppDatabase();
  await TaskReminderService.instance.initialize();
  runApp(TrackerApp(database: database));
}

class TrackerApp extends StatefulWidget {
  const TrackerApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TrackerApp> createState() => _TrackerAppState();
}

class _TrackerAppState extends State<TrackerApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;

  Box<dynamic> get _settingsBox => Hive.box(trackerBoxName);

  @override
  void initState() {
    super.initState();
    final Object? stored = _settingsBox.get(preferredLocaleKey);
    if (stored is String && stored.isNotEmpty) {
      _locale = Locale(stored);
    }
    final Object? storedThemeMode = _settingsBox.get(preferredThemeModeKey);
    if (storedThemeMode is String) {
      _themeMode = switch (storedThemeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    }
    final Object? storedSeed = _settingsBox.get(preferredSeedColorKey);
    if (storedSeed is int) {
      _seedColor = Color(storedSeed);
    }
  }

  void _handleLocaleChanged(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _settingsBox.put(preferredLocaleKey, locale.languageCode);
    _markSettingsDirty();
  }

  void _handleThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    final String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    _settingsBox.put(preferredThemeModeKey, value);
    _markSettingsDirty();
  }

  void _handleSeedColorChanged(Color color) {
    setState(() {
      _seedColor = color;
    });
    _settingsBox.put(preferredSeedColorKey, color.toARGB32());
    _markSettingsDirty();
  }

  void _markSettingsDirty() {
    final now = DateTime.now().toUtc().toIso8601String();
    _settingsBox
      ..put(settingsDirtyKey, true)
      ..put(settingsLastUpdatedAtKey, now);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: HomePage(
        database: widget.database,
        currentLocale: _locale ?? supportedAppLocales.first,
        onLocaleChanged: _handleLocaleChanged,
        themeMode: _themeMode,
        onThemeModeChanged: _handleThemeModeChanged,
        seedColor: _seedColor,
        onSeedColorChanged: _handleSeedColorChanged,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.database,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.seedColor,
    required this.onSeedColorChanged,
  });

  final AppDatabase database;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Color seedColor;
  final ValueChanged<Color> onSeedColorChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _AppSection {
  dashboard,
  notes,
  tasks,
  timeTracking,
  journal,
  habits,
  ledger,
  settings,
}

class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  final int id;
  final String email;
  final String? displayName;
  final DateTime? createdAt;

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    DateTime? parsedCreatedAt;
    final Object? rawCreatedAt = json['created_at'];
    if (rawCreatedAt is String) {
      parsedCreatedAt = DateTime.tryParse(rawCreatedAt);
    }

    final Object? idValue = json['id'];
    final int id = switch (idValue) {
      int value => value,
      num value => value.toInt(),
      _ => 0,
    };

    return AuthenticatedUser(
      id: id,
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  String get displayLabel {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!;
    }
    return email;
  }
}

class _HomePageState extends State<HomePage> {
  static const List<_AppSection> _defaultModuleOrder = <_AppSection>[
    _AppSection.dashboard,
    _AppSection.notes,
    _AppSection.tasks,
    _AppSection.timeTracking,
    _AppSection.journal,
    _AppSection.habits,
    _AppSection.ledger,
  ];
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerDisplayNameController =
      TextEditingController();
  late final TextEditingController _journalTemplatePersonalController;
  late final TextEditingController _journalTemplateWorkController;
  late final TextEditingController _dailyTargetController;
  late final TextEditingController _weeklyTargetController;

  late final AppDatabase _database;
  late final Box<dynamic> _trackerBox;
  Locale _pendingLocale = supportedAppLocales.first;
  ThemeMode _pendingThemeMode = ThemeMode.system;
  Color _pendingSeedColor = Colors.blue;
  TimeTrackingRounding _timeTrackingRounding = TimeTrackingRounding.minute;
  TimeTrackingTargetMode _timeTrackingTargetMode = TimeTrackingTargetMode.none;
  int _timeTrackingDailyTargetMinutes = 0;
  int _timeTrackingWeeklyTargetMinutes = 0;

  bool _isAuthInProgress = false;
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  String? _authErrorMessage;
  MembershipStatus? _membershipStatus;
  bool _isMembershipLoading = false;
  _AppSection _selectedSection = _AppSection.dashboard;
  String? _notesTagFilter;
  late List<_AppSection> _moduleOrder;
  late Set<_AppSection> _enabledModules;
  late final SyncApiClient _syncClient;
  late final EncryptionService _encryptionService;
  late final SyncEngine _syncEngine;
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _journalTemplatePersonal = '';
  String _journalTemplateWork = '';
  Set<JournalCategory> _journalEnabledCategories = {
    JournalCategory.personal,
  };
  String? _journalPinHash;
  String? _journalPinSalt;
  bool _journalBiometricEnabled = false;
  bool _journalUnlocked = true;
  bool _isSyncInProgress = false;
  bool _isHabitCreationInProgress = false;
  StreamSubscription<List<TaskEntry>>? _taskReminderSubscription;
  StreamSubscription<int>? _pendingSyncSubscription;
  ValueListenable<Box<dynamic>>? _settingsDirtyListenable;
  bool _hasPendingSyncChanges = false;
  bool _hasPendingSettingsSync = false;
  bool _autoSyncScheduled = false;
  bool _autoSyncForce = false;
  bool _autoSyncAfterCurrent = false;
  bool _hasTriggeredInitialSync = false;

  bool get _hasJournalPin =>
      _journalPinHash != null &&
      _journalPinSalt != null &&
      _journalPinHash!.isNotEmpty &&
      _journalPinSalt!.isNotEmpty;

  bool get _journalProtectionEnabled =>
      _hasJournalPin || _journalBiometricEnabled;

  @override
  void initState() {
    super.initState();
    _database = widget.database;
    _trackerBox = Hive.box(trackerBoxName);
    _syncClient = SyncApiClient(baseUrl: backendBaseUrl);
    _encryptionService = EncryptionService();
    _syncEngine = SyncEngine(
      database: _database,
      apiClient: _syncClient,
      encryptionService: _encryptionService,
      storageBox: _trackerBox,
    );
    _syncEngine.loadStoredKey();
    _pendingSyncSubscription = _database
        .watchPendingSyncCount()
        .listen(_handlePendingSyncCount);
    _settingsDirtyListenable =
        _trackerBox.listenable(keys: const <String>[settingsDirtyKey]);
    _settingsDirtyListenable!.addListener(_handleSettingsDirtyChanged);
    _handleSettingsDirtyChanged();
    _pendingLocale = widget.currentLocale;
    _moduleOrder = List<_AppSection>.from(_defaultModuleOrder);
    _enabledModules = _defaultModuleOrder.toSet();
    _loadModuleSettings();
    _journalTemplatePersonalController = TextEditingController(
      text: _journalTemplatePersonal,
    );
    _journalTemplatePersonalController.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _journalTemplateWorkController = TextEditingController(
      text: _journalTemplateWork,
    );
    _journalTemplateWorkController.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _pendingThemeMode = widget.themeMode;
    _pendingSeedColor = widget.seedColor;
    _dailyTargetController = TextEditingController(
      text: formatDurationInput(_timeTrackingDailyTargetMinutes),
    );
    _weeklyTargetController = TextEditingController(
      text: formatDurationInput(_timeTrackingWeeklyTargetMinutes),
    );

    final Object? token = _trackerBox.get('auth_token');
    final AuthenticatedUser? user = _readCurrentUser(_trackerBox);
    if (token is String && token.isNotEmpty) {
      _syncEngine.authToken = token;
    }
    if (token is String && user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _refreshMembershipStatus();
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _taskReminderSubscription ??= _database.watchTaskEntries().listen((
        tasks,
      ) {
        if (!mounted) {
          return;
        }
        final loc = AppLocalizations.of(context);
        unawaited(TaskReminderService.instance.syncReminders(tasks, loc));
      });
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocale != oldWidget.currentLocale) {
      setState(() {
        _pendingLocale = widget.currentLocale;
      });
    }
    if (widget.themeMode != oldWidget.themeMode) {
      setState(() {
        _pendingThemeMode = widget.themeMode;
      });
    }
    if (widget.seedColor != oldWidget.seedColor) {
      setState(() {
        _pendingSeedColor = widget.seedColor;
      });
    }
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerDisplayNameController.dispose();
    _journalTemplatePersonalController.dispose();
    _journalTemplateWorkController.dispose();
    _dailyTargetController.dispose();
    _weeklyTargetController.dispose();
    _taskReminderSubscription?.cancel();
    _pendingSyncSubscription?.cancel();
    if (_settingsDirtyListenable != null) {
      _settingsDirtyListenable!.removeListener(_handleSettingsDirtyChanged);
      _settingsDirtyListenable = null;
    }
    super.dispose();
  }

  Future<void> _clearHistory() async {
    await _database.clearGreetingEntries();
  }

  Future<void> _handleLogout() async {
    await _trackerBox.delete('auth_token');
    await _trackerBox.delete('auth_user');
    await _syncEngine.clearState();
    if (!mounted) {
      return;
    }
    setState(() {
      _isSyncInProgress = false;
      _authErrorMessage = null;
      _membershipStatus = null;
      _selectedSection = _AppSection.dashboard;
      _hasPendingSyncChanges = false;
      _hasPendingSettingsSync = false;
      _autoSyncScheduled = false;
      _autoSyncForce = false;
      _autoSyncAfterCurrent = false;
      _hasTriggeredInitialSync = false;
    });
    _handleMembershipStatusChanged(null);
  }

  void _loadModuleSettings() {
    final List<dynamic>? storedOrderRaw =
        _trackerBox.get(moduleOrderKey) as List<dynamic>?;
    if (storedOrderRaw != null && storedOrderRaw.isNotEmpty) {
      final List<_AppSection> parsed = storedOrderRaw
          .map((dynamic name) => _parseSectionName('$name'))
          .whereType<_AppSection>()
          .where(_defaultModuleOrder.contains)
          .toList();
      if (parsed.isNotEmpty) {
        _moduleOrder = parsed;
        for (final section in _defaultModuleOrder) {
          if (!_moduleOrder.contains(section)) {
            _moduleOrder.add(section);
          }
        }
      }
    }

    final List<dynamic>? storedEnabledRaw =
        _trackerBox.get(enabledModulesKey) as List<dynamic>?;
    if (storedEnabledRaw != null) {
      final parsed = storedEnabledRaw
          .map((dynamic name) => _parseSectionName('$name'))
          .whereType<_AppSection>()
          .where(_defaultModuleOrder.contains)
          .toSet();
      if (parsed.isNotEmpty) {
        _enabledModules = parsed;
      }
    }

    final Object? storedRounding = _trackerBox.get(timeTrackingRoundingKey);
    if (storedRounding is String) {
      _timeTrackingRounding = TimeTrackingRoundingX.fromStorage(storedRounding);
    }
    final Object? storedTargetMode = _trackerBox.get(timeTrackingTargetModeKey);
    if (storedTargetMode is String) {
      _timeTrackingTargetMode = TimeTrackingTargetModeX.fromStorage(
        storedTargetMode,
      );
    }
    final Object? storedDaily = _trackerBox.get(
      timeTrackingDailyTargetMinutesKey,
    );
    if (storedDaily is int && storedDaily >= 0) {
      _timeTrackingDailyTargetMinutes = storedDaily;
    }
    final Object? storedWeekly = _trackerBox.get(
      timeTrackingWeeklyTargetMinutesKey,
    );
    if (storedWeekly is int && storedWeekly >= 0) {
      _timeTrackingWeeklyTargetMinutes = storedWeekly;
    }
    final Object? storedPersonal =
        _trackerBox.get(journalTemplatePersonalKey);
    final Object? legacyTemplate = _trackerBox.get(journalTemplateKey);
    if (storedPersonal is String) {
      _journalTemplatePersonal = storedPersonal;
    } else if (legacyTemplate is String) {
      _journalTemplatePersonal = legacyTemplate;
    } else {
      _journalTemplatePersonal = '';
    }

    final Object? storedWork = _trackerBox.get(journalTemplateWorkKey);
    _journalTemplateWork =
        storedWork is String ? storedWork : '';

    final Object? storedCategories =
        _trackerBox.get(journalEnabledCategoriesKey);
    if (storedCategories is List) {
      final parsed = storedCategories
          .whereType<String>()
          .map(
            (name) => JournalCategory.values.firstWhere(
              (value) => value.name == name,
              orElse: () => JournalCategory.personal,
            ),
          )
          .toSet();
      if (parsed.isNotEmpty) {
        _journalEnabledCategories = parsed;
      } else {
        _journalEnabledCategories = {JournalCategory.personal};
      }
    } else {
      _journalEnabledCategories = {JournalCategory.personal};
    }
    final Object? storedPinHash = _trackerBox.get(journalPinHashKey);
    _journalPinHash = storedPinHash is String && storedPinHash.isNotEmpty
        ? storedPinHash
        : null;
    final Object? storedPinSalt = _trackerBox.get(journalPinSaltKey);
    _journalPinSalt = storedPinSalt is String && storedPinSalt.isNotEmpty
        ? storedPinSalt
        : null;
    final Object? storedBiometric = _trackerBox.get(journalBiometricEnabledKey);
    _journalBiometricEnabled = storedBiometric is bool
        ? storedBiometric
        : false;
    _journalUnlocked = !_journalProtectionEnabled;
  }

  void _reloadSettingsFromStorage() {
    if (!mounted) {
      return;
    }

    Locale resolveLocale() {
      final Object? stored = _trackerBox.get(preferredLocaleKey);
      if (stored is String && stored.isNotEmpty) {
        return Locale(stored);
      }
      return widget.currentLocale;
    }

    ThemeMode resolveThemeMode() {
      final Object? stored = _trackerBox.get(preferredThemeModeKey);
      if (stored is String) {
        return switch (stored) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
      }
      return widget.themeMode;
    }

    Color resolveSeedColor() {
      final Object? stored = _trackerBox.get(preferredSeedColorKey);
      if (stored is int) {
        return Color(stored);
      }
      return widget.seedColor;
    }

    final locale = resolveLocale();
    final themeMode = resolveThemeMode();
    final seedColor = resolveSeedColor();

    if (widget.currentLocale != locale) {
      widget.onLocaleChanged(locale);
    }
    if (widget.themeMode != themeMode) {
      widget.onThemeModeChanged(themeMode);
    }
    if (widget.seedColor != seedColor) {
      widget.onSeedColorChanged(seedColor);
    }

    setState(() {
      _pendingLocale = locale;
      _pendingThemeMode = themeMode;
      _pendingSeedColor = seedColor;
      _loadModuleSettings();
    });

    final String dailyText = formatDurationInput(
      _timeTrackingDailyTargetMinutes,
    );
    final String weeklyText = formatDurationInput(
      _timeTrackingWeeklyTargetMinutes,
    );
    if (_dailyTargetController.text != dailyText) {
      _dailyTargetController.text = dailyText;
    }
    if (_weeklyTargetController.text != weeklyText) {
      _weeklyTargetController.text = weeklyText;
    }
    if (_journalTemplatePersonalController.text != _journalTemplatePersonal) {
      _journalTemplatePersonalController.text = _journalTemplatePersonal;
    }
    if (_journalTemplateWorkController.text != _journalTemplateWork) {
      _journalTemplateWorkController.text = _journalTemplateWork;
    }
  }

  void _persistModuleSettings() {
    final List<String> orderNames = _moduleOrder
        .map((section) => section.name)
        .toList();
    _trackerBox.put(moduleOrderKey, orderNames);
    final List<String> enabledNames = _enabledModules
        .map((section) => section.name)
        .toList();
    _trackerBox.put(enabledModulesKey, enabledNames);
    _markSettingsDirty();
  }

  void _markSettingsDirty() {
    final now = DateTime.now().toUtc().toIso8601String();
    _trackerBox
      ..put(settingsDirtyKey, true)
      ..put(settingsLastUpdatedAtKey, now);
  }

  void _updateTimeTrackingRounding(TimeTrackingRounding value) {
    setState(() {
      _timeTrackingRounding = value;
    });
    _trackerBox.put(timeTrackingRoundingKey, value.name);
    _markSettingsDirty();
  }

  void _updateTimeTrackingTargetMode(TimeTrackingTargetMode mode) {
    setState(() {
      _timeTrackingTargetMode = mode;
    });
    _trackerBox.put(timeTrackingTargetModeKey, mode.name);
    _markSettingsDirty();
  }

  void _updateTimeTrackingDailyTarget(int minutes) {
    final sanitized = minutes.clamp(0, 24 * 60).toInt();
    setState(() {
      _timeTrackingDailyTargetMinutes = sanitized;
      _dailyTargetController.text = formatDurationInput(sanitized);
    });
    _trackerBox.put(timeTrackingDailyTargetMinutesKey, sanitized);
    _markSettingsDirty();
  }

  void _updateTimeTrackingWeeklyTarget(int minutes) {
    final sanitized = minutes.clamp(0, 7 * 24 * 60).toInt();
    setState(() {
      _timeTrackingWeeklyTargetMinutes = sanitized;
      _weeklyTargetController.text = formatDurationInput(sanitized);
    });
    _trackerBox.put(timeTrackingWeeklyTargetMinutesKey, sanitized);
    _markSettingsDirty();
  }

  void _submitDailyTarget(BuildContext context, AppLocalizations loc) {
    final parsed = parseDurationInput(_dailyTargetController.text);
    if (parsed == null) {
      _showDurationParseError(context, loc);
      _dailyTargetController.text = formatDurationInput(
        _timeTrackingDailyTargetMinutes,
      );
      return;
    }
    _updateTimeTrackingDailyTarget(parsed);
  }

  void _submitWeeklyTarget(BuildContext context, AppLocalizations loc) {
    final parsed = parseDurationInput(_weeklyTargetController.text);
    if (parsed == null) {
      _showDurationParseError(context, loc);
      _weeklyTargetController.text = formatDurationInput(
        _timeTrackingWeeklyTargetMinutes,
      );
      return;
    }
    _updateTimeTrackingWeeklyTarget(parsed);
  }

  void _showDurationParseError(BuildContext context, AppLocalizations loc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.timeTrackingSettingsInvalidDuration)),
    );
  }

  _AppSection? _parseSectionName(String name) {
    try {
      return _AppSection.values.byName(name);
    } catch (_) {
      return null;
    }
  }

  List<_AppSection> get _visibleNavigationSections {
    final List<_AppSection> modules = _moduleOrder
        .where((section) => _enabledModules.contains(section))
        .toList();
    modules.add(_AppSection.settings);
    return modules;
  }

  Future<bool> _startTimeTrackingNow(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final active = await _database.getActiveTimeEntry();
    if (active != null) {
      if (!context.mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.timeTrackingAlreadyRunning)));
      return false;
    }
    await _database.insertTimeEntry(
      startedAt: DateTime.now(),
      durationMinutes: 0,
      kind: TimeEntryKind.work,
      isManual: false,
    );
    if (!context.mounted) {
      return true;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.timeTrackingClockInSuccess)));
    return true;
  }

  Future<bool> _stopTimeTrackingNow(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final active = await _database.getActiveTimeEntry();
    if (active == null) {
      if (!context.mounted) {
        return false;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.timeTrackingNoActiveEntry)));
      return false;
    }

    final now = DateTime.now();
    final startLocal = active.startedAt.toLocal();
    var roundedMinutes = roundDurationMinutes(
      now.difference(startLocal),
      _timeTrackingRounding,
    );
    if (roundedMinutes <= 0) {
      roundedMinutes = _timeTrackingRounding.stepMinutes;
    }
    await _database.completeTimeEntry(
      id: active.id,
      endedAt: now,
      durationMinutes: roundedMinutes,
      taskId: active.taskId,
    );
    if (!context.mounted) {
      return true;
    }
    final formatted = formatTrackedMinutes(roundedMinutes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.timeTrackingClockOutSuccess(formatted))),
    );
    return true;
  }

  Future<void> _persistAuthResponse(
    Map<String, dynamic> data, {
    String? password,
  }) async {
    final Object? token = data['access_token'];
    final Object? userRaw = data['user'];
    if (token is! String || token.isEmpty || userRaw is! Map) {
      throw Exception('Unexpected response from server.');
    }

    final Map<String, dynamic> userMap = userRaw.map(
      (key, dynamic value) => MapEntry(key.toString(), value),
    );

    await _trackerBox.put('auth_token', token);
    await _trackerBox.put('auth_user', userMap);
    _syncEngine.authToken = token;

    final Object? saltRaw = userMap['encryption_salt'];
    if (saltRaw is String && saltRaw.isNotEmpty) {
      _syncEngine.storeEncryptionSalt(saltRaw);
      if (password != null && password.isNotEmpty) {
        await _encryptionService.deriveKey(
          password: password,
          saltBase64: saltRaw,
        );
        _syncEngine.storeDerivedKey();
      } else {
        _syncEngine.loadStoredKey();
      }
    }

    if (mounted) {
      await _refreshMembershipStatus();
      _requestAutoSync(force: true);
    }
  }

  Future<void> _handleRegister() async {
    final loc = AppLocalizations.of(context);
    final String email = _registerEmailController.text.trim();
    final String password = _registerPasswordController.text;
    final String displayName = _registerDisplayNameController.text.trim();

    if (email.isEmpty || password.length < 8) {
      setState(() {
        _authErrorMessage = loc.authErrorInvalidEmailPassword;
      });
      return;
    }

    final Map<String, dynamic> payload = <String, dynamic>{
      'email': email,
      'password': password,
      if (displayName.isNotEmpty) 'display_name': displayName,
    };

    await _submitAuthRequest(
      context: context,
      loc: loc,
      uri: Uri.parse('$backendBaseUrl/api/auth/register'),
      payload: payload,
      expectsCreated: true,
      password: password,
    );
  }

  Future<void> _handleLogin() async {
    final loc = AppLocalizations.of(context);
    final String email = _loginEmailController.text.trim();
    final String password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _authErrorMessage = loc.authErrorMissingCredentials;
      });
      return;
    }

    final Map<String, dynamic> payload = <String, dynamic>{
      'email': email,
      'password': password,
    };

    await _submitAuthRequest(
      context: context,
      loc: loc,
      uri: Uri.parse('$backendBaseUrl/api/auth/login'),
      payload: payload,
      expectsCreated: false,
      password: password,
    );
  }

  Future<void> _submitAuthRequest({
    required BuildContext context,
    required AppLocalizations loc,
    required Uri uri,
    required Map<String, dynamic> payload,
    required bool expectsCreated,
    String? password,
  }) async {
    setState(() {
      _isAuthInProgress = true;
      _authErrorMessage = null;
    });

    try {
      final http.Response response = await http.post(
        uri,
        headers: const <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final bool success = expectsCreated
          ? response.statusCode == 201
          : response.statusCode == 200;

      if (!success) {
        final String message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        if (!mounted) {
          return;
        }
        setState(() {
          _authErrorMessage = message;
        });
        return;
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      await _persistAuthResponse(data, password: password);

      _loginPasswordController.clear();
      _registerPasswordController.clear();
      _registerDisplayNameController.clear();
      _loginEmailController.clear();
      _registerEmailController.clear();

      if (!mounted) {
        return;
      }
      setState(() {
        _authErrorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _authErrorMessage = loc.authErrorGeneric('$error');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAuthInProgress = false;
        });
      }
    }
  }

  String _extractBackendError(
    AppLocalizations loc, {
    required String responseBody,
    required int statusCode,
  }) {
    try {
      final Object body = jsonDecode(responseBody);
      if (body is Map<String, dynamic>) {
        final Object? detail = body['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
        if (detail is List && detail.isNotEmpty) {
          final Object first = detail.first;
          if (first is Map && first['msg'] is String) {
            return first['msg'] as String;
          }
        }
      }
    } catch (_) {
      // ignore decoding errors – fall back to status messages below
    }

    switch (statusCode) {
      case 400:
        return loc.errorBadRequest;
      case 401:
        return loc.errorUnauthorized;
      case 409:
        return loc.errorConflict;
      default:
        return loc.errorUnexpectedStatus(statusCode);
    }
  }

  void _showGooglePlaceholder(BuildContext context) {
    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.googlePlaceholder)));
  }

  String? _currentAuthToken() {
    final Object? raw = _trackerBox.get('auth_token');
    return raw is String ? raw : null;
  }

  void _handlePendingSyncCount(int count) {
    final bool hasChanges = count > 0;
    _hasPendingSyncChanges = hasChanges;
    if (hasChanges) {
      _requestAutoSync();
    }
  }

  void _handleSettingsDirtyChanged() {
    final Object? raw = _trackerBox.get(settingsDirtyKey);
    final bool isDirty = raw is bool ? raw : false;
    _hasPendingSettingsSync = isDirty;
    if (isDirty) {
      _requestAutoSync();
    }
  }

  void _handleMembershipStatusChanged(MembershipStatus? status) {
    final bool canSync =
        status != null && status.isActive && status.syncEnabled;
    if (canSync) {
      if (!_hasTriggeredInitialSync) {
        _hasTriggeredInitialSync = true;
        _requestAutoSync(force: true);
      } else {
        _requestAutoSync();
      }
    } else {
      _hasTriggeredInitialSync = false;
    }
  }

  void _requestAutoSync({bool force = false}) {
    if (force) {
      _autoSyncForce = true;
    }
    if (_isSyncInProgress) {
      _autoSyncAfterCurrent = true;
      return;
    }
    if (_autoSyncScheduled) {
      return;
    }
    _autoSyncScheduled = true;
    Future.microtask(_maybeRunAutoSync);
  }

  Future<void> _maybeRunAutoSync() async {
    if (!_autoSyncScheduled) {
      return;
    }
    if (!mounted) {
      _autoSyncScheduled = false;
      return;
    }
    if (_isSyncInProgress) {
      _autoSyncScheduled = false;
      _autoSyncAfterCurrent = true;
      return;
    }
    final bool forceSync = _autoSyncForce;
    if (!_canAutoSync(forceSync: forceSync)) {
      _autoSyncScheduled = false;
      return;
    }
    _autoSyncScheduled = false;
    _autoSyncForce = false;
    await _performSync(showFeedback: false);
  }

  bool _canAutoSync({required bool forceSync}) {
    final status = _membershipStatus;
    if (status == null || !status.isActive || !status.syncEnabled) {
      return false;
    }
    if (!_syncEngine.isReady) {
      return false;
    }
    if (_currentAuthToken() == null) {
      return false;
    }
    if (!forceSync &&
        !_hasPendingSyncChanges &&
        !_hasPendingSettingsSync) {
      return false;
    }
    return true;
  }

  Future<void> _refreshMembershipStatus() async {
    final String? token = _currentAuthToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _membershipStatus = null;
          _isMembershipLoading = false;
        });
      }
      _handleMembershipStatusChanged(null);
      return;
    }
    if (!mounted) {
      return;
    }

    final loc = AppLocalizations.of(context);
    setState(() {
      _isMembershipLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$backendBaseUrl/api/membership'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        final status = MembershipStatus.fromJson(json);
        if (!mounted) {
          return;
        }
        setState(() {
          _membershipStatus = status;
        });
        _handleMembershipStatusChanged(status);
      } else {
        final message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        _showSnackBar(message);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(loc.authErrorGeneric('$error'));
    } finally {
      if (mounted) {
        setState(() {
          _isMembershipLoading = false;
        });
      }
    }
  }

  Future<void> _subscribeToPlan(String plan, String paymentMethod) async {
    final String? token = _currentAuthToken();
    if (token == null || !mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    setState(() {
      _isMembershipLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/membership/subscribe'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'plan': plan,
          'payment_method': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        final status = MembershipStatus.fromJson(json);
        if (!mounted) {
          return;
        }
        setState(() {
          _membershipStatus = status;
        });
        _handleMembershipStatusChanged(status);
        _showSnackBar(loc.membershipSubscribeSuccess);
      } else {
        final message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        _showSnackBar(message);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(loc.authErrorGeneric('$error'));
    } finally {
      if (mounted) {
        setState(() {
          _isMembershipLoading = false;
        });
      }
    }
  }

  Future<void> _cancelMembership() async {
    final String? token = _currentAuthToken();
    if (token == null || !mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    setState(() {
      _isMembershipLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/membership/cancel'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        final status = MembershipStatus.fromJson(json);
        if (!mounted) {
          return;
        }
        setState(() {
          _membershipStatus = status;
        });
        _handleMembershipStatusChanged(status);
        _showSnackBar(loc.membershipCancelSuccess);
      } else {
        final message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        _showSnackBar(message);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(loc.authErrorGeneric('$error'));
    } finally {
      if (mounted) {
        setState(() {
          _isMembershipLoading = false;
        });
      }
    }
  }

  Future<void> _deleteSyncedData() async {
    final String? token = _currentAuthToken();
    if (token == null || !mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    setState(() {
      _isMembershipLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/membership/delete_synced_data'),
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        final status = MembershipStatus.fromJson(json);
        if (!mounted) {
          return;
        }
        setState(() {
          _membershipStatus = status;
        });
        _handleMembershipStatusChanged(status);
        _showSnackBar(loc.membershipDeleteSuccess);
      } else {
        final message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        _showSnackBar(message);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showSnackBar(loc.authErrorGeneric('$error'));
    } finally {
      if (mounted) {
        setState(() {
          _isMembershipLoading = false;
        });
      }
    }
  }

  Future<void> _handleSyncNow() async {
    await _performSync(showFeedback: true);
  }

  Future<bool> _performSync({required bool showFeedback}) async {
    if (!mounted) {
      return false;
    }

    final loc = AppLocalizations.of(context);
    if (!_syncEngine.isReady) {
      if (showFeedback) {
        _showSnackBar(loc.syncNotReady);
      }
      return false;
    }
    if (_isSyncInProgress) {
      return false;
    }
    setState(() {
      _isSyncInProgress = true;
    });

    bool appliedRemoteUpdates = false;
    bool syncCompleted = false;
    try {
      final result = await _syncEngine.synchronize();
      if (!mounted) {
        return false;
      }
      if (result.hasConflicts) {
        final resolved = await _resolveConflicts(result.conflicts);
        if (!resolved) {
          return false;
        }
        final retryResult = await _syncEngine.synchronize();
        if (!mounted) {
          return false;
        }
        if (retryResult.hasConflicts) {
          _showSnackBar(loc.syncConflictMessage);
        } else {
          appliedRemoteUpdates = true;
          syncCompleted = true;
          if (showFeedback) {
            _showSnackBar(loc.syncSuccess);
          }
        }
      } else {
        appliedRemoteUpdates = true;
        syncCompleted = true;
        if (showFeedback) {
          _showSnackBar(loc.syncSuccess);
        }
      }
    } catch (error) {
      if (!mounted) {
        return false;
      }
      _showSnackBar(loc.authErrorGeneric('$error'));
    } finally {
      if (mounted) {
        setState(() {
          _isSyncInProgress = false;
        });
        if (appliedRemoteUpdates) {
          _reloadSettingsFromStorage();
        }
        final bool shouldRequeue =
            _autoSyncAfterCurrent ||
            _hasPendingSyncChanges ||
            _hasPendingSettingsSync;
        _autoSyncAfterCurrent = false;
        if (shouldRequeue) {
          _requestAutoSync();
        }
      }
    }
    return syncCompleted;
  }

  Future<bool> _resolveConflicts(List<SyncConflictData> conflicts) async {
    final loc = AppLocalizations.of(context);
    for (final conflict in conflicts) {
      final decision = await _showConflictDialog(conflict);
      if (decision == null) {
        return false;
      }
      await _syncEngine.applyResolution(conflict, decision);
    }
    if (mounted) {
      _showSnackBar(loc.syncConflictResolved);
    }
    return true;
  }

  Future<ConflictDecision?> _showConflictDialog(SyncConflictData conflict) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final String deviceTitle = _conflictTitle(
      context,
      conflict,
      isDevice: true,
      loc: loc,
    );
    final String serverTitle = _conflictTitle(
      context,
      conflict,
      isDevice: false,
      loc: loc,
    );
    DateTime? deviceUpdated;
    switch (conflict.collection) {
      case 'notes':
        deviceUpdated = conflict.note?.updatedAt;
        break;
      case 'tasks':
        deviceUpdated = conflict.task?.updatedAt;
        break;
      case 'time_entries':
        deviceUpdated = conflict.timeEntry?.updatedAt;
        break;
      case 'settings':
        deviceUpdated = conflict.settingsUpdatedAt;
        break;
      default:
        deviceUpdated = null;
        break;
    }
    final DateTime serverUpdated = conflict.server.updatedAt;

    return showDialog<ConflictDecision>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.syncConflictTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.syncConflictMessage),
              const SizedBox(height: 16),
              _buildConflictTile(
                context: context,
                label: loc.syncConflictDeviceLabel,
                title: deviceTitle,
                updatedAt: deviceUpdated,
                theme: theme,
              ),
              const SizedBox(height: 12),
              _buildConflictTile(
                context: context,
                label: loc.syncConflictServerLabel,
                title: serverTitle,
                updatedAt: serverUpdated,
                theme: theme,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(ConflictDecision.keepServer),
              child: Text(loc.syncConflictKeepServer),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(ConflictDecision.keepLocal),
              child: Text(loc.syncConflictKeepLocal),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConflictTile({
    required BuildContext context,
    required String label,
    required String title,
    required ThemeData theme,
    DateTime? updatedAt,
  }) {
    final subtitle = updatedAt == null
        ? null
        : _formatDateTime(context, updatedAt.toLocal());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.bodyMedium),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(subtitle, style: theme.textTheme.bodySmall),
          ),
      ],
    );
  }

  String _conflictTitle(
    BuildContext context,
    SyncConflictData conflict, {
    required bool isDevice,
    required AppLocalizations loc,
  }) {
    if (conflict.collection == 'notes') {
      if (isDevice) {
        final note = conflict.note;
        if (note == null || note.title.trim().isEmpty) {
          return loc.notesUntitled;
        }
        return note.title;
      }
      final serverTitle = conflict.serverPayload['title'] as String?;
      if (serverTitle == null || serverTitle.trim().isEmpty) {
        return loc.notesUntitled;
      }
      return serverTitle;
    }

    if (conflict.collection == 'time_entries') {
      if (isDevice) {
        final entry = conflict.timeEntry;
        if (entry == null) {
          return loc.timeTrackingFormTitle;
        }
        final start = _formatDateTime(context, entry.startedAt.toLocal());
        final duration = formatTrackedMinutes(entry.durationMinutes);
        return '$start • $duration';
      }
      final serverStartRaw = conflict.serverPayload['startedAt'];
      DateTime? serverStart;
      if (serverStartRaw is String && serverStartRaw.isNotEmpty) {
        serverStart = DateTime.tryParse(serverStartRaw)?.toLocal();
      }
      final durationRaw = conflict.serverPayload['durationMinutes'];
      final String? duration = durationRaw is num
          ? formatTrackedMinutes(durationRaw.toInt())
          : null;
      final startText =
          serverStart == null ? loc.timeTrackingFormTitle : _formatDateTime(
            context,
            serverStart,
          );
      if (duration == null || duration.isEmpty) {
        return startText;
      }
      return '$startText • $duration';
    }

    if (conflict.collection == 'settings') {
      return loc.settingsGeneralTitle;
    }

    if (isDevice) {
      return conflict.task?.title ?? '';
    }
    return conflict.serverPayload['title'] as String? ?? '';
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  AuthenticatedUser? _readCurrentUser(Box<dynamic> box) {
    final Object? raw = box.get('auth_user');
    if (raw is! Map) {
      return null;
    }

    final Map<String, dynamic> normalized = raw.map(
      (key, dynamic value) => MapEntry(key.toString(), value),
    );
    return AuthenticatedUser.fromJson(normalized);
  }

  void _onSelectSection(_AppSection section) {
    if (!_visibleNavigationSections.contains(section)) {
      return;
    }
    if (_selectedSection == section) {
      return;
    }
    setState(() {
      _selectedSection = section;
    });
  }

  void _openNotes({String? tag}) {
    if (_notesTagFilter != tag) {
      setState(() {
        _notesTagFilter = tag;
      });
    }
    _onSelectSection(_AppSection.notes);
  }

  String _userDisplayName(AppLocalizations loc, AuthenticatedUser? user) {
    return user?.displayLabel ?? loc.guestUserName;
  }

  String _userEmail(AppLocalizations loc, AuthenticatedUser? user) {
    return user?.email ?? loc.guestUserEmail;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: _trackerBox.listenable(
        keys: const <String>['auth_token', 'auth_user'],
      ),
      builder: (context, box, _) {
        final String? authToken = box.get('auth_token') as String?;
        final AuthenticatedUser? currentUser = _readCurrentUser(box);
        final bool isLoggedIn = authToken != null && currentUser != null;
        final loc = AppLocalizations.of(context);

        return StreamBuilder<List<GreetingEntry>>(
          stream: _database.watchGreetingEntries(),
          builder: (context, snapshot) {
            final List<GreetingEntry> entries =
                snapshot.data ?? const <GreetingEntry>[];
            final bool isHistoryLoading =
                snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData;

            final bool useNavigationRail =
                MediaQuery.of(context).size.width >= 900;

            return Scaffold(
              appBar: AppBar(
                title: Text(_localizedSectionTitle(loc, _selectedSection)),
                actions: [
                  if (_selectedSection == _AppSection.dashboard &&
                      (entries.isNotEmpty || isHistoryLoading))
                    IconButton(
                      tooltip: loc.navClearHistory,
                      onPressed: (isHistoryLoading || entries.isEmpty)
                          ? null
                          : _clearHistory,
                      icon: const Icon(Icons.delete_sweep),
                    ),
                  IconButton(
                    tooltip: isLoggedIn ? loc.navLogout : loc.settingsOpenLogin,
                    onPressed: isLoggedIn
                        ? (_isAuthInProgress ? null : _handleLogout)
                        : () => _onSelectSection(_AppSection.settings),
                    icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                  ),
                ],
              ),
              drawer: useNavigationRail
                  ? null
                  : _buildDrawer(
                      context,
                      loc,
                      isLoggedIn,
                      currentUser,
                      entries,
                    ),
              body: Row(
                children: [
                  if (useNavigationRail)
                    _buildNavigationRail(context, loc, isLoggedIn, currentUser),
                  if (useNavigationRail) const VerticalDivider(width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildSection(
                        context,
                        loc,
                        entries,
                        currentUser,
                        isLoggedIn,
                        isHistoryLoading: isHistoryLoading,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context,
    AppLocalizations loc,
    List<GreetingEntry> entries,
    AuthenticatedUser? currentUser,
    bool isLoggedIn, {
    required bool isHistoryLoading,
  }) {
    switch (_selectedSection) {
      case _AppSection.dashboard:
        return _buildDashboard(context, loc);
      case _AppSection.notes:
        return _buildNotes(context);
      case _AppSection.tasks:
        return _buildTasks(context);
      case _AppSection.timeTracking:
        return _buildTimeTracking(context);
      case _AppSection.journal:
        return _buildJournal(context);
      case _AppSection.habits:
        return _buildHabits(context);
      case _AppSection.ledger:
        return _buildLedger(context);
      case _AppSection.settings:
        return _buildSettings(
          context,
          loc,
          entries,
          isHistoryLoading,
          isLoggedIn,
        );
    }
  }

  Widget _buildDashboard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final List<_AppSection> modules = _moduleOrder
        .where((section) => section != _AppSection.dashboard)
        .where(_enabledModules.contains)
        .toList();

    final bool showTasksSummary = _enabledModules.contains(_AppSection.tasks);
    final bool showTimeTracking = _enabledModules.contains(
      _AppSection.timeTracking,
    );

    if (!showTasksSummary && modules.isEmpty) {
      return Center(
        child: Text(
          loc.settingsModulesDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final children = <Widget>[];
    if (showTasksSummary) {
      children.add(_buildTasksSummaryCard(context, loc));
      children.add(const SizedBox(height: 16));
      modules.remove(_AppSection.tasks);
    }
    if (showTimeTracking) {
      children.add(_buildTimeTrackingDashboardCard(context, loc));
      children.add(const SizedBox(height: 16));
      modules.remove(_AppSection.timeTracking);
    }
    if (modules.isNotEmpty) {
      children.add(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: modules.map((section) {
            switch (section) {
              case _AppSection.notes:
                return _buildNotesDashboardCard(context, loc);
              case _AppSection.journal:
                return _buildJournalDashboardCard(context, loc);
              case _AppSection.habits:
                return _buildHabitsDashboardCard(context, loc);
              case _AppSection.ledger:
                return _buildLedgerDashboardCard(context, loc);
              default:
                return _buildModuleCard(context, loc, section);
            }
          }).toList(),
        ),
      );
    }

    return ListView(padding: const EdgeInsets.all(16), children: children);
  }

  Future<void> _promptCreateHabit(BuildContext context) async {
    if (_isHabitCreationInProgress) {
      return;
    }
    final result = await showHabitFormDialog(context: context);
    if (result == null) {
      return;
    }
    setState(() {
      _isHabitCreationInProgress = true;
    });
    try {
      await _database.createHabit(
        name: result.name,
        description: result.description,
        interval: result.interval,
        measurementKind: result.measurementKind,
        targetOccurrences: result.targetOccurrences,
        targetValue: result.targetValue,
      );
      if (!context.mounted) {
        return;
      }
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.habitsCreateSuccess(result.name))),
      );
    } finally {
      if (context.mounted) {
        setState(() {
          _isHabitCreationInProgress = false;
        });
      } else {
        _isHabitCreationInProgress = false;
      }
    }
  }

  Widget _buildNotesDashboardCard(BuildContext context, AppLocalizations loc) {
    return StreamBuilder<List<NoteEntry>>(
      stream: _database.watchNoteEntries(),
      builder: (context, snapshot) {
        final notes = snapshot.data ?? const <NoteEntry>[];
        final tagCounts = <String, int>{};
        for (final note in notes) {
          final tags = note.tags
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty);
          for (final tag in tags) {
            tagCounts.update(tag, (value) => value + 1, ifAbsent: () => 1);
          }
        }
        final List<MapEntry<String, int>> topTags = tagCounts.entries.toList()
          ..sort((a, b) {
            final countCompare = b.value.compareTo(a.value);
            if (countCompare != 0) {
              return countCompare;
            }
            return a.key.toLowerCase().compareTo(b.key.toLowerCase());
          });
        final displayedTags = topTags.take(3).toList();
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _openNotes(tag: _notesTagFilter),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _sectionIcon(_AppSection.notes),
                          size: 32,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _localizedSectionTitle(loc, _AppSection.notes),
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.dashboardNotesCount(notes.length),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      loc.dashboardNotesTopTags,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    if (displayedTags.isEmpty)
                      Text(
                        loc.dashboardNotesNoTags,
                        style: theme.textTheme.bodyMedium,
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: displayedTags
                            .map(
                              (entry) => ActionChip(
                                label: Text('${entry.key} (${entry.value})'),
                                onPressed: () => _openNotes(tag: entry.key),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildJournalDashboardCard(
    BuildContext context,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final bool isLocked = _journalProtectionEnabled && !_journalUnlocked;

    Widget buildLockedCard() {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        loc.navJournal,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  loc.journalDashboardLocked,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => _onSelectSection(_AppSection.journal),
                  child: Text(loc.journalDashboardOpenButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isLocked) {
      return buildLockedCard();
    }

    final categories = _journalEnabledCategories.isEmpty
        ? <JournalCategory>[JournalCategory.personal]
        : _journalEnabledCategories
            .toList()
              ..sort((a, b) => a.index.compareTo(b.index));
    final JournalCategory activeCategory = categories.first;

    return StreamBuilder<JournalEntry?>(
      stream: _database.watchJournalEntryForDate(today, activeCategory),
      builder: (context, snapshot) {
        final entry = snapshot.data;
        final String? content = entry?.content;
        final bool hasEntry = content != null && content.trim().isNotEmpty;
        final icon = hasEntry ? Icons.check_circle : Icons.edit_note;
        final Color iconColor = hasEntry
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary;
        final String statusText = hasEntry
            ? loc.journalDashboardEntryDone
            : loc.journalDashboardEntryMissing;

        String? updatedText;
        if (hasEntry && entry?.updatedAt != null) {
          updatedText = loc.journalLastUpdated(
            _formatDateTime(context, entry!.updatedAt),
          );
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _onSelectSection(_AppSection.journal),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 32, color: iconColor),
                        const SizedBox(width: 16),
                        Expanded(
                        child: Text(
                            '${loc.navJournal} • ${_journalCategoryLabel(loc, activeCategory)}',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(statusText, style: theme.textTheme.bodyMedium),
                    if (updatedText != null) ...[
                      const SizedBox(height: 4),
                      Text(updatedText, style: theme.textTheme.bodySmall),
                    ],
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => _onSelectSection(_AppSection.journal),
                      child: Text(loc.journalDashboardOpenButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTasksSummaryCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final card = StreamBuilder<List<TaskEntry>>(
      stream: _database.watchTaskEntries(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? const <TaskEntry>[];
        final totalTasks = tasks.length;
        final inProgressTasks = tasks
            .where((task) => task.status == TaskStatus.inProgress)
            .length;
        final highPriorityTasks = tasks
            .where((task) => task.priority == TaskPriority.high)
            .length;
        final sortedTasks = List<TaskEntry>.from(tasks)
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
        final now = DateTime.now();
        TaskEntry? nextDue;
        for (final task in sortedTasks) {
          if (!task.dueDate.isBefore(now)) {
            nextDue = task;
            break;
          }
        }
        nextDue ??= sortedTasks.isEmpty ? null : sortedTasks.first;
        final nextDueTitle = nextDue == null || nextDue.title.trim().isEmpty
            ? loc.dashboardTasksNoUpcoming
            : loc.dashboardTasksNextDue(
                nextDue.title.trim(),
                _formatDate(context, nextDue.dueDate),
              );

        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 656),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _sectionIcon(_AppSection.tasks),
                        size: 32,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          loc.dashboardTasksSummaryTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: loc.dashboardOpenTasksTooltip,
                        onPressed: () => _onSelectSection(_AppSection.tasks),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.dashboardTasksTotal(totalTasks),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.dashboardTasksInProgress(inProgressTasks),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.dashboardTasksHighPriority(highPriorityTasks),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(nextDueTitle, style: theme.textTheme.labelLarge),
                ],
              ),
            ),
          ),
        );
      },
    );

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 656),
        child: card,
      ),
    );
  }

  Widget _buildHabitsDashboardCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildCard(List<Widget> content) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 360),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _sectionIcon(_AppSection.habits),
                      size: 32,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _localizedSectionTitle(loc, _AppSection.habits),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: loc.navHabits,
                      onPressed: () => _onSelectSection(_AppSection.habits),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...content,
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _onSelectSection(_AppSection.habits),
                      icon: const Icon(Icons.auto_graph),
                      label: Text(loc.navHabits),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isHabitCreationInProgress
                          ? null
                          : () => _promptCreateHabit(context),
                      icon: _isHabitCreationInProgress
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: Text(loc.habitsAddHabitButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StreamBuilder<List<HabitDefinition>>(
      stream: _database.watchHabits(),
      builder: (context, habitsSnapshot) {
        final habits = habitsSnapshot.data ?? const <HabitDefinition>[];
        final bool loadingHabits =
            habitsSnapshot.connectionState == ConnectionState.waiting &&
            habits.isEmpty;

        if (habits.isEmpty) {
          final body = <Widget>[
            if (loadingHabits)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Text(loc.dashboardHabitsEmpty, style: theme.textTheme.bodyMedium),
          ];
          return buildCard(body);
        }

        return StreamBuilder<List<HabitLog>>(
          stream: _database.watchAllHabitLogs(),
          builder: (context, logsSnapshot) {
            final logs = logsSnapshot.data ?? const <HabitLog>[];
            final now = DateTime.now();
            final entries = habits.map((habit) {
              final habitLogs = logs
                  .where((log) => log.habitId == habit.id)
                  .toList();
              final period = periodForHabit(habit, now);
              final periodLogs = habitLogs
                  .where((log) => period.contains(log.occurredAt))
                  .toList();
              final total = sumLogsForPeriod(habitLogs, period);
              double? targetValue = habitTargetValue(habit);
              final bool hasTarget = targetValue != null && targetValue > 0;
              double ratio;
              if (hasTarget) {
                final double effectiveTarget = targetValue;
                ratio = total / effectiveTarget;
              } else {
                ratio = periodLogs.isNotEmpty ? 1.0 : 0.0;
              }
              if (!ratio.isFinite) {
                ratio = 0;
              }
              final double progress = ratio.clamp(0.0, 1.0).toDouble();
              final bool onTrack = hasTarget
                  ? ratio >= 1.0 - 1e-6
                  : periodLogs.isNotEmpty;
              final label = habitProgressLabel(
                loc: loc,
                habit: habit,
                periodLogs: periodLogs,
                numericTotal: total,
              );
              return (
                habit: habit,
                progress: progress,
                ratio: ratio,
                onTrack: onTrack,
                label: label,
              );
            }).toList();

            if (entries.isEmpty) {
              final body = <Widget>[
                Text(
                  loc.dashboardHabitsEmpty,
                  style: theme.textTheme.bodyMedium,
                ),
              ];
              return buildCard(body);
            }

            entries.sort((a, b) => a.ratio.compareTo(b.ratio));
            final topEntries = entries.take(3).toList();
            final onTrackCount = entries.where((entry) => entry.onTrack).length;
            final summaryStyle = onTrackCount == habits.length
                ? theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium;

            final content = <Widget>[
              Text(
                loc.dashboardHabitsOnTrack(onTrackCount, habits.length),
                style: summaryStyle,
              ),
            ];

            if (topEntries.isNotEmpty) {
              content.add(const SizedBox(height: 12));
              for (var i = 0; i < topEntries.length; i++) {
                final entry = topEntries[i];
                content.add(
                  _buildHabitDashboardRow(
                    context: context,
                    habit: entry.habit,
                    label: entry.label,
                    progress: entry.progress,
                    onTrack: entry.onTrack,
                  ),
                );
                if (i != topEntries.length - 1) {
                  content.add(const SizedBox(height: 12));
                }
              }
            }

            if (entries.length > topEntries.length) {
              content.add(const SizedBox(height: 12));
              content.add(
                Text(loc.habitsOpenDetails, style: theme.textTheme.bodySmall),
              );
            }

            return buildCard(content);
          },
        );
      },
    );
  }

  Widget _buildLedgerDashboardCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final numberFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 360),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onSelectSection(_AppSection.ledger),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<List<LedgerAccount>>(
              stream: _database.watchLedgerAccounts(),
              builder: (context, accountSnapshot) {
                final accounts =
                    accountSnapshot.data ?? const <LedgerAccount>[];
                return StreamBuilder<List<LedgerTransaction>>(
                  stream: _database.watchLedgerTransactions(),
                  builder: (context, transactionSnapshot) {
                    final transactions =
                        transactionSnapshot.data ?? const <LedgerTransaction>[];
                    if (accounts.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLedgerDashboardHeader(theme, colorScheme, loc),
                          const SizedBox(height: 12),
                          Text(
                            loc.ledgerDashboardNoAccounts,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      );
                    }
                    final accountSnapshots = buildAccountSnapshots(
                      accounts: accounts,
                      transactions: transactions,
                    );
                    final summary = buildDashboardSummary(
                      accounts: accountSnapshots,
                    );
                    return StreamBuilder<List<LedgerBudget>>(
                      stream: _database.watchLedgerBudgets(),
                      builder: (context, budgetSnapshot) {
                        final budgets =
                            budgetSnapshot.data ?? const <LedgerBudget>[];
                        return StreamBuilder<List<LedgerCategory>>(
                          stream: _database.watchAllLedgerCategories(),
                          builder: (context, categorySnapshot) {
                            final categories =
                                categorySnapshot.data ??
                                const <LedgerCategory>[];
                            final usages = buildBudgetUsage(
                              budgets: budgets,
                              transactions: transactions,
                              categories: categories,
                            );
                            final filteredUsages = _filterCurrentBudgetUsages(
                              usages,
                            );
                            final prioritized = filteredUsages.isNotEmpty
                                ? filteredUsages
                                : usages;
                            final sortedUsages = prioritized.toList()
                              ..sort((a, b) {
                                final ratioA = a.budget.amount <= 0
                                    ? 0.0
                                    : a.actualAmount / a.budget.amount;
                                final ratioB = b.budget.amount <= 0
                                    ? 0.0
                                    : b.actualAmount / b.budget.amount;
                                return ratioB.compareTo(ratioA);
                              });
                            final displayedBudgets = sortedUsages
                                .take(3)
                                .toList();
                            final categoryById = <int, LedgerCategory>{
                              for (final category in categories)
                                category.id: category,
                            };

                            final children = <Widget>[
                              _buildLedgerDashboardHeader(
                                theme,
                                colorScheme,
                                loc,
                              ),
                              const SizedBox(height: 12),
                            ];

                            if (summary.netWorthByCurrency.isEmpty) {
                              children.add(
                                Text(
                                  loc.ledgerDashboardNoNetWorth,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            } else {
                              children.add(
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: summary.netWorthByCurrency.entries
                                      .map(
                                        (entry) => Chip(
                                          avatar: const Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 16,
                                          ),
                                          label: Text(
                                            '${entry.key} ${numberFormat.format(entry.value)}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }

                            if (summary.plannedIncomeByCurrency.isNotEmpty) {
                              children.add(const SizedBox(height: 8));
                              children.add(
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: summary
                                      .plannedIncomeByCurrency
                                      .entries
                                      .map(
                                        (entry) => Chip(
                                          avatar: const Icon(
                                            Icons.trending_up,
                                            size: 16,
                                          ),
                                          label: Text(
                                            loc.ledgerDashboardPlannedIncomeChip(
                                              entry.key,
                                              numberFormat.format(entry.value),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }

                            if (summary.plannedExpensesByCurrency.isNotEmpty) {
                              children.add(const SizedBox(height: 8));
                              children.add(
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: summary
                                      .plannedExpensesByCurrency
                                      .entries
                                      .map(
                                        (entry) => Chip(
                                          avatar: const Icon(
                                            Icons.trending_down,
                                            size: 16,
                                          ),
                                          label: Text(
                                            loc.ledgerDashboardPlannedExpenseChip(
                                              entry.key,
                                              numberFormat.format(entry.value),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }

                            children.add(const SizedBox(height: 12));
                            children.add(
                              Text(
                                loc.ledgerDashboardBudgetsTitle,
                                style: theme.textTheme.titleSmall,
                              ),
                            );

                            if (displayedBudgets.isEmpty) {
                              children.add(
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    loc.ledgerDashboardNoBudgets,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              );
                            } else {
                              for (final usage in displayedBudgets) {
                                final budget = usage.budget;
                                final categoryName =
                                    categoryById[budget.categoryId]?.name ??
                                    loc.ledgerBudgetUnknownCategory;
                                final progress = budget.amount <= 0
                                    ? 0.0
                                    : (usage.actualAmount / budget.amount)
                                          .clamp(0, 1)
                                          .toDouble();
                                children.add(const SizedBox(height: 8));
                                children.add(
                                  Text(
                                    categoryName,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                );
                                children.add(const SizedBox(height: 4));
                                children.add(
                                  LinearProgressIndicator(value: progress),
                                );
                                children.add(const SizedBox(height: 4));
                                children.add(
                                  Text(
                                    loc.ledgerBudgetUsageSummary(
                                      usage.actualAmount.toStringAsFixed(2),
                                      budget.amount.toStringAsFixed(2),
                                      budget.currencyCode,
                                    ),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                );
                                if (usage.plannedAmount > 0) {
                                  children.add(
                                    Text(
                                      loc.ledgerBudgetPlannedAmount(
                                        usage.plannedAmount.toStringAsFixed(2),
                                        budget.currencyCode,
                                      ),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  );
                                }
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLedgerDashboardHeader(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations loc,
  ) {
    return Row(
      children: [
        Icon(
          _sectionIcon(_AppSection.ledger),
          size: 32,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            _localizedSectionTitle(loc, _AppSection.ledger),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  List<LedgerBudgetUsage> _filterCurrentBudgetUsages(
    List<LedgerBudgetUsage> usages,
  ) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final currentQuarter = ((currentMonth - 1) ~/ 3) + 1;
    return usages.where((usage) {
      final budget = usage.budget;
      switch (budget.periodKind) {
        case LedgerBudgetPeriodKind.monthly:
          if (budget.month == null) {
            return false;
          }
          return budget.year == currentYear && budget.month == currentMonth;
        case LedgerBudgetPeriodKind.quarterly:
          final budgetQuarter = ((budget.month ?? 1) - 1) ~/ 3 + 1;
          return budget.year == currentYear && budgetQuarter == currentQuarter;
        case LedgerBudgetPeriodKind.yearly:
          return budget.year == currentYear;
      }
    }).toList();
  }

  Widget _buildHabitDashboardRow({
    required BuildContext context,
    required HabitDefinition habit,
    required String label,
    required double progress,
    required bool onTrack,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color progressColor = onTrack
        ? colorScheme.primary
        : colorScheme.tertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                habit.name,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              onTrack ? Icons.check_circle : Icons.flag_outlined,
              size: 18,
              color: progressColor,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0).toDouble(),
            minHeight: 6,
            color: progressColor,
            backgroundColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildTimeTrackingDashboardCard(
    BuildContext context,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final today = DateTime.now();
    final selectedDay = DateTime(today.year, today.month, today.day);
    return StreamBuilder<List<TimeEntry>>(
      stream: _database.watchAllTimeEntries(),
      builder: (context, snapshot) {
        final entries = snapshot.data ?? const <TimeEntry>[];
        final summary = TimeTrackingSummary.fromEntries(
          entries: entries,
          selectedDay: selectedDay,
          rounding: _timeTrackingRounding,
          targetMode: _timeTrackingTargetMode,
          dailyTargetMinutes: _timeTrackingDailyTargetMinutes,
          weeklyTargetMinutes: _timeTrackingWeeklyTargetMinutes,
        );
        final hasActive = entries.any((entry) => entry.endedAt == null);
        final dateFormat = DateFormat.yMMMMd(loc.localeName);
        final todayLabel = loc.timeTrackingDashboardToday(
          formatTrackedMinutes(summary.dailyWorkMinutes),
        );
        final weekLabel = loc.timeTrackingDashboardWeek(
          dateFormat.format(summary.weekStart),
          dateFormat.format(summary.weekEnd),
          formatTrackedMinutes(summary.weeklyWorkMinutes),
        );

        String deltaLabel;
        switch (_timeTrackingTargetMode) {
          case TimeTrackingTargetMode.none:
            deltaLabel = loc.timeTrackingDashboardNoTarget;
            break;
          case TimeTrackingTargetMode.daily:
            deltaLabel = loc.timeTrackingDashboardDeltaDaily(
              formatTrackedMinutes(
                summary.deltaMinutes ?? 0,
                includeSign: true,
              ),
            );
            break;
          case TimeTrackingTargetMode.weekly:
            deltaLabel = loc.timeTrackingDashboardDeltaWeekly(
              formatTrackedMinutes(
                summary.deltaMinutes ?? 0,
                includeSign: true,
              ),
            );
            break;
        }

        return Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 656),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _sectionIcon(_AppSection.timeTracking),
                          size: 32,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            loc.timeTrackingDashboardTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: loc.timeTrackingDashboardOpenModule,
                          onPressed: () =>
                              _onSelectSection(_AppSection.timeTracking),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(todayLabel, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(weekLabel, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(deltaLabel, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: hasActive
                              ? null
                              : () => _startTimeTrackingNow(context),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(loc.timeTrackingStartNowButton),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: hasActive
                              ? () => _stopTimeTrackingNow(context)
                              : null,
                          icon: const Icon(Icons.stop),
                          label: Text(loc.timeTrackingStopNowButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    AppLocalizations loc,
    _AppSection section,
  ) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onSelectSection(section),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  _sectionIcon(section),
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _localizedSectionTitle(loc, section),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return NotesPage(
      database: _database,
      initialTag: _notesTagFilter,
      onTagFilterChanged: (tag) {
        if (_notesTagFilter == tag) {
          return;
        }
        setState(() {
          _notesTagFilter = tag;
        });
      },
    );
  }

  Widget _buildTasks(BuildContext context) {
    return TasksPage(
      database: _database,
      timeTrackingRounding: _timeTrackingRounding,
    );
  }

  Widget _buildTimeTracking(BuildContext context) {
    return TimeTrackingPage(
      database: _database,
      rounding: _timeTrackingRounding,
      targetMode: _timeTrackingTargetMode,
      dailyTargetMinutes: _timeTrackingDailyTargetMinutes,
      weeklyTargetMinutes: _timeTrackingWeeklyTargetMinutes,
      onStartTracking: _startTimeTrackingNow,
      onStopTracking: _stopTimeTrackingNow,
    );
  }

  Widget _buildJournal(BuildContext context) {
    if (_journalProtectionEnabled && !_journalUnlocked) {
      return JournalLockView(
        hasPin: _hasJournalPin,
        biometricEnabled: _journalBiometricEnabled,
        onValidatePin: _verifyJournalPin,
        onBiometricUnlock: _journalBiometricEnabled
            ? (ctx) => _attemptJournalBiometricUnlock(ctx)
            : null,
        onUnlocked: () {
          if (!_journalUnlocked) {
            setState(() {
              _journalUnlocked = true;
            });
          }
        },
      );
    }
    final enabledCategories = _journalEnabledCategories.isEmpty
        ? <JournalCategory>[JournalCategory.personal]
        : _journalEnabledCategories
            .toList()
              ..sort((a, b) => a.index.compareTo(b.index));
    return JournalPage(
      database: _database,
      templates: {
        JournalCategory.personal: _journalTemplatePersonal,
        JournalCategory.work: _journalTemplateWork,
      },
      enabledCategories: enabledCategories,
      initialCategory: enabledCategories.first,
      showLockButton: _journalProtectionEnabled,
      onLock: _journalProtectionEnabled ? _lockJournal : null,
    );
  }

  Widget _buildHabits(BuildContext context) {
    return HabitsPage(database: _database);
  }

  Widget _buildLedger(BuildContext context) {
    return LedgerPage(database: _database);
  }

  Widget _buildSettings(
    BuildContext context,
    AppLocalizations loc,
    List<GreetingEntry> entries,
    bool isHistoryLoading,
    bool isLoggedIn,
  ) {
    if (!isLoggedIn) {
      return _buildGuestSettings(context, loc);
    }
    return _buildMemberSettings(context, loc, entries, isHistoryLoading);
  }

  Widget _buildGuestSettings(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLanguageCard(context, loc),
        const SizedBox(height: 24),
        _buildAppearanceCard(context, loc),
        const SizedBox(height: 24),
        _buildModulesCard(context, loc),
        const SizedBox(height: 24),
        _buildJournalSettingsCard(context, loc),
        const SizedBox(height: 24),
        _buildTimeTrackingSettingsCard(context, loc),
        const SizedBox(height: 24),
        _buildSyncInfoCard(context, loc),
        const SizedBox(height: 24),
        Text(loc.settingsSignInPrompt, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        _buildAuthTabsCard(context, loc),
      ],
    );
  }

  Widget _buildMemberSettings(
    BuildContext context,
    AppLocalizations loc,
    List<GreetingEntry> entries,
    bool isHistoryLoading,
  ) {
    final children = <Widget>[
      _buildMembershipCard(context, loc),
      const SizedBox(height: 24),
      _buildAppearanceCard(context, loc),
      const SizedBox(height: 24),
      _buildModulesCard(context, loc),
      const SizedBox(height: 24),
      _buildJournalSettingsCard(context, loc),
      const SizedBox(height: 24),
      _buildTimeTrackingSettingsCard(context, loc),
      const SizedBox(height: 24),
      _buildLanguageCard(context, loc),
    ];
    if (entries.isNotEmpty || isHistoryLoading) {
      children.addAll([
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: isHistoryLoading ? null : _clearHistory,
          icon: const Icon(Icons.delete_sweep),
          label: Text(loc.navClearHistory),
        ),
      ]);
    }
    return ListView(padding: const EdgeInsets.all(16), children: children);
  }

  Widget _buildMembershipCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final status = _membershipStatus;
    final bool isActive = status?.isActive ?? false;
    final bool syncEnabled = status?.syncEnabled ?? false;
    final int? remainingDays =
        isActive ? status?.remainingDays : null;

    String statusText;
    if (status == null) {
      statusText = loc.membershipStatusUnknown;
    } else if (isActive && status.membershipExpiresAt != null) {
      statusText = loc.membershipStatusActive(
        _formatDate(context, status.membershipExpiresAt!),
      );
    } else {
      statusText = loc.membershipStatusInactive;
    }

    final String syncText = syncEnabled
        ? loc.membershipSyncEnabled
        : loc.membershipSyncDisabled;
    final String? lastPaymentText = status?.paymentMethodLabel(loc);
    final String? retentionText = status?.syncRetentionUntil != null
        ? loc.membershipRetentionInfo(
            _formatDate(context, status!.syncRetentionUntil!),
          )
        : null;

    final String monthlyPrice = _formatCurrency(
      context,
      status?.priceMonthly ?? 1.0,
    );
    final String yearlyPrice = _formatCurrency(
      context,
      status?.priceYearly ?? 10.0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.membershipSectionTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                if (_isMembershipLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(statusText, style: theme.textTheme.titleMedium),
            if (remainingDays != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.membershipDaysRemaining(remainingDays),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(syncText, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              loc.settingsSyncMembershipInfo,
              style: theme.textTheme.bodySmall,
            ),
            if (lastPaymentText != null) ...[
              const SizedBox(height: 8),
              Text(
                loc.membershipLastPayment(lastPaymentText),
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (retentionText != null) ...[
              const SizedBox(height: 8),
              Text(retentionText, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            Text(
              loc.membershipActionsTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildSubscriptionRow(
              context,
              loc.membershipSubscribeMonthly(monthlyPrice),
              monthly: true,
            ),
            const SizedBox(height: 12),
            _buildSubscriptionRow(
              context,
              loc.membershipSubscribeYearly(yearlyPrice),
              monthly: false,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (syncEnabled)
                  FilledButton.icon(
                    onPressed: !_syncEngine.isReady || _isSyncInProgress
                        ? null
                        : _handleSyncNow,
                    icon: _isSyncInProgress
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    label: Text(
                      !_syncEngine.isReady
                          ? loc.syncNotReady
                          : _isSyncInProgress
                          ? loc.syncInProgress
                          : loc.syncNowButton,
                    ),
                  ),
                FilledButton.tonal(
                  onPressed: _isMembershipLoading || _isSyncInProgress
                      ? null
                      : _cancelMembership,
                  child: Text(loc.membershipCancelButton),
                ),
                OutlinedButton(
                  onPressed: _isMembershipLoading || _isSyncInProgress
                      ? null
                      : _deleteSyncedData,
                  child: Text(loc.membershipDeleteDataButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final modeOptions = <({ThemeMode mode, String label, IconData icon})>[
      (
        mode: ThemeMode.system,
        label: loc.settingsThemeModeSystem,
        icon: Icons.brightness_auto,
      ),
      (
        mode: ThemeMode.light,
        label: loc.settingsThemeModeLight,
        icon: Icons.light_mode_outlined,
      ),
      (
        mode: ThemeMode.dark,
        label: loc.settingsThemeModeDark,
        icon: Icons.dark_mode_outlined,
      ),
    ];
    final colorOptions = <Color>[
      Colors.blue,
      Colors.teal,
      Colors.deepPurple,
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
    ];
    if (!colorOptions.any((color) => color == _pendingSeedColor)) {
      colorOptions.add(_pendingSeedColor);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settingsAppearanceSectionTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              loc.settingsThemeModeLabel,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...modeOptions.map(
              (option) => RadioListTile<ThemeMode>(
                value: option.mode,
                groupValue: _pendingThemeMode,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _pendingThemeMode = value;
                  });
                  widget.onThemeModeChanged(value);
                },
                secondary: Icon(option.icon),
                title: Text(option.label),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.settingsSeedColorLabel,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.settingsSeedColorDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colorOptions.map((color) {
                final bool isSelected = color == _pendingSeedColor;
                final brightness = ThemeData.estimateBrightnessForColor(color);
                final iconColor = brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _pendingSeedColor = color;
                    });
                    widget.onSeedColorChanged(color);
                  },
                  child: Tooltip(
                    message:
                        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.2,
                                ),
                          width: isSelected ? 3 : 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, color: iconColor, size: 20)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTrackingSettingsCard(
    BuildContext context,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.timeTrackingSettingsTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              loc.timeTrackingSettingsRoundingLabel,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TimeTrackingRounding.values
                  .map(
                    (mode) => ChoiceChip(
                      label: Text(_roundingLabel(loc, mode)),
                      selected: _timeTrackingRounding == mode,
                      onSelected: (_) => _updateTimeTrackingRounding(mode),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              loc.timeTrackingSettingsTargetLabel,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<TimeTrackingTargetMode>(
              segments: [
                ButtonSegment(
                  value: TimeTrackingTargetMode.none,
                  label: Text(loc.timeTrackingSettingsTargetNone),
                ),
                ButtonSegment(
                  value: TimeTrackingTargetMode.daily,
                  label: Text(loc.timeTrackingSettingsTargetDaily),
                ),
                ButtonSegment(
                  value: TimeTrackingTargetMode.weekly,
                  label: Text(loc.timeTrackingSettingsTargetWeekly),
                ),
              ],
              selected: <TimeTrackingTargetMode>{_timeTrackingTargetMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  _updateTimeTrackingTargetMode(selection.first);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dailyTargetController,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: loc.timeTrackingSettingsDailyHoursLabel,
              ),
              onSubmitted: (_) => _submitDailyTarget(context, loc),
              onTapOutside: (_) => _submitDailyTarget(context, loc),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _weeklyTargetController,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: loc.timeTrackingSettingsWeeklyHoursLabel,
              ),
              onSubmitted: (_) => _submitWeeklyTarget(context, loc),
              onTapOutside: (_) => _submitWeeklyTarget(context, loc),
            ),
            const SizedBox(height: 12),
            Text(
              loc.timeTrackingSettingsDurationHint,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _roundingLabel(AppLocalizations loc, TimeTrackingRounding rounding) {
    switch (rounding) {
      case TimeTrackingRounding.minute:
        return loc.timeTrackingRoundingMinute;
      case TimeTrackingRounding.fiveMinutes:
        return loc.timeTrackingRoundingFive;
      case TimeTrackingRounding.tenMinutes:
        return loc.timeTrackingRoundingTen;
      case TimeTrackingRounding.quarterHour:
        return loc.timeTrackingRoundingQuarter;
    }
  }

  Widget _buildModulesCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final sections = _moduleOrder;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settingsModulesSectionTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              loc.settingsModulesDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(loc.settingsModulesDragHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: sections.length,
              onReorder: _handleModuleReorder,
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final section = sections[index];
                final title = _localizedSectionTitle(loc, section);
                final bool enabled = _enabledModules.contains(section);
                return ListTile(
                  key: ValueKey<String>('module_${section.name}'),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  title: Text(title),
                  trailing: Switch(
                    value: enabled,
                    onChanged: (value) => _handleModuleToggle(section, value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleModuleToggle(_AppSection section, bool enabled) {
    setState(() {
      if (enabled) {
        _enabledModules.add(section);
      } else {
        _enabledModules.remove(section);
        final visible = _visibleNavigationSections;
        if (!visible.contains(_selectedSection)) {
          _selectedSection = visible.first;
        }
      }
    });
    _persistModuleSettings();
  }

  void _handleModuleReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final section = _moduleOrder.removeAt(oldIndex);
      _moduleOrder.insert(newIndex, section);
    });
    _persistModuleSettings();
  }

  Future<String> _hashJournalPin(String pin, String salt) async {
    final algorithm = Sha256();
    final data = utf8.encode('$salt:$pin');
    final hash = await algorithm.hash(data);
    return base64UrlEncode(hash.bytes);
  }

  String _generateJournalSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  Future<bool> _verifyJournalPin(String pin) async {
    if (!_hasJournalPin || pin.isEmpty) {
      return false;
    }
    final salt = _journalPinSalt!;
    final expectedHash = _journalPinHash!;
    final computed = await _hashJournalPin(pin, salt);
    return computed == expectedHash;
  }

  void _lockJournal() {
    if (!_journalProtectionEnabled) {
      return;
    }
    setState(() {
      _journalUnlocked = false;
    });
  }

  Future<bool> _attemptJournalBiometricUnlock(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool supported = await _localAuth.isDeviceSupported();
      if (!canCheck || !supported) {
        if (!mounted) {
          return false;
        }
        messenger.showSnackBar(
          SnackBar(content: Text(loc.journalBiometricUnavailable)),
        );
        return false;
      }
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: loc.journalBiometricPrompt,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated && mounted) {
        setState(() {
          _journalUnlocked = true;
        });
        messenger.showSnackBar(
          SnackBar(content: Text(loc.journalUnlockSuccess)),
        );
      }
      return authenticated;
    } on PlatformException {
      if (!mounted) {
        return false;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(loc.journalBiometricError)),
      );
      return false;
    }
  }

  TextEditingController _journalTemplateControllerFor(
    JournalCategory category,
  ) {
    switch (category) {
      case JournalCategory.personal:
        return _journalTemplatePersonalController;
      case JournalCategory.work:
        return _journalTemplateWorkController;
    }
  }

  Future<void> _persistJournalTemplate({
    required JournalCategory category,
    required String value,
  }) async {
    final String storageKey = switch (category) {
      JournalCategory.personal => journalTemplatePersonalKey,
      JournalCategory.work => journalTemplateWorkKey,
    };
    await _trackerBox.put(storageKey, value);
    if (category == JournalCategory.personal) {
      await _trackerBox.put(journalTemplateKey, value);
    }
    _markSettingsDirty();
    if (!mounted) {
      if (category == JournalCategory.personal) {
        _journalTemplatePersonal = value;
      } else {
        _journalTemplateWork = value;
      }
      return;
    }
    setState(() {
      if (category == JournalCategory.personal) {
        _journalTemplatePersonal = value;
      } else {
        _journalTemplateWork = value;
      }
    });
  }

  Future<void> _persistJournalCategories(
    Set<JournalCategory> categories,
  ) async {
    await _trackerBox.put(
      journalEnabledCategoriesKey,
      categories.map((category) => category.name).toList(),
    );
    _markSettingsDirty();
    if (!mounted) {
      _journalEnabledCategories = categories;
      return;
    }
    setState(() {
      _journalEnabledCategories = categories;
    });
  }

  Future<void> _setJournalCategoryEnabled(
    BuildContext context,
    JournalCategory category,
    bool enabled,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context);
    final updated = Set<JournalCategory>.from(_journalEnabledCategories);
    if (enabled) {
      if (updated.add(category)) {
        await _persistJournalCategories(updated);
      }
      return;
    }
    if (!updated.contains(category)) {
      return;
    }
    if (updated.length == 1) {
      messenger.showSnackBar(
        SnackBar(content: Text(loc.journalCategoryDisableLastError)),
      );
      return;
    }
    updated.remove(category);
    await _persistJournalCategories(updated);
  }

  Future<void> _saveJournalTemplate(
    BuildContext context,
    JournalCategory category,
  ) async {
    final controller = _journalTemplateControllerFor(category);
    final template = controller.text;
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context);
    await _persistJournalTemplate(category: category, value: template);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          loc.journalTemplateSavedFor(
            _journalCategoryLabel(loc, category),
          ),
        ),
      ),
    );
  }

  Future<void> _clearJournalTemplate(
    BuildContext context,
    JournalCategory category,
  ) async {
    final controller = _journalTemplateControllerFor(category);
    controller.clear();
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context);
    await _persistJournalTemplate(category: category, value: '');
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          loc.journalTemplateClearedFor(
            _journalCategoryLabel(loc, category),
          ),
        ),
      ),
    );
  }

  Future<void> _promptSetJournalPin(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final formKey = GlobalKey<FormState>();
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    bool pinVisible = false;
    bool confirmVisible = false;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  title: Text(
                    _hasJournalPin
                        ? loc.journalChangePinDialogTitle
                        : loc.journalSetPinDialogTitle,
                  ),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          obscureText: !pinVisible,
                          decoration: InputDecoration(
                            labelText: loc.journalNewPinLabel,
                            suffixIcon: IconButton(
                              icon: Icon(
                                pinVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setStateDialog(() {
                                  pinVisible = !pinVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            final pin = value?.trim() ?? '';
                            if (!RegExp(r'^\d{4,12}$').hasMatch(pin)) {
                              return loc.journalPinValidationError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmController,
                          keyboardType: TextInputType.number,
                          obscureText: !confirmVisible,
                          decoration: InputDecoration(
                            labelText: loc.journalConfirmPinLabel,
                            suffixIcon: IconButton(
                              icon: Icon(
                                confirmVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setStateDialog(() {
                                  confirmVisible = !confirmVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value?.trim() != pinController.text.trim()) {
                              return loc.journalPinMismatchError;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(loc.commonCancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        Navigator.of(context).pop(true);
                      },
                      child: Text(loc.commonSave),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
    if (!confirmed) {
      return;
    }

    final pin = pinController.text.trim();
    final salt = _generateJournalSalt();
    final hash = await _hashJournalPin(pin, salt);
    await _trackerBox.put(journalPinSaltKey, salt);
    await _trackerBox.put(journalPinHashKey, hash);
    _markSettingsDirty();
    if (!mounted) {
      return;
    }
    setState(() {
      _journalPinSalt = salt;
      _journalPinHash = hash;
      _journalUnlocked = false;
    });
    messenger.showSnackBar(SnackBar(content: Text(loc.journalPinSetSuccess)));
  }

  Future<void> _promptRemoveJournalPin(BuildContext context) async {
    if (!_hasJournalPin) {
      return;
    }
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pinController = TextEditingController();
    bool invalid = false;

    final shouldRemove =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  title: Text(loc.journalRemovePinTitle),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.journalRemovePinDescription),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: loc.journalCurrentPinLabel,
                        ),
                      ),
                      if (invalid) ...[
                        const SizedBox(height: 8),
                        Text(
                          loc.journalRemovePinError,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(loc.commonCancel),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final pin = pinController.text.trim();
                        final valid = await _verifyJournalPin(pin);
                        if (!valid) {
                          setStateDialog(() {
                            invalid = true;
                          });
                          return;
                        }
                        navigator.pop(true);
                      },
                      child: Text(loc.journalRemovePinButton),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
    if (!shouldRemove) {
      return;
    }
    await _trackerBox.delete(journalPinHashKey);
    await _trackerBox.delete(journalPinSaltKey);
    _markSettingsDirty();
    if (!mounted) {
      return;
    }
    setState(() {
      _journalPinHash = null;
      _journalPinSalt = null;
      if (!_journalBiometricEnabled) {
        _journalUnlocked = true;
      }
    });
    messenger.showSnackBar(SnackBar(content: Text(loc.journalPinRemoved)));
  }

  Future<void> _toggleJournalBiometric(BuildContext context, bool value) async {
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (value) {
      final supported = await _localAuth.isDeviceSupported();
      final available = await _localAuth.canCheckBiometrics;
      if (!supported || !available) {
        messenger.showSnackBar(
          SnackBar(content: Text(loc.journalBiometricUnavailable)),
        );
        return;
      }
    }
    await _trackerBox.put(journalBiometricEnabledKey, value);
    _markSettingsDirty();
    if (!mounted) {
      return;
    }
    setState(() {
      _journalBiometricEnabled = value;
      if (value) {
        _journalUnlocked = false;
      } else if (!_hasJournalPin) {
        _journalUnlocked = true;
      }
    });
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          value
              ? loc.journalBiometricEnabledMessage
              : loc.journalBiometricDisabledMessage,
        ),
      ),
    );
  }

  void _lockJournalNow(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_journalProtectionEnabled) {
      messenger.showSnackBar(
        SnackBar(content: Text(loc.journalNoProtectionConfigured)),
      );
      return;
    }
    _lockJournal();
    messenger.showSnackBar(SnackBar(content: Text(loc.journalLockedNotice)));
  }

  Widget _buildSyncInfoCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settingsSyncInfoTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              loc.settingsSyncInfoDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.settingsSyncMembershipInfo,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalSettingsCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final hasPin = _hasJournalPin;
    final protectionEnabled = _journalProtectionEnabled;
    final locked = protectionEnabled && !_journalUnlocked;
    final personalEnabled =
        _journalEnabledCategories.contains(JournalCategory.personal);
    final workEnabled =
        _journalEnabledCategories.contains(JournalCategory.work);

    Widget buildTemplateEditor(JournalCategory category, bool enabled) {
      final controller = _journalTemplateControllerFor(category);
      final label = _journalCategoryLabel(loc, category);
      final templateEmpty = controller.text.trim().isEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.journalTemplateSectionTitle(label),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: 8,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: loc.journalTemplateLabelFor(label),
              hintText: loc.journalTemplateHintFor(label),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: enabled
                    ? () => _saveJournalTemplate(context, category)
                    : null,
                icon: const Icon(Icons.save),
                label: Text(loc.commonSave),
              ),
              OutlinedButton.icon(
                onPressed: enabled && !templateEmpty
                    ? () => _clearJournalTemplate(context, category)
                    : null,
                icon: const Icon(Icons.clear),
                label: Text(loc.journalTemplateClear),
              ),
            ],
          ),
        ],
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.journalSettingsTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              loc.journalSettingsDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              loc.journalCategoriesTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.journalCategoriesDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: personalEnabled,
              onChanged: (value) => _setJournalCategoryEnabled(
                context,
                JournalCategory.personal,
                value,
              ),
              title: Text(loc.journalCategoryPersonal),
              subtitle: Text(loc.journalCategoryPersonalDescription),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: workEnabled,
              onChanged: (value) => _setJournalCategoryEnabled(
                context,
                JournalCategory.work,
                value,
              ),
              title: Text(loc.journalCategoryWork),
              subtitle: Text(loc.journalCategoryWorkDescription),
            ),
            const SizedBox(height: 16),
            buildTemplateEditor(JournalCategory.personal, personalEnabled),
            const SizedBox(height: 24),
            buildTemplateEditor(JournalCategory.work, workEnabled),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                hasPin ? loc.journalPinStatusSet : loc.journalPinStatusUnset,
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                hasPin
                    ? loc.journalPinStatusDescription
                    : loc.journalPinStatusDescriptionUnset,
              ),
              trailing: FilledButton(
                onPressed: () => _promptSetJournalPin(context),
                child: Text(
                  hasPin ? loc.journalChangePinButton : loc.journalSetPinButton,
                ),
              ),
            ),
            if (hasPin)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => _promptRemoveJournalPin(context),
                  child: Text(loc.journalRemovePinButton),
                ),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _journalBiometricEnabled,
              onChanged: (value) => _toggleJournalBiometric(context, value),
              title: Text(loc.journalBiometricToggleTitle),
              subtitle: Text(loc.journalBiometricToggleSubtitle),
              secondary: const Icon(Icons.fingerprint),
            ),
            const SizedBox(height: 12),
            if (protectionEnabled)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: locked ? null : () => _lockJournalNow(context),
                    icon: const Icon(Icons.lock),
                    label: Text(loc.journalLockNowButton),
                  ),
                  Text(
                    locked
                        ? loc.journalLockedStatus
                        : loc.journalUnlockedStatus,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            else
              Text(
                loc.journalProtectionDisabledHint,
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthTabsCard(BuildContext context, AppLocalizations loc) {
    return DefaultTabController(
      length: 2,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    icon: const Icon(Icons.lock_open),
                    text: loc.loginTabSignIn,
                  ),
                  Tab(
                    icon: const Icon(Icons.person_add),
                    text: loc.loginTabRegister,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 360,
                child: TabBarView(
                  children: [
                    _buildLoginForm(context),
                    _buildRegisterForm(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionRow(
    BuildContext context,
    String title, {
    required bool monthly,
  }) {
    final loc = AppLocalizations.of(context);
    final bool disabled = _isMembershipLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            FilledButton(
              onPressed: disabled
                  ? null
                  : () => _subscribeToPlan(
                      monthly ? 'monthly' : 'yearly',
                      'paypal',
                    ),
              child: Text(loc.membershipPayWithPaypal),
            ),
            OutlinedButton(
              onPressed: disabled
                  ? null
                  : () => _subscribeToPlan(
                      monthly ? 'monthly' : 'yearly',
                      'bitcoin',
                    ),
              child: Text(loc.membershipPayWithBitcoin),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final Map<Locale, String> languageLabels = <Locale, String>{
      const Locale('en'): loc.settingsLanguageEnglish,
      const Locale('de'): loc.settingsLanguageGerman,
      const Locale('sv'): loc.settingsLanguageSwedish,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settingsLanguageSectionTitle,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              loc.settingsLanguageDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            DropdownButton<Locale>(
              value: _pendingLocale,
              items: supportedAppLocales
                  .map(
                    (locale) => DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(
                        languageLabels[locale] ?? locale.languageCode,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (Locale? locale) {
                if (locale == null) {
                  return;
                }
                setState(() {
                  _pendingLocale = locale;
                });
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => widget.onLocaleChanged(_pendingLocale),
              child: Text(loc.settingsLanguageApply),
            ),
            const SizedBox(height: 12),
            Text(
              loc.settingsCurrentLanguage(
                languageLabels[_pendingLocale] ?? _pendingLocale.languageCode,
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthError(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _authErrorMessage ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(loc.loginHeading, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: loc.loginEmailLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _loginPasswordController,
            obscureText: !_loginPasswordVisible,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!_isAuthInProgress) {
                _handleLogin();
              }
            },
            decoration: InputDecoration(
              labelText: loc.loginPasswordLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
                icon: Icon(
                  _loginPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_authErrorMessage != null) _buildAuthError(context),
          FilledButton.icon(
            onPressed: _isAuthInProgress ? null : _handleLogin,
            icon: _isAuthInProgress
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.lock_open),
            label: Text(
              _isAuthInProgress ? loc.authStatusSubmitting : loc.loginButton,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isAuthInProgress
                ? null
                : () => _showGooglePlaceholder(context),
            icon: const Icon(Icons.g_translate),
            label: Text(loc.loginGoogleButton),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.registerHeading,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: loc.loginEmailLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _registerDisplayNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: loc.registerDisplayNameLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _registerPasswordController,
            obscureText: !_registerPasswordVisible,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!_isAuthInProgress) {
                _handleRegister();
              }
            },
            decoration: InputDecoration(
              labelText: loc.registerPasswordLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _registerPasswordVisible = !_registerPasswordVisible;
                  });
                },
                icon: Icon(
                  _registerPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_authErrorMessage != null) _buildAuthError(context),
          FilledButton.icon(
            onPressed: _isAuthInProgress ? null : _handleRegister,
            icon: _isAuthInProgress
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.person_add),
            label: Text(
              _isAuthInProgress ? loc.authStatusSubmitting : loc.registerButton,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isAuthInProgress
                ? null
                : () => _showGooglePlaceholder(context),
            icon: const Icon(Icons.g_translate),
            label: Text(loc.registerGoogleButton),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(
    BuildContext context,
    AppLocalizations loc,
    bool isLoggedIn,
    AuthenticatedUser? currentUser,
    List<GreetingEntry> entries,
  ) {
    final String userLabel = _userDisplayName(loc, currentUser);
    final String userEmail = _userEmail(loc, currentUser);
    final String initial = userLabel.trim().isNotEmpty
        ? userLabel.trim().substring(0, 1).toUpperCase()
        : '?';
    final sections = _visibleNavigationSections;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Text(initial)),
              accountName: Text(userLabel),
              accountEmail: Text(userEmail),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                loc.navigationMenu,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: sections
                    .map(
                      (section) => ListTile(
                        leading: Icon(_sectionIcon(section)),
                        title: Text(_localizedSectionTitle(loc, section)),
                        selected: _selectedSection == section,
                        onTap: () {
                          Navigator.of(context).pop();
                          _onSelectSection(section);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: Text(loc.navClearHistory),
              enabled: entries.isNotEmpty,
              onTap: entries.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _clearHistory();
                    },
            ),
            ListTile(
              leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
              title: Text(isLoggedIn ? loc.navLogout : loc.settingsOpenLogin),
              onTap: () {
                Navigator.of(context).pop();
                if (isLoggedIn) {
                  if (!_isAuthInProgress) {
                    _handleLogout();
                  }
                } else {
                  _onSelectSection(_AppSection.settings);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  NavigationRail _buildNavigationRail(
    BuildContext context,
    AppLocalizations loc,
    bool isLoggedIn,
    AuthenticatedUser? currentUser,
  ) {
    final String userLabel = _userDisplayName(loc, currentUser);
    final String initial = userLabel.trim().isNotEmpty
        ? userLabel.trim().substring(0, 1).toUpperCase()
        : '?';
    final sections = _visibleNavigationSections;
    final int selectedIndex = sections
        .indexOf(_selectedSection)
        .clamp(0, sections.length - 1);

    return NavigationRail(
      selectedIndex: selectedIndex,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Tooltip(
              message: userLabel,
              child: CircleAvatar(child: Text(initial)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 88,
              child: Text(
                userLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        tooltip: isLoggedIn ? loc.navLogout : loc.settingsOpenLogin,
        icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
        onPressed: isLoggedIn
            ? (_isAuthInProgress ? null : _handleLogout)
            : () => _onSelectSection(_AppSection.settings),
      ),
      onDestinationSelected: (index) => _onSelectSection(sections[index]),
      destinations: sections
          .map(
            (section) => NavigationRailDestination(
              icon: Icon(_sectionIcon(section)),
              selectedIcon: Icon(_sectionSelectedIcon(section)),
              label: Text(_localizedSectionTitle(loc, section)),
            ),
          )
          .toList(),
    );
  }

  String _localizedSectionTitle(AppLocalizations loc, _AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return loc.navDashboard;
      case _AppSection.notes:
        return loc.navNotes;
      case _AppSection.tasks:
        return loc.navTasks;
      case _AppSection.timeTracking:
        return loc.navTimeTracking;
      case _AppSection.journal:
        return loc.navJournal;
      case _AppSection.habits:
        return loc.navHabits;
      case _AppSection.ledger:
        return loc.navLedger;
      case _AppSection.settings:
        return loc.navSettings;
    }
  }

  String _journalCategoryLabel(
    AppLocalizations loc,
    JournalCategory category,
  ) {
    switch (category) {
      case JournalCategory.personal:
        return loc.journalCategoryPersonal;
      case JournalCategory.work:
        return loc.journalCategoryWork;
    }
  }

  IconData _sectionIcon(_AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return Icons.dashboard_outlined;
      case _AppSection.notes:
        return Icons.note_alt_outlined;
      case _AppSection.tasks:
        return Icons.fact_check_outlined;
      case _AppSection.timeTracking:
        return Icons.access_time;
      case _AppSection.journal:
        return Icons.menu_book_outlined;
      case _AppSection.habits:
        return Icons.repeat;
      case _AppSection.ledger:
        return Icons.account_balance_wallet_outlined;
      case _AppSection.settings:
        return Icons.settings_outlined;
    }
  }

  IconData _sectionSelectedIcon(_AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return Icons.dashboard;
      case _AppSection.notes:
        return Icons.note_alt;
      case _AppSection.tasks:
        return Icons.fact_check;
      case _AppSection.timeTracking:
        return Icons.access_time_filled;
      case _AppSection.journal:
        return Icons.menu_book;
      case _AppSection.habits:
        return Icons.repeat;
      case _AppSection.ledger:
        return Icons.account_balance_wallet;
      case _AppSection.settings:
        return Icons.settings;
    }
  }

  String _formatDate(BuildContext context, DateTime timestamp) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(localeTag).format(timestamp.toLocal());
  }

  String _formatDateTime(BuildContext context, DateTime timestamp) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    final String dateText = DateFormat.yMMMd(
      localeTag,
    ).format(timestamp.toLocal());
    final String timeText = TimeOfDay.fromDateTime(
      timestamp.toLocal(),
    ).format(context);
    return '$dateText • $timeText';
  }

  String _formatCurrency(BuildContext context, double amount) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: localeTag,
      name: 'EUR',
    );
    return formatter.format(amount);
  }
}
