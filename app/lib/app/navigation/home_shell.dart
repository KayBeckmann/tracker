import 'package:flutter/material.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:tracker/features/habits/presentation/pages/habits_page.dart';
import 'package:tracker/features/household/presentation/pages/household_page.dart';
import 'package:tracker/features/notes/presentation/pages/notes_page.dart';
import 'package:tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:tracker/features/tasks/presentation/pages/tasks_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  static final List<_NavigationDestination> _destinations = [
    _NavigationDestination(
      icon: Icons.dashboard_outlined,
      label: (l10n) => l10n.tabDashboard,
      page: const DashboardPage(),
    ),
    _NavigationDestination(
      icon: Icons.event_note_outlined,
      label: (l10n) => l10n.tabTasks,
      page: const TasksPage(),
    ),
    _NavigationDestination(
      icon: Icons.note_alt_outlined,
      label: (l10n) => l10n.tabNotes,
      page: const NotesPage(),
    ),
    _NavigationDestination(
      icon: Icons.flag_outlined,
      label: (l10n) => l10n.tabHabits,
      page: const HabitsPage(),
    ),
    _NavigationDestination(
      icon: Icons.account_balance_wallet_outlined,
      label: (l10n) => l10n.tabHousehold,
      page: const HouseholdPage(),
    ),
    _NavigationDestination(
      icon: Icons.settings_outlined,
      label: (l10n) => l10n.tabSettings,
      page: const SettingsPage(),
    ),
  ];

  void _handleDestinationSelected(int index) {
    if (index == _currentIndex) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWideLayout = MediaQuery.of(context).size.width >= 900;
    final destinations = _destinations;

    Widget buildDrawer() {
      return Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                child: Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final destination = destinations[index];
                    return ListTile(
                      leading: Icon(destination.icon),
                      title: Text(destination.label(l10n)),
                      selected: index == _currentIndex,
                      onTap: () {
                        Navigator.of(context).pop();
                        _handleDestinationSelected(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(destinations[_currentIndex].label(l10n))),
      drawer: isWideLayout ? null : buildDrawer(),
      body: Row(
        children: [
          if (isWideLayout)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _handleDestinationSelected,
              labelType: NavigationRailLabelType.selected,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: Icon(destination.icon),
                      label: Text(destination.label(l10n)),
                    ),
                  )
                  .toList(growable: false),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: destinations
                  .map((destination) => destination.page)
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationDestination {
  const _NavigationDestination({
    required this.icon,
    required this.label,
    required this.page,
  });

  final IconData icon;
  final String Function(AppLocalizations) label;
  final Widget page;
}
