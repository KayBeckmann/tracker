// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracker/app/app.dart';
import 'package:tracker/core/storage/settings_repository.dart';
import 'package:tracker/features/settings/application/settings_controller.dart';
import 'package:tracker/features/settings/domain/app_settings.dart';

void main() {
  testWidgets('Tracker app renders the dashboard tab by default', (
    tester,
  ) async {
    final repository = _InMemorySettingsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
        child: const TrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}

class _InMemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = AppSettings.initial();

  @override
  AppSettings load() => _settings;

  @override
  Future<void> persist(AppSettings settings) async {
    _settings = settings;
  }
}
