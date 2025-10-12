import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:app/main.dart';
import 'package:app/data/local/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase database;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('tracker_hive_test');
    Hive.init(tempDir.path);
    await Hive.openBox(trackerBoxName);
    database = AppDatabase.inMemory();
  });

  tearDown(() async {
    await Hive.box(trackerBoxName).clear();
  });

  tearDownAll(() async {
    await database.close();
    final box = Hive.box(trackerBoxName);
    await box.close();
    await Hive.deleteBoxFromDisk(trackerBoxName);
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('renders initial tracker screen', (WidgetTester tester) async {
    await tester.pumpWidget(TrackerApp(database: database));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(
      find.text('Sign in with your email address and password.'),
      findsOneWidget,
    );
    expect(find.text('Register'), findsOneWidget);
  });
}
