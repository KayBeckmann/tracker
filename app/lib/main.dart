import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tracker/app/app.dart';
import 'package:tracker/core/storage/settings_repository.dart';
import 'package:tracker/features/settings/application/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsRepository = await HiveSettingsRepository.init();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
      ],
      child: const TrackerApp(),
    ),
  );
}
