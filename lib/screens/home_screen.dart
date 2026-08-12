import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? _filter; // null = Tous

  List<Watchable> _filtered(List<Watchable> items) {
    return items
        .where((w) => _filter == null || w.category == _filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive : 2 colonnes en mobile, 4 en tablette (largeur > 600).
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 4 : 2;

    // AnimatedBuilder : dès qu'un titre est ajouté ou que le prénom change
    // dans AppState, cet écran se met à jour tout seul.
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final filtered = _filtered(widget.appState.items);

        return Scaffold(
          appBar: AppBar(title: const Text('Accueil')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(text: 'Hiii ${widget.appState.userName}! 👋'),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Tous',
                        selected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'K-drama',
                        selected: _filter == Category.kdrama,
                        onTap: () =>
                            setState(() => _filter = Category.kdrama),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Anime',
                        selected: _filter == Category.anime,
                        onTap: () =>
                            setState(() => _filter = Category.anime),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Aucun résultat 😕'))
                      : GridView.builder(
                          itemCount: filtered.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return PosterCard(
                              item: item,
                              onTap: () => context
                                  .push('/detail/${item.id}', extra: item),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
