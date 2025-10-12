import 'dart:convert';

import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'data/local/app_database.dart';

const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

const String trackerBoxName = 'tracker_box';
const String preferredLocaleKey = 'preferred_locale';

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

  Box<dynamic> get _settingsBox => Hive.box(trackerBoxName);

  @override
  void initState() {
    super.initState();
    final String? storedLocale =
        _settingsBox.get(preferredLocaleKey) as String?;
    if (storedLocale != null && storedLocale.isNotEmpty) {
      _locale = Locale(storedLocale);
    }
  }

  void _handleLocaleChanged(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _settingsBox.put(preferredLocaleKey, locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(
        database: widget.database,
        currentLocale: _locale ?? supportedAppLocales.first,
        onLocaleChanged: _handleLocaleChanged,
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
  });

  final AppDatabase database;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _AppSection { dashboard, notes, tasks, habits, ledger, settings }

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

  String? _statusMessage;
  bool _isLoading = false;
  bool _isAuthInProgress = false;
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  String? _authErrorMessage;
  _AppSection _selectedSection = _AppSection.dashboard;

  @override
  void initState() {
    super.initState();
    _database = widget.database;
    _trackerBox = Hive.box(trackerBoxName);
    _pendingLocale = widget.currentLocale;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocale != oldWidget.currentLocale) {
      setState(() {
        _pendingLocale = widget.currentLocale;
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
    final loc = AppLocalizations.of(context);
    await _database.clearGreetingEntries();
    if (!mounted) {
      return;
    }
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
      _selectedSection = _AppSection.dashboard;
      _statusMessage = null;
    });
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
        if (!mounted) {
          return;
        }
        final String message = _extractBackendError(
          loc,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
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
      // Fallback to status-based messages below.
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
    if (_selectedSection == section) {
      return;
    }
    setState(() {
      _selectedSection = section;
    });
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

        if (authToken == null || currentUser == null) {
          return _buildAuthScaffold(context);
        }

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
            final loc = AppLocalizations.of(context);

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
                    tooltip: loc.navLogout,
                    onPressed: _isAuthInProgress ? null : _handleLogout,
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              drawer: useNavigationRail
                  ? null
                  : _buildDrawer(context, currentUser, entries),
              body: Row(
                children: [
                  if (useNavigationRail)
                    _buildNavigationRail(context, currentUser, entries),
                  if (useNavigationRail) const VerticalDivider(width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildSection(
                        context,
                        entries,
                        currentUser,
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

  Widget _buildAuthScaffold(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.appTitle),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.lock_open), text: loc.loginTabSignIn),
              Tab(
                icon: const Icon(Icons.person_add),
                text: loc.loginTabRegister,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildLoginForm(context), _buildRegisterForm(context)],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(loc.loginHeading, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.registerHeading,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
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

  Drawer _buildDrawer(
    BuildContext context,
    AuthenticatedUser currentUser,
    List<GreetingEntry> entries,
  ) {
    final loc = AppLocalizations.of(context);
    final String label = currentUser.displayLabel.trim();
    final String initial = label.isNotEmpty
        ? label.substring(0, 1).toUpperCase()
        : '?';

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Text(initial)),
              accountName: Text(currentUser.displayLabel),
              accountEmail: Text(currentUser.email),
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
                children: _AppSection.values
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
              leading: const Icon(Icons.logout),
              title: Text(loc.navLogout),
              onTap: _isAuthInProgress
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _handleLogout();
                    },
            ),
          ],
        ),
      ),
    );
  }

  NavigationRail _buildNavigationRail(
    BuildContext context,
    AuthenticatedUser currentUser,
    List<GreetingEntry> entries,
  ) {
    final loc = AppLocalizations.of(context);
    final String label = currentUser.displayLabel.trim();
    final String initial = label.isNotEmpty
        ? label.substring(0, 1).toUpperCase()
        : '?';

    return NavigationRail(
      selectedIndex: _selectedSection.index,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Tooltip(
              message: loc.navigationUserTooltip,
              child: CircleAvatar(child: Text(initial)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 88,
              child: Text(
                currentUser.displayLabel,
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
        tooltip: loc.navLogout,
        icon: const Icon(Icons.logout),
        onPressed: _isAuthInProgress ? null : _handleLogout,
      ),
      onDestinationSelected: (index) =>
          _onSelectSection(_AppSection.values[index]),
      destinations: _AppSection.values
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

  Widget _buildSection(
    BuildContext context,
    List<GreetingEntry> entries,
    AuthenticatedUser currentUser, {
    required bool isHistoryLoading,
  }) {
    switch (_selectedSection) {
      case _AppSection.dashboard:
        return _buildDashboard(context, entries, currentUser);
      case _AppSection.notes:
        return _buildNotes(context);
      case _AppSection.tasks:
        return _buildTasks(context);
      case _AppSection.habits:
        return _buildHabits(context);
      case _AppSection.ledger:
        return _buildLedger(context);
      case _AppSection.settings:
        return _buildSettings(context, entries, isHistoryLoading);
    }
  }

  Widget _buildDashboard(
    BuildContext context,
    List<GreetingEntry> entries,
    AuthenticatedUser currentUser,
  ) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final GreetingEntry? latestEntry = entries.isNotEmpty
        ? entries.first
        : null;

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Text(
          loc.dashboardWelcome(currentUser.displayLabel),
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          loc.dashboardSignedInAs(currentUser.email),
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
              value: currentUser.displayLabel,
              subtitle: currentUser.email,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.info_outline,
              title: loc.dashboardCardStatus,
              value: _statusMessage ?? loc.statusNotContacted,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildCommunicationCard(context),
        const SizedBox(height: 24),
        _buildRecentResponsesCard(context, entries),
      ],
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
    final loc = AppLocalizations.of(context);
    return Center(
      child: Text(
        loc.notesPlaceholder,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
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
    List<GreetingEntry> entries,
    bool isHistoryLoading,
  ) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final Map<Locale, String> languageLabels = <Locale, String>{
      const Locale('en'): loc.settingsLanguageEnglish,
      const Locale('de'): loc.settingsLanguageGerman,
      const Locale('sv'): loc.settingsLanguageSwedish,
    };

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Padding(
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
                        child: Text(languageLabels[locale]!),
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
                loc.settingsCurrentLanguage(languageLabels[_pendingLocale]!),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        if (entries.isNotEmpty || isHistoryLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 32),
                Text(loc.navClearHistory, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: isHistoryLoading ? null : _clearHistory,
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(loc.navClearHistory),
                ),
              ],
            ),
          ),
      ],
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
}
