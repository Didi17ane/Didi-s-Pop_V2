import 'package:flutter/material.dart';
import '../models/watchable.dart';
import 'category_chip.dart';

/// Carte affichant le poster, le titre et la catégorie d'un Watchable.
/// Utilisée dans la grille de l'accueil. Réutilisable et sans donnée en dur :
/// tout vient du Watchable passé en paramètre.
class PosterCard extends StatelessWidget {
  final Watchable item;
  final VoidCallback onTap;

  const PosterCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Colors.black12),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: CategoryChip(category: item.category),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _StatusBadge(status: item.status),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Petit badge rond indiquant le statut de visionnage (à voir / en cours /
/// vu), affiché en haut à droite de la carte.
class _StatusBadge extends StatelessWidget {
  final WatchStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (status) {
      case WatchStatus.toWatch:
        icon = Icons.bookmark_border;
        color = Colors.white.withOpacity(0.85);
        break;
      case WatchStatus.watching:
        icon = Icons.play_circle_fill;
        color = const Color(0xFFF4A8C0); // rose accent
        break;
      case WatchStatus.watched:
        icon = Icons.check_circle;
        color = const Color(0xFF4CAF50); // vert
        break;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
