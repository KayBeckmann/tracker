import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tracker/l10n/app_localizations.dart';

import 'package:tracker/app/navigation/home_shell.dart';
import 'package:tracker/app/theme/app_theme.dart';
import 'package:tracker/features/settings/application/settings_controller.dart';

class TrackerApp extends ConsumerWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light(settings.seedColor),
      darkTheme: AppTheme.dark(settings.seedColor),
      themeMode: settings.themeMode,
      locale: settings.locale,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (settings.locale != null) {
          return settings.locale;
        }

        if (deviceLocale != null) {
          final match = supportedLocales.firstWhere(
            (supported) => supported.languageCode == deviceLocale.languageCode,
            orElse: () => const Locale('en'),
          );
          return match;
        }

        return const Locale('en');
      },
      home: const HomeShell(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
