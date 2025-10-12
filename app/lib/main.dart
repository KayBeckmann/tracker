import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

const String trackerBoxName = 'tracker_box';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(trackerBoxName);
  runApp(const TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _AppSection { dashboard, communication, history }

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
    final createdAtRaw = json['created_at'];
    if (createdAtRaw is String) {
      parsedCreatedAt = DateTime.tryParse(createdAtRaw);
    }

    final idValue = json['id'];
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

  String get displayLabel =>
      (displayName != null && displayName!.trim().isNotEmpty)
      ? displayName!
      : email;
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
  late final Box<dynamic> _trackerBox;
  String _statusMessage = 'Backend wurde noch nicht kontaktiert.';
  bool _isLoading = false;
  bool _isAuthInProgress = false;
  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  String? _authErrorMessage;
  _AppSection _selectedSection = _AppSection.dashboard;

  @override
  void initState() {
    super.initState();
    _trackerBox = Hive.box(trackerBoxName);
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
    final name = _nameController.text.trim().isEmpty
        ? 'Flutter'
        : _nameController.text.trim();

    setState(() {
      _isLoading = true;
      _statusMessage = 'Sende Anfrage an $backendBaseUrl...';
    });

    try {
      final uri = Uri.parse(
        '$backendBaseUrl/api/greeting',
      ).replace(queryParameters: {'name': name});
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          'Fehlerhafte Antwort: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final message =
          data['message'] as String? ?? 'Unerwartete Antwort vom Server.';
      final source = data['source'] as String? ?? 'unbekannt';

      final entry = <String, dynamic>{
        'name': name,
        'message': message,
        'source': source,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _trackerBox.add(entry);

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = message;
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Fehler: $error';
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
    final keysToDelete = _trackerBox.keys.where((key) {
      if (key is! int) {
        return false;
      }
      final value = _trackerBox.get(key);
      return value is Map && value.containsKey('timestamp');
    }).toList();

    if (keysToDelete.isEmpty) {
      return;
    }

    await _trackerBox.deleteAll(keysToDelete);
    if (!mounted) {
      return;
    }
    setState(() {
      _statusMessage = 'Alle lokalen Einträge wurden gelöscht.';
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
      _statusMessage = 'Backend wurde noch nicht kontaktiert.';
    });
  }

  Future<void> _persistAuthResponse(Map<String, dynamic> data) async {
    final token = data['access_token'];
    final userRaw = data['user'];
    if (token is! String || token.isEmpty || userRaw is! Map) {
      throw Exception('Unerwartete Antwort vom Server.');
    }

    final userMap = userRaw.map(
      (key, dynamic value) => MapEntry(key.toString(), value),
    );

    await _trackerBox.put('auth_token', token);
    await _trackerBox.put('auth_user', userMap);
  }

  Future<void> _handleRegister() async {
    final email = _registerEmailController.text.trim();
    final password = _registerPasswordController.text;
    final displayName = _registerDisplayNameController.text.trim();

    if (email.isEmpty || password.length < 8) {
      setState(() {
        _authErrorMessage =
            'Bitte gib eine gültige E-Mail-Adresse und ein Passwort mit mindestens 8 Zeichen an.';
      });
      return;
    }

    final payload = <String, dynamic>{
      'email': email,
      'password': password,
      if (displayName.isNotEmpty) 'display_name': displayName,
    };

    await _submitAuthRequest(
      uri: Uri.parse('$backendBaseUrl/api/auth/register'),
      payload: payload,
      expectsCreated: true,
    );
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _authErrorMessage = 'Bitte gib E-Mail-Adresse und Passwort ein.';
      });
      return;
    }

    final payload = <String, dynamic>{'email': email, 'password': password};

    await _submitAuthRequest(
      uri: Uri.parse('$backendBaseUrl/api/auth/login'),
      payload: payload,
      expectsCreated: false,
    );
  }

  Future<void> _submitAuthRequest({
    required Uri uri,
    required Map<String, dynamic> payload,
    required bool expectsCreated,
  }) async {
    setState(() {
      _isAuthInProgress = true;
      _authErrorMessage = null;
    });

    try {
      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final bool success = expectsCreated
          ? response.statusCode == 201
          : response.statusCode == 200;

      if (!success) {
        final message = _extractBackendError(
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
        _authErrorMessage = 'Fehler bei der Anmeldung: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAuthInProgress = false;
        });
      }
    }
  }

  String _extractBackendError({
    required String responseBody,
    required int statusCode,
  }) {
    try {
      final dynamic body = jsonDecode(responseBody);
      if (body is Map<String, dynamic>) {
        final detail = body['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map && first['msg'] is String) {
            return first['msg'] as String;
          }
        }
      }
    } catch (_) {
      // Ignored: fallback below.
    }

    switch (statusCode) {
      case 400:
        return 'Die Anfrage war nicht gültig.';
      case 401:
        return 'Ungültige Zugangsdaten.';
      case 409:
        return 'Diese E-Mail-Adresse ist bereits registriert.';
      default:
        return 'Unerwarteter Fehler (Status $statusCode).';
    }
  }

  void _showGooglePlaceholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-In wird demnächst hinzugefügt.'),
      ),
    );
  }

  AuthenticatedUser? _readCurrentUser(Box<dynamic> box) {
    final raw = box.get('auth_user');
    if (raw is! Map) {
      return null;
    }

    final normalized = raw.map(
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
      valueListenable: _trackerBox.listenable(),
      builder: (context, box, _) {
        final String? authToken = box.get('auth_token') as String?;
        final AuthenticatedUser? currentUser = _readCurrentUser(box);

        final entries = box.values
            .whereType<Map>()
            .map<Map<String, dynamic>>(
              (value) =>
                  value.map((key, dynamic v) => MapEntry(key.toString(), v)),
            )
            .where((entry) => entry.containsKey('timestamp'))
            .toList()
            .reversed
            .toList();

        if (authToken == null || currentUser == null) {
          return _buildAuthScaffold(context);
        }

        final bool useNavigationRail = MediaQuery.of(context).size.width >= 900;

        return Scaffold(
          appBar: AppBar(
            title: Text(_sectionTitle(_selectedSection)),
            actions: [
              if (_selectedSection == _AppSection.history && entries.isNotEmpty)
                IconButton(
                  tooltip: 'Lokale Historie löschen',
                  onPressed: _clearHistory,
                  icon: const Icon(Icons.delete_sweep),
                ),
              IconButton(
                tooltip: 'Abmelden',
                onPressed: _isAuthInProgress ? null : _handleLogout,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: useNavigationRail ? null : _buildDrawer(context, currentUser),
          body: Row(
            children: [
              if (useNavigationRail) _buildNavigationRail(context, currentUser),
              if (useNavigationRail) const VerticalDivider(width: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSection(context, entries, currentUser),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthScaffold(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Willkommen bei Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lock_open), text: 'Anmelden'),
              Tab(icon: Icon(Icons.person_add), text: 'Registrieren'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Melde dich mit deiner E-Mail-Adresse und deinem Passwort an.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'E-Mail-Adresse',
              border: OutlineInputBorder(),
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
              labelText: 'Passwort',
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
            label: Text(_isAuthInProgress ? 'Wird gesendet...' : 'Anmelden'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isAuthInProgress
                ? null
                : () => _showGooglePlaceholder(context),
            icon: const Icon(Icons.g_translate),
            label: const Text('Mit Google anmelden (bald verfügbar)'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Erstelle ein neues Konto mit E-Mail-Adresse und Passwort.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'E-Mail-Adresse',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _registerDisplayNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Anzeigename (optional)',
              border: OutlineInputBorder(),
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
              labelText: 'Passwort (min. 8 Zeichen)',
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
              _isAuthInProgress ? 'Wird gesendet...' : 'Konto erstellen',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isAuthInProgress
                ? null
                : () => _showGooglePlaceholder(context),
            icon: const Icon(Icons.g_translate),
            label: const Text('Mit Google registrieren (bald verfügbar)'),
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

  Drawer _buildDrawer(BuildContext context, AuthenticatedUser currentUser) {
    final label = currentUser.displayLabel.trim();
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
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: _AppSection.values
                    .map(
                      (section) => ListTile(
                        leading: Icon(_sectionIcon(section)),
                        title: Text(_sectionTitle(section)),
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
              leading: const Icon(Icons.logout),
              title: const Text('Abmelden'),
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
  ) {
    final label = currentUser.displayLabel.trim();
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
            CircleAvatar(child: Text(initial)),
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
        tooltip: 'Abmelden',
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
              label: Text(_sectionTitle(section)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    List<Map<String, dynamic>> entries,
    AuthenticatedUser currentUser,
  ) {
    switch (_selectedSection) {
      case _AppSection.dashboard:
        return _buildDashboard(context, entries, currentUser);
      case _AppSection.communication:
        return _buildCommunication(context);
      case _AppSection.history:
        return _buildHistory(entries);
    }
  }

  Widget _buildDashboard(
    BuildContext context,
    List<Map<String, dynamic>> entries,
    AuthenticatedUser currentUser,
  ) {
    final theme = Theme.of(context);
    final Map<String, dynamic>? latestEntry = entries.isNotEmpty
        ? entries.first
        : null;

    return ListView(
      children: [
        Text(
          'Willkommen im Dashboard, ${currentUser.displayLabel}',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Angemeldet als ${currentUser.email}. Behalte deine Backend-Kommunikation im Blick und starte Aktionen direkt von hier.',
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
              title: 'Gespeicherte Antworten',
              value: entries.length.toString(),
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.chat_bubble_outline,
              title: 'Letzte Nachricht',
              value:
                  latestEntry?['message'] as String? ??
                  'Noch keine Nachrichten gespeichert.',
              subtitle: latestEntry != null
                  ? 'Quelle: ${latestEntry['source'] ?? 'unbekannt'}'
                  : null,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.cloud_queue,
              title: 'Backend-URL',
              value: backendBaseUrl,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.account_circle_outlined,
              title: 'Benutzer',
              value: currentUser.displayLabel,
              subtitle: currentUser.email,
            ),
            _buildMetricCard(
              context: context,
              icon: Icons.info_outline,
              title: 'Status',
              value: _statusMessage,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Schnelle Aktion', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Hole eine neue Begrüßung vom Backend und speichere sie lokal.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _fetchGreeting,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_download),
                    label: Text(
                      _isLoading ? 'Wird geladen...' : 'Backend kontaktieren',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunication(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Text(
          'Basiskommunikation mit dem Backend',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Aktuelle Backend-URL: $backendBaseUrl',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
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
              _isLoading ? 'Wird geladen...' : 'Backend kontaktieren',
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(_statusMessage, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildHistory(List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('Es sind noch keine gespeicherten Antworten vorhanden.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final ts = entry['timestamp'] as String? ?? '';
        final name = entry['name'] as String? ?? '-';
        final source = entry['source'] as String? ?? 'unbekannt';
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(entry['message'] as String? ?? ''),
          subtitle: Text('Name: $name, Quelle: $source, Zeit: $ts'),
        );
      },
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

  String _sectionTitle(_AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return 'Dashboard';
      case _AppSection.communication:
        return 'Kommunikation';
      case _AppSection.history:
        return 'Historie';
    }
  }

  IconData _sectionIcon(_AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return Icons.dashboard_outlined;
      case _AppSection.communication:
        return Icons.cloud_outlined;
      case _AppSection.history:
        return Icons.history;
    }
  }

  IconData _sectionSelectedIcon(_AppSection section) {
    switch (section) {
      case _AppSection.dashboard:
        return Icons.dashboard;
      case _AppSection.communication:
        return Icons.cloud;
      case _AppSection.history:
        return Icons.history;
    }
  }
}
