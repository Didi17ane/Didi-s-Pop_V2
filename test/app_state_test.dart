import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:didis_pop/app_state.dart';
import 'package:didis_pop/models/watchable.dart';

void main() {
  setUp(() {
    // Stockage en mémoire pour ne pas toucher de vraies préférences pendant les tests.
    SharedPreferences.setMockInitialValues({});
  });

  group('AppState', () {
    test('load() populates sample items and defaults to light theme', () async {
      final appState = AppState();
      await appState.load();

      expect(appState.items.isNotEmpty, true);
      expect(appState.themeMode, ThemeMode.light);
      expect(appState.userName, 'Didiane');
    });

    test('Adding item updates the list and persists it', () async {
      final appState = AppState();
      await appState.load();
      final initialCount = appState.items.length;

      final newItem = Watchable(
        id: 'test-id',
        title: 'New Title',
        categoryId: 'kdrama',
        rating: 8.0,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'New synopsis',
      );

      await appState.addItem(newItem);

      expect(appState.items.length, initialCount + 1);
      expect(appState.items.first.title, 'New Title');

      // Un nouvel AppState qui recharge doit retrouver l'item ajouté.
      final reloaded = AppState();
      await reloaded.load();
      expect(reloaded.items.any((w) => w.id == 'test-id'), true);
    });

    test('Toggling dark mode changes and persists theme', () async {
      final appState = AppState();
      await appState.load();

      expect(appState.themeMode, ThemeMode.light);

      await appState.setDarkMode(true);
      expect(appState.themeMode, ThemeMode.dark);

      final reloaded = AppState();
      await reloaded.load();
      expect(reloaded.themeMode, ThemeMode.dark);
    });

    test('Setting user name updates and persists it', () async {
      final appState = AppState();
      await appState.load();

      await appState.setUserName('Marie');
      expect(appState.userName, 'Marie');

      final reloaded = AppState();
      await reloaded.load();
      expect(reloaded.userName, 'Marie');
    });
  });
}
