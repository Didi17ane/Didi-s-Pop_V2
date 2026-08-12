import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/sample_data.dart';
import 'models/watchable.dart';

const _kItemsKey = 'didis_pop_items';
const _kThemeKey = 'didis_pop_theme_mode';
const _kNameKey = 'didis_pop_user_name';

/// État partagé de l'app (pas besoin de Provider/Riverpod pour ce niveau
/// de projet) : la liste de titres, le thème et le prénom du profil.
///
/// Toutes les mutations sont persistées dans shared_preferences, donc elles
/// survivent à la fermeture de l'app.
class AppState extends ChangeNotifier {
  List<Watchable> items = [];
  ThemeMode themeMode = ThemeMode.light;
  String userName = 'Didiane';

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  /// À appeler une fois au démarrage, avant d'afficher l'app.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final storedItems = prefs.getString(_kItemsKey);
    if (storedItems != null) {
      final decoded = jsonDecode(storedItems) as List<dynamic>;
      items = decoded
          .map((e) => Watchable.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      // Premier lancement : on part des données de démo.
      items = SampleData.initialList();
    }

    themeMode =
        prefs.getString(_kThemeKey) == 'dark' ? ThemeMode.dark : ThemeMode.light;
    userName = prefs.getString(_kNameKey) ?? 'Didiane';

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addItem(Watchable item) async {
    items.insert(0, item);
    notifyListeners();
    await _persistItems();
  }

  Future<void> updateItem(Watchable item) async {
    final index = items.indexWhere((w) => w.id == item.id);
    if (index == -1) return;
    items[index] = item;
    notifyListeners();
    await _persistItems();
  }

  Future<void> deleteItem(String id) async {
    items.removeWhere((w) => w.id == id);
    notifyListeners();
    await _persistItems();
  }

  Future<void> setDarkMode(bool isDark) async {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, isDark ? 'dark' : 'light');
  }

  Future<void> setUserName(String name) async {
    final trimmed = name.trim();
    userName = trimmed.isEmpty ? 'Didiane' : trimmed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNameKey, userName);
  }

  Future<void> _persistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kItemsKey, encoded);
  }
}
