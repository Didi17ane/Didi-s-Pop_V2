import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';
import '../widgets/category_chip.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatelessWidget {
  final String itemId;
  final AppState appState;

  const DetailScreen(
      {super.key, required this.itemId, required this.appState});

  Future<void> _confirmDelete(BuildContext context, Watchable item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce titre ?'),
        content: Text(
            '"${item.title}" sera définitivement supprimé de ta liste.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await appState.deleteItem(item.id);
      if (context.mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder : dès qu'on modifie ou supprime ce titre ailleurs
    // (ex: après l'écran Modifier), cet écran se met à jour tout seul,
    // sans avoir besoin de revenir en arrière.
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        Watchable? item;
        for (final w in appState.items) {
          if (w.id == itemId) {
            item = w;
            break;
          }
        }

        // Le titre a été supprimé (depuis cet écran ou ailleurs) :
        // on revient à l'accueil automatiquement.
        if (item == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/');
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        final current = item;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Modifier',
                    onPressed: () => context.push('/edit/${current.id}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Supprimer',
                    onPressed: () => _confirmDelete(context, current),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    current.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(color: Colors.black12),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryChip(
                          category: appState.categoryFor(current.categoryId)),
                      const SizedBox(height: 12),
                      Text(
                        current.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          StarRating(value: current.rating / 2, size: 20),
                          const SizedBox(width: 8),
                          Text('${(current.rating / 2).toStringAsFixed(1)} / 5'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: WatchStatus.values.map((status) {
                          return ChoiceChip(
                            label: Text(status.label),
                            selected: current.status == status,
                            onSelected: (_) => appState.updateItem(
                                current.copyWith(status: status)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Synopsis',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current.synopsis,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
