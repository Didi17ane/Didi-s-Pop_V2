import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/sample_data.dart';
import 'models/app_category.dart';
import 'models/watchable.dart';
import 'services/poster_service.dart';

const _kItemsKey = 'didis_pop_items';
const _kThemeKey = 'didis_pop_theme_mode';
const _kNameKey = 'didis_pop_user_name';
const _kCategoriesKey = 'didis_pop_categories';

/// État partagé de l'app (pas besoin de Provider/Riverpod pour ce niveau
/// de projet) : la liste de titres, les catégories, le thème et le prénom.
///
/// Toutes les mutations sont persistées dans shared_preferences, donc elles
/// survivent à la fermeture de l'app.
class AppState extends ChangeNotifier {
  /// Nombre maximum de catégories (par défaut + personnalisées confondues).
  static const int maxCategories = 5;

  List<Watchable> items = [];
  List<AppCategory> categories = [];
  ThemeMode themeMode = ThemeMode.light;
  String userName = 'Didiane';

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  /// À appeler une fois au démarrage, avant d'afficher l'app.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final storedCategories = prefs.getString(_kCategoriesKey);
    if (storedCategories != null) {
      final decoded = jsonDecode(storedCategories) as List<dynamic>;
      categories = decoded
          .map((e) => AppCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      categories = List<AppCategory>.from(AppCategory.defaults());
    }

    final storedItems = prefs.getString(_kItemsKey);
    if (storedItems != null) {
      final decoded = jsonDecode(storedItems) as List<dynamic>;
      items = decoded
          .map((e) => Watchable.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      // Premier lancement : on part des données de démo, mais on tente de
      // remplacer l'image aléatoire de chaque titre par sa vraie affiche
      // (même service que pour un ajout manuel, donc la catégorie est bien
      // prise en compte : Jikan pour "anime", TMDB pour le reste).
      // Si ça échoue (pas de connexion, pas encore de clé TMDB...), le
      // titre garde simplement son image de secours — rien ne bloque.
      final seed = SampleData.initialList();
      final resolved = <Watchable>[];
      for (final w in seed) {
        final found = await PosterService.fetchPosterFor(
          title: w.title,
          categoryId: w.categoryId,
        );
        resolved.add(found != null ? w.copyWith(imageUrl: found) : w);
      }
      items = resolved;
    }

    themeMode =
        prefs.getString(_kThemeKey) == 'dark' ? ThemeMode.dark : ThemeMode.light;
    userName = prefs.getString(_kNameKey) ?? 'Didiane';

    _isLoaded = true;
    notifyListeners();
  }

  /// Retrouve une catégorie par son id. Si elle a été supprimée entre
  /// temps (cas normalement impossible puisqu'on supprime aussi les
  /// titres associés), on retombe sur une catégorie grise de secours
  /// plutôt que de planter.
  AppCategory categoryFor(String categoryId) {
    for (final c in categories) {
      if (c.id == categoryId) return c;
    }
    return AppCategory(id: categoryId, name: categoryId, colorValue: 0xFF9E9E9E);
  }

  /// Ajoute un titre. Retourne un message d'erreur si un titre du même nom
  /// existe déjà (comparaison insensible à la casse/espaces), sinon null.
  Future<String?> addItem(Watchable item) async {
    final duplicate = items.any((w) =>
        w.title.trim().toLowerCase() == item.title.trim().toLowerCase());
    if (duplicate) {
      return '"${item.title}" est déjà dans ta liste.';
    }

    items.insert(0, item);
    notifyListeners();
    await _persistItems();
    return null;
  }

  /// Modifie un titre. Retourne un message d'erreur si le nouveau titre
  /// entre en collision avec un AUTRE titre existant, sinon null.
  Future<String?> updateItem(Watchable item) async {
    final duplicate = items.any((w) =>
        w.id != item.id &&
        w.title.trim().toLowerCase() == item.title.trim().toLowerCase());
    if (duplicate) {
      return '"${item.title}" est déjà dans ta liste.';
    }

    final index = items.indexWhere((w) => w.id == item.id);
    if (index == -1) return null;
    items[index] = item;
    notifyListeners();
    await _persistItems();
    return null;
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

  /// Ajoute une nouvelle catégorie personnalisée. Une couleur est assignée
  /// automatiquement (rotation dans une petite palette). Retourne un
  /// message d'erreur si le nom est vide, en double, ou si la limite de
  /// [maxCategories] est atteinte — sinon null.
  Future<String?> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Le nom ne peut pas être vide.';

    final duplicate = categories
        .any((c) => c.name.trim().toLowerCase() == trimmed.toLowerCase());
    if (duplicate) return 'Cette catégorie existe déjà.';

    if (categories.length >= maxCategories) {
      return 'Limite de $maxCategories catégories atteinte.';
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final color = AppCategory.colorForIndex(categories.length);
    categories.add(AppCategory(id: id, name: trimmed, colorValue: color));
    notifyListeners();
    await _persistCategories();
    return null;
  }

  /// Supprime une catégorie ET tous les titres qui lui sont rattachés.
  Future<void> deleteCategory(String categoryId) async {
    categories.removeWhere((c) => c.id == categoryId);
    items.removeWhere((w) => w.categoryId == categoryId);
    notifyListeners();
    await _persistCategories();
    await _persistItems();
  }

  /// Nombre de titres rattachés à une catégorie (utile pour prévenir
  /// avant suppression).
  int itemCountForCategory(String categoryId) =>
      items.where((w) => w.categoryId == categoryId).length;

  Future<void> _persistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kItemsKey, encoded);
  }

  Future<void> _persistCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString(_kCategoriesKey, encoded);
  }
}
