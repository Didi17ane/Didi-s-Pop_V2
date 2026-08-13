import 'package:flutter/material.dart';

/// Une catégorie personnalisable (ex: K-drama, Anime, Film, Manga...).
/// [colorValue] est stocké en int (ARGB) pour pouvoir être persisté en JSON.
class AppCategory {
  final String id;
  final String name;
  final int colorValue;

  const AppCategory({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
      };

  factory AppCategory.fromJson(Map<String, dynamic> json) => AppCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        colorValue: json['colorValue'] as int,
      );

  /// Catégories de départ : les mêmes ids ('kdrama', 'anime') que
  /// l'ancien enum Category, pour rester compatible avec les titres déjà
  /// enregistrés (aucune migration nécessaire).
  static List<AppCategory> defaults() => const [
        AppCategory(id: 'kdrama', name: 'K-drama', colorValue: 0xFF9A5CB4),
        AppCategory(id: 'anime', name: 'Anime', colorValue: 0xFFF4A8C0),
      ];

  /// Palette utilisée pour assigner automatiquement une couleur aux
  /// nouvelles catégories créées par l'utilisatrice.
  static const List<int> palette = [
    0xFF5C9AB4, // bleu
    0xFFB4905C, // ambre
    0xFF5CB48B, // vert menthe
    0xFFB45C6E, // rouge rosé
    0xFF8C5CB4, // violet
    0xFFB4AA5C, // moutarde
  ];

  static int colorForIndex(int index) => palette[index % palette.length];
}
