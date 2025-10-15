import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'data/local/app_database.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/membership_status.dart';
import 'notes/notes_page.dart';

const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

const String trackerBoxName = 'tracker_box';
const String preferredLocaleKey = 'preferred_locale';
const String preferredThemeModeKey = 'preferred_theme_mode';
const String preferredSeedColorKey = 'preferred_seed_color';
const String enabledModulesKey = 'enabled_modules';
const String moduleOrderKey = 'module_order';

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
  }

  void _handleSeedColorChanged(Color color) {
    setState(() {
      _seedColor = color;
    });
    _settingsBox.put(preferredSeedColorKey, color.toARGB32());
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
  final TextEditingController _nameController = TextEditingController(
    text: 'Flutter',
  );
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerDisplayNameController =
      TextEditingController();

  late final AppDatabase _database;
  late final Box<dynamic> _trackerBox;
  Locale _pendingLocale = supportedAppLocales.first;
  ThemeMode _pendingThemeMode = ThemeMode.system;
  Color _pendingSeedColor = Colors.blue;

  String? _statusMessage;
  bool _isLoading = false;
  bool _isAuthInProgress = false;
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  String? _authErrorMessage;
  MembershipStatus? _membershipStatus;
  bool _isMembershipLoading = false;
  _AppSection _selectedSection = _AppSection.dashboard;
  late List<_AppSection> _moduleOrder;
  late Set<_AppSection> _enabledModules;

  @override
  void initState() {
    super.initState();
    _database = widget.database;
    _trackerBox = Hive.box(trackerBoxName);
    _pendingLocale = widget.currentLocale;
    _moduleOrder = List<_AppSection>.from(_defaultModuleOrder);
    _enabledModules = _defaultModuleOrder.toSet();
    _loadModuleSettings();
    _pendingThemeMode = widget.themeMode;
    _pendingSeedColor = widget.seedColor;

    final Object? token = _trackerBox.get('auth_token');
    final AuthenticatedUser? user = _readCurrentUser(_trackerBox);
    if (token is String && user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _refreshMembershipStatus();
        }
      });
    }
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
    _nameController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerDisplayNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchGreeting() async {
    final String name = _nameController.text.trim().isEmpty
        ? 'Flutter'
        : _nameController.text.trim();

    if (!mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
      _statusMessage = loc.statusSendingRequest(backendBaseUrl);
    });

    try {
      final Uri uri = Uri.parse(
        '$backendBaseUrl/api/greeting',
      ).replace(queryParameters: <String, String>{'name': name});
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode} ${response.reasonPhrase}');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final String message =
          data['message'] as String? ?? 'Unexpected response from server.';
      final String source = data['source'] as String? ?? 'unknown';

      await _database.insertGreetingEntry(
        name: name,
        message: message,
        source: source,
        createdAt: DateTime.now(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      final locAfterError = AppLocalizations.of(context);
      setState(() {
        _statusMessage = locAfterError.statusError('$error');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _clearHistory() async {
    await _database.clearGreetingEntries();
    if (!mounted) {
      return;
    }
    final loc = AppLocalizations.of(context);
    setState(() {
      _statusMessage = loc.statusHistoryCleared;
    });
  }

  Future<void> _handleLogout() async {
    await _trackerBox.delete('auth_token');
    await _trackerBox.delete('auth_user');
    if (!mounted) {
      return;
    }
    setState(() {
      _authErrorMessage = null;
      _membershipStatus = null;
      _selectedSection = _AppSection.dashboard;
      _statusMessage = null;
    });
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
  }

  void _persistModuleSettings() {
    final List<String> orderNames =
        _moduleOrder.map((section) => section.name).toList();
    _trackerBox.put(moduleOrderKey, orderNames);
    final List<String> enabledNames =
        _enabledModules.map((section) => section.name).toList();
    _trackerBox.put(enabledModulesKey, enabledNames);
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

  Future<void> _persistAuthResponse(Map<String, dynamic> data) async {
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
    if (mounted) {
      await _refreshMembershipStatus();
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
    );
  }

  Future<void> _submitAuthRequest({
    required BuildContext context,
    required AppLocalizations loc,
    required Uri uri,
    required Map<String, dynamic> payload,
    required bool expectsCreated,
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
      await _persistAuthResponse(data);

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

  Future<void> _refreshMembershipStatus() async {
    final String? token = _currentAuthToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _membershipStatus = null;
          _isMembershipLoading = false;
        });
      }
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
        return _buildDashboard(context, loc, entries, currentUser, isLoggedIn);
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

  Widget _buildDashboard(
    BuildContext context,
    AppLocalizations loc,
    List<GreetingEntry> entries,
    AuthenticatedUser? currentUser,
    bool isLoggedIn,
  ) {
    final theme = Theme.of(context);
    final GreetingEntry? latestEntry = entries.isNotEmpty
        ? entries.first
        : null;
    final String userLabel = _userDisplayName(loc, currentUser);
    final String userEmail = _userEmail(loc, currentUser);
    final bool syncEnabled = _membershipStatus?.syncEnabled ?? false;
    final bool membershipActive = _membershipStatus?.isActive ?? false;

    String statusValue;
    if (!isLoggedIn) {
      statusValue = loc.dashboardStatusGuest;
    } else if (_membershipStatus == null) {
      statusValue = loc.membershipStatusUnknown;
    } else if (membershipActive &&
        _membershipStatus?.membershipExpiresAt != null) {
      statusValue = loc.membershipStatusActiveShort(
        _formatDate(context, _membershipStatus!.membershipExpiresAt!),
      );
    } else if (syncEnabled) {
      statusValue = loc.membershipSyncEnabled;
    } else {
      statusValue = loc.membershipSyncDisabled;
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Text(
          loc.dashboardWelcome(userLabel),
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          isLoggedIn
              ? loc.dashboardSignedInAs(userEmail)
              : loc.dashboardGuestIntro,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricCard(
              context: context,
              icon: Icons.storage,
              title: loc.dashboardCardStoredResponses,
              value: entries.length.toString(),
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.chat_bubble_outline,
              title: loc.dashboardCardLatestMessage,
              value: latestEntry?.message ?? loc.dashboardLatestEntriesEmpty,
              subtitle: latestEntry != null
                  ? loc.historySubtitle(
                      latestEntry.name,
                      latestEntry.source,
                      _formatTimestamp(context, latestEntry.createdAt),
                    )
                  : null,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.cloud_queue,
              title: loc.dashboardCardBackendUrl,
              value: backendBaseUrl,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.account_circle_outlined,
              title: loc.dashboardCardUser,
              value: userLabel,
              subtitle: userEmail,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.info_outline,
              title: loc.dashboardCardStatus,
              value: _statusMessage ?? statusValue,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildCommunicationCard(context),
        const SizedBox(height: 24),
        if (!isLoggedIn) _buildGuestSyncCard(context),
        if (!isLoggedIn) const SizedBox(height: 24),
        _buildRecentResponsesCard(context, entries),
      ],
    );
  }

  Widget _buildGuestSyncCard(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.dashboardGuestSyncTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.dashboardGuestSyncDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _onSelectSection(_AppSection.settings),
              icon: const Icon(Icons.login),
              label: Text(loc.dashboardGuestSyncButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunicationCard(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.dashboardQuickActionTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.dashboardQuickActionDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.communicationBackendUrl(backendBaseUrl),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.communicationNameLabel,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchGreeting(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _fetchGreeting,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud),
                label: Text(
                  _isLoading
                      ? loc.dashboardQuickActionLoading
                      : loc.communicationButton,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _statusMessage ?? loc.statusNotContacted,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResponsesCard(
    BuildContext context,
    List<GreetingEntry> entries,
  ) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final List<GreetingEntry> displayEntries = entries.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.dashboardLatestEntriesTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (displayEntries.isEmpty)
              Text(
                loc.dashboardLatestEntriesEmpty,
                style: theme.textTheme.bodyMedium,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayEntries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = displayEntries[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(entry.message),
                    subtitle: Text(
                      loc.historySubtitle(
                        entry.name,
                        entry.source,
                        _formatTimestamp(context, entry.createdAt),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return NotesPage(database: _database);
  }

  Widget _buildTasks(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.tasksPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildTimeTracking(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.timeTrackingPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildJournal(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.journalPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildHabits(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.habitsPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildLedger(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.ledgerPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: children,
    );
  }

  Widget _buildMembershipCard(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);
    final status = _membershipStatus;
    final bool isActive = status?.isActive ?? false;
    final bool syncEnabled = status?.syncEnabled ?? false;

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
                FilledButton.tonal(
                  onPressed: _isMembershipLoading ? null : _cancelMembership,
                  child: Text(loc.membershipCancelButton),
                ),
                OutlinedButton(
                  onPressed: _isMembershipLoading ? null : _deleteSyncedData,
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
      (mode: ThemeMode.system, label: loc.settingsThemeModeSystem, icon: Icons.brightness_auto),
      (mode: ThemeMode.light, label: loc.settingsThemeModeLight, icon: Icons.light_mode_outlined),
      (mode: ThemeMode.dark, label: loc.settingsThemeModeDark, icon: Icons.dark_mode_outlined),
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
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.2),
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
            Text(
              loc.settingsModulesDragHint,
              style: theme.textTheme.bodySmall,
            ),
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
    final int selectedIndex = sections.indexOf(_selectedSection).clamp(0, sections.length - 1);

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
      onDestinationSelected: (index) =>
          _onSelectSection(sections[index]),
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

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
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

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(localeTag).add_Hms().format(timestamp.toLocal());
  }

  String _formatDate(BuildContext context, DateTime timestamp) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(localeTag).format(timestamp.toLocal());
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
