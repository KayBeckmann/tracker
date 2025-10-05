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

  static final List<_NavigationTab> _tabs = [
    _NavigationTab(
      icon: Icons.dashboard_outlined,
      label: (l10n) => l10n.tabDashboard,
      page: const DashboardPage(),
    ),
    _NavigationTab(
      icon: Icons.event_note_outlined,
      label: (l10n) => l10n.tabTasks,
      page: const TasksPage(),
    ),
    _NavigationTab(
      icon: Icons.note_alt_outlined,
      label: (l10n) => l10n.tabNotes,
      page: const NotesPage(),
    ),
    _NavigationTab(
      icon: Icons.flag_outlined,
      label: (l10n) => l10n.tabHabits,
      page: const HabitsPage(),
    ),
    _NavigationTab(
      icon: Icons.account_balance_wallet_outlined,
      label: (l10n) => l10n.tabHousehold,
      page: const HouseholdPage(),
    ),
    _NavigationTab(
      icon: Icons.settings_outlined,
      label: (l10n) => l10n.tabSettings,
      page: const SettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_tabs[_currentIndex].label(l10n))),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) => tab.page).toList(growable: false),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.label(l10n),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _NavigationTab {
  const _NavigationTab({
    required this.icon,
    required this.label,
    required this.page,
  });

  final IconData icon;
  final String Function(AppLocalizations) label;
  final Widget page;
}
