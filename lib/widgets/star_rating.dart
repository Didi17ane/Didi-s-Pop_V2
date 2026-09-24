import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Rangée de 5 étoiles. En lecture seule si [onChanged] est null,
/// sinon chaque étoile devient tapable pour choisir une note entière de 1 à 5.
class StarRating extends StatelessWidget {
  final double value; // 0 à 5 (entier en mode sélection)
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRating({
    super.key,
    required this.value,
    this.size = 22,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final filled = value >= starNumber;
        final halfFilled = !filled && value > index && value < starNumber;

        final icon = filled
            ? Icons.star
            : halfFilled
                ? Icons.star_half
                : Icons.star_border;

        final star = Icon(icon, color: Colors.amber, size: size);

        if (onChanged == null) {
          return Semantics(
            label: l10n.starRatingSemanticLabel(starNumber),
            child: ExcludeSemantics(child: star),
          );
        }

        return Semantics(
          button: true,
          label: l10n.starRatingSemanticLabel(starNumber),
          selected: filled,
          child: InkWell(
            borderRadius: BorderRadius.circular(size),
            onTap: () => onChanged!(starNumber),
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: star,
              ),
            ),
          ),
        );
      }),
    );
  }
}
