import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tracker/core/storage/settings_repository.dart';
import 'package:tracker/features/settings/domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('SettingsRepository must be overridden');
});

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      final initialSettings = repository.load();
      return SettingsController(repository, initialSettings);
    });

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._repository, AppSettings initialState)
    : super(initialState);

  final SettingsRepository _repository;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.persist(state);
  }

  Future<void> setLanguageCode(String? languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _repository.persist(state);
  }

  Future<void> setSeedColor(Color color) async {
    state = state.copyWith(seedColor: color);
    await _repository.persist(state);
  }

  Future<void> setSyncEnabled(bool value) async {
    state = state.copyWith(syncEnabled: value);
    await _repository.persist(state);
  }

  Future<void> setAutoSyncEnabled(bool value) async {
    state = state.copyWith(autoSyncEnabled: value);
    await _repository.persist(state);
  }
}
