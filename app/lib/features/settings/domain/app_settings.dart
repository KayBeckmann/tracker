import 'package:flutter/material.dart';

@immutable
class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.languageCode,
    required this.seedColor,
    required this.syncEnabled,
    required this.autoSyncEnabled,
  });

  factory AppSettings.initial() => AppSettings(
    themeMode: ThemeMode.system,
    languageCode: null,
    seedColor: const Color(0xFF009688),
    syncEnabled: false,
    autoSyncEnabled: false,
  );

  final ThemeMode themeMode;
  final String? languageCode;
  final Color seedColor;
  final bool syncEnabled;
  final bool autoSyncEnabled;

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
    bool? syncEnabled,
    bool? autoSyncEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      seedColor: seedColor ?? this.seedColor,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode.index,
      'languageCode': languageCode,
      'seedColor': seedColor.value,
      'syncEnabled': syncEnabled,
      'autoSyncEnabled': autoSyncEnabled,
    };
  }

  static AppSettings fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return AppSettings.initial();
    }

    Color parseSeedColor() {
      final rawValue = map['seedColor'];

      if (rawValue is int) {
        return Color(rawValue);
      }

      if (rawValue is List && rawValue.length == 4) {
        return Color.fromARGB(
          rawValue[0] as int,
          rawValue[1] as int,
          rawValue[2] as int,
          rawValue[3] as int,
        );
      }

      return const Color(0xFF009688);
    }

    return AppSettings(
      themeMode:
          ThemeMode.values[map['themeMode'] as int? ?? ThemeMode.system.index],
      languageCode: map['languageCode'] as String?,
      seedColor: parseSeedColor(),
      syncEnabled: map['syncEnabled'] as bool? ?? false,
      autoSyncEnabled: map['autoSyncEnabled'] as bool? ?? false,
    );
  }
}
