import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/app_category.dart';
import '../models/watchable.dart';
import 'category_chip.dart';

/// Carte affichant le poster, le titre et la catégorie d'un Watchable.
/// Utilisée dans la grille de l'accueil. Réutilisable et sans donnée en dur :
/// tout vient du Watchable et de la catégorie passés en paramètre.
/// [category] est résolue par l'écran appelant (via AppState.categoryFor),
/// car PosterCard n'a pas directement accès à AppState.
class PosterCard extends StatelessWidget {
  final Watchable item;
  final AppCategory category;
  final VoidCallback onTap;

  const PosterCard({
    super.key,
    required this.item,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusLabel = switch (item.status) {
      WatchStatus.toWatch => l10n.statusToWatch,
      WatchStatus.watching => l10n.statusWatching,
      WatchStatus.watched => l10n.statusWatched,
    };

    return Semantics(
      button: true,
      label:
          l10n.posterCardSemanticLabel(item.title, category.name, statusLabel),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          child: ExcludeSemantics(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  // Décode à une taille proche de celle affichée (au lieu de
                  // l'image plein format) pour réduire mémoire et jank dans la
                  // grille.
                  memCacheWidth: 400,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const ColoredBox(color: Colors.black12),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: CategoryChip(category: category),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _StatusBadge(status: item.status, label: statusLabel),
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
                          (item.rating / 2).toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Petit badge rond indiquant le statut de visionnage (à voir / en cours /
/// vu), affiché en haut à droite de la carte.
class _StatusBadge extends StatelessWidget {
  final WatchStatus status;
  final String label;

  const _StatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (status) {
      case WatchStatus.toWatch:
        icon = Icons.bookmark_border;
        color = Colors.white.withValues(alpha: 0.85);
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

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
