import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';
import '../widgets/star_rating.dart';

class AddScreen extends StatefulWidget {
  final AppState appState;
  final Watchable? editingItem; // null = mode "ajout", sinon mode "modifier"

  const AddScreen({super.key, required this.appState, this.editingItem});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _synopsisController;
  late String _categoryId;
  late int _stars; // 1 à 5 ; converti en note /10 au moment d'enregistrer

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.editingItem;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _synopsisController =
        TextEditingController(text: existing?.synopsis ?? '');
    // Catégorie existante, ou la première disponible par défaut (il y en a
    // toujours au moins une : K-drama et Anime sont créées au 1er lancement).
    _categoryId = existing?.categoryId ?? widget.appState.categories.first.id;
    // La note est stockée en interne sur 0-10 ; on l'affiche/édite en 1-5 étoiles.
    _stars = existing != null ? (existing.rating / 2).round().clamp(1, 5) : 5;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final synopsis = _synopsisController.text.trim();
    final existing = widget.editingItem;

    final item = Watchable(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      categoryId: _categoryId,
      rating: (_stars * 2).toDouble(),
      imageUrl: existing?.imageUrl ??
          'https://picsum.photos/seed/${_titleController.text}/300/420',
      synopsis: synopsis.isEmpty
          ? 'Ajouté par Didi. Synopsis à compléter.'
          : synopsis,
    );

    if (_isEditing) {
      widget.appState.updateItem(item);
      // On revient au détail (qui affichera la version à jour).
      context.pop();
    } else {
      widget.appState.addItem(item);
      // On revient directement à l'accueil (et pas juste "en arrière"),
      // pour être sûres de retomber sur la liste à jour.
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier le titre' : 'Ajouter un titre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Champ 1 : titre
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Champ 2 : catégorie
                DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.appState.categories
                      .map((c) => DropdownMenuItem(
                          value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _categoryId = value);
                  },
                ),
                const SizedBox(height: 16),
                // Champ 3 : synopsis
                TextFormField(
                  controller: _synopsisController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Synopsis',
                    hintText: 'Ajouté par Didi. Synopsis à compléter.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Champ 4 : note (1 à 5 étoiles)
                const Text('Note', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                StarRating(
                  value: _stars.toDouble(),
                  size: 32,
                  onChanged: (stars) => setState(() => _stars = stars),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(_isEditing ? 'Mettre à jour' : 'Enregistrer'),
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
