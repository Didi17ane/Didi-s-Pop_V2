import 'package:flutter/material.dart';
import '../models/watchable.dart';
import '../theme/app_theme.dart';

/// Petit badge coloré affichant "K-drama" ou "Anime".
/// Réutilisable partout où on affiche un Watchable.
class CategoryChip extends StatelessWidget {
  final Category category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = category == Category.kdrama
        ? AppColors.purpleAccent
        : AppColors.pinkAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
