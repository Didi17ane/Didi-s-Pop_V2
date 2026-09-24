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

      const newItem = Watchable(
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

    test('addItem rejects a duplicate title (case/whitespace insensitive)',
        () async {
      final appState = AppState();
      await appState.load();
      final initialCount = appState.items.length;

      const first = Watchable(
        id: '1',
        title: 'Test Show Alpha',
        categoryId: 'kdrama',
        rating: 9.0,
        imageUrl: 'https://example.com/a.jpg',
        synopsis: '...',
      );
      const duplicate = Watchable(
        id: '2',
        title: '  test show alpha  ',
        categoryId: 'kdrama',
        rating: 7.0,
        imageUrl: 'https://example.com/b.jpg',
        synopsis: '...',
      );

      expect(await appState.addItem(first), null);
      final error = await appState.addItem(duplicate);

      expect(error, isNotNull);
      expect(appState.items.length, initialCount + 1);
    });

    test('addCategory rejects an empty name, a duplicate, and enforces '
        'maxCategories', () async {
      final appState = AppState();
      await appState.load();
      final initialCount = appState.categories.length;

      expect(await appState.addCategory('   '), isNotNull);
      expect(await appState.addCategory('K-drama'), isNotNull); // doublon
      expect(appState.categories.length, initialCount);

      // Remplit jusqu'à la limite.
      String? lastError;
      for (var i = 0; i < AppState.maxCategories + 2; i++) {
        lastError = await appState.addCategory('Catégorie $i');
      }

      expect(appState.categories.length, AppState.maxCategories);
      expect(lastError, isNotNull);
    });

    test('deleteCategory removes the category and its items', () async {
      final appState = AppState();
      await appState.load();

      await appState.addCategory('Film');
      final film = appState.categories.firstWhere((c) => c.name == 'Film');

      final item = Watchable(
        id: 'film-1',
        title: 'Parasite',
        categoryId: film.id,
        rating: 9.0,
        imageUrl: 'https://example.com/c.jpg',
        synopsis: '...',
      );
      await appState.addItem(item);
      expect(appState.itemCountForCategory(film.id), 1);

      await appState.deleteCategory(film.id);

      expect(appState.categories.any((c) => c.id == film.id), false);
      expect(appState.items.any((w) => w.categoryId == film.id), false);
    });

    test('categoryFor returns a fallback category for an unknown id', () {
      final appState = AppState();
      final fallback = appState.categoryFor('does-not-exist');

      expect(fallback.id, 'does-not-exist');
      expect(fallback.name, 'does-not-exist');
    });
  });
}