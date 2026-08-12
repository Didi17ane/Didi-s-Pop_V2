import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';
import '../widgets/category_chip.dart';

class SearchScreen extends StatefulWidget {
  final AppState appState;

  const SearchScreen({super.key, required this.appState});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  List<Watchable> _results(List<Watchable> items) {
    if (_query.isEmpty) return items;
    return items
        .where((w) => w.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final results = _results(widget.appState.items);
        return _buildScaffold(results);
      },
    );
  }

  Widget _buildScaffold(List<Watchable> results) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Rechercher un K-drama ou un anime...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('Aucun résultat 😕'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                width: 50,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                        width: 50,
                                        height: 70,
                                        child: ColoredBox(
                                            color: Colors.black12)),
                              ),
                            ),
                            title: Text(item.title),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: CategoryChip(category: item.category),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(item.rating.toStringAsFixed(1)),
                              ],
                            ),
                            onTap: () => context.push('/detail/${item.id}',
                                extra: item),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
