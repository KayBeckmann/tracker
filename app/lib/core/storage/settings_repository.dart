import 'package:hive_flutter/hive_flutter.dart';

import 'package:tracker/features/settings/domain/app_settings.dart';

abstract class SettingsRepository {
  AppSettings load();
  Future<void> persist(AppSettings settings);
}

class HiveSettingsRepository implements SettingsRepository {
  HiveSettingsRepository(this._box);

  static const _boxName = 'settings_box';
  static const _settingsKey = 'settings';

  final Box<dynamic> _box;

  static Future<HiveSettingsRepository> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_boxName);
    return HiveSettingsRepository(box);
  }

  @override
  AppSettings load() {
    final data = _box.get(_settingsKey) as Map<dynamic, dynamic>?;
    return AppSettings.fromMap(data);
  }

  @override
  Future<void> persist(AppSettings settings) async {
    await _box.put(_settingsKey, settings.toMap());
  }
}
