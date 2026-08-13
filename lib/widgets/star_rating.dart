import 'package:flutter/material.dart';

/// Rangée de 5 étoiles. En lecture seule si [onChanged] est null,
/// sinon chaque étoile devient tapable pour choisir une note de 1 à 5.
class StarRating extends StatelessWidget {
  final double value; // 0 à 5, peut être décimal en lecture seule
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

        if (onChanged == null) return star;

        return InkWell(
          borderRadius: BorderRadius.circular(size),
          onTap: () => onChanged!(starNumber),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: star,
          ),
        );
      }),
    );
  }
}
