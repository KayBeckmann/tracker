import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
    );
  }

  static ThemeData dark(Color seedColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
    );
  }
}
