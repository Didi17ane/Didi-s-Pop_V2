import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../l10n/app_localizations.dart';
import '../models/watchable.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_title.dart';

enum _SortOption { recent, topRated }

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _filter; // null = Tous ; sinon un categoryId
  int _minStars = 0; // 0 = pas de filtre
  WatchStatus? _statusFilter; // null = Tous
  _SortOption _sort = _SortOption.recent;

  int get _activeFilterCount {
    var count = 0;
    if (_filter != null) count++;
    if (_minStars != 0) count++;
    if (_statusFilter != null) count++;
    return count;
  }

  List<Watchable> _processed(List<Watchable> items) {
    var result = items
        .where((w) => _filter == null || w.categoryId == _filter)
        .where((w) => _minStars == 0 || (w.rating / 2) >= _minStars)
        .where((w) => _statusFilter == null || w.status == _statusFilter)
        .toList();

    if (_sort == _SortOption.topRated) {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }
    // "Récents" : on garde l'ordre de la liste (les nouveaux titres sont
    // insérés en tête dans AppState.addItem), donc rien à faire de plus.

    return result;
  }

  void _openFiltersSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        // StatefulBuilder pour que les chips se mettent à jour visuellement
        // à l'intérieur de la feuille dès qu'on tape dessus.
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filtres et tri',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (_activeFilterCount > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filter = null;
                              _minStars = 0;
                              _statusFilter = null;
                            });
                            setSheetState(() {});
                          },
                          child: const Text('Réinitialiser'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Catégorie',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: l10n.filterAll,
                        selected: _filter == null,
                        onTap: () {
                          setState(() => _filter = null);
                          setSheetState(() {});
                        },
                      ),
                      for (final cat in widget.appState.categories)
                        _FilterChip(
                          label: cat.name,
                          selected: _filter == cat.id,
                          onTap: () {
                            setState(() => _filter = cat.id);
                            setSheetState(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Note minimum',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Toutes',
                        selected: _minStars == 0,
                        onTap: () {
                          setState(() => _minStars = 0);
                          setSheetState(() {});
                        },
                      ),
                      for (final stars in [3, 4, 5])
                        _FilterChip(
                          label: '$stars★+',
                          selected: _minStars == stars,
                          onTap: () {
                            setState(() => _minStars = stars);
                            setSheetState(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Statut',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: l10n.filterAll,
                        selected: _statusFilter == null,
                        onTap: () {
                          setState(() => _statusFilter = null);
                          setSheetState(() {});
                        },
                      ),
                      for (final status in WatchStatus.values)
                        _FilterChip(
                          label: status.label,
                          selected: _statusFilter == status,
                          onTap: () {
                            setState(() => _statusFilter = status);
                            setSheetState(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Trier par',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Plus récents',
                        selected: _sort == _SortOption.recent,
                        onTap: () {
                          setState(() => _sort = _SortOption.recent);
                          setSheetState(() {});
                        },
                      ),
                      _FilterChip(
                        label: 'Mieux notés',
                        selected: _sort == _SortOption.topRated,
                        onTap: () {
                          setState(() => _sort = _SortOption.topRated);
                          setSheetState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive : 2 colonnes en mobile, 4 en tablette (largeur > 600).
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 4 : 2;
    final l10n = AppLocalizations.of(context)!;

    // AnimatedBuilder : dès qu'un titre est ajouté ou que le prénom change
    // dans AppState, cet écran se met à jour tout seul.
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final filtered = _processed(widget.appState.items);

        return Scaffold(
          appBar: AppBar(title: Text(l10n.navHome)),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                    text: l10n.homeGreeting(widget.appState.userName)),
                const SizedBox(height: 8),

                // Une seule ligne compacte : bouton Filtres (avec badge) +
                // nombre de résultats. Tout le reste (catégorie, note,
                // statut, tri) se trouve dans la feuille qui s'ouvre.
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _openFiltersSheet,
                      icon: Badge(
                        isLabelVisible: _activeFilterCount > 0,
                        label: Text('$_activeFilterCount'),
                        child: const Icon(Icons.tune, size: 18),
                      ),
                      label: const Text('Filtres'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${filtered.length} titre${filtered.length > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
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
                              category:
                                  widget.appState.categoryFor(item.categoryId),
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
      label: Text(
        label,
        softWrap: false,
        overflow: TextOverflow.visible,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
