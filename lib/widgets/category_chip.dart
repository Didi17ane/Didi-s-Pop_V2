import 'package:flutter/material.dart';
import '../models/app_category.dart';

/// Petit badge coloré affichant le nom d'une catégorie (K-drama, Anime,
/// ou toute catégorie personnalisée créée par l'utilisatrice).
/// Réutilisable partout où on affiche un Watchable.
class CategoryChip extends StatelessWidget {
  final AppCategory category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
