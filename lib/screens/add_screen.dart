import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../l10n/app_localizations.dart';
import '../models/watchable.dart';
import '../services/poster_service.dart';
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
  late final TextEditingController _imageUrlController;
  late String _categoryId;
  late int _stars; // 1 à 5 ; converti en note /10 au moment d'enregistrer
  bool _isSaving = false;

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.editingItem;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _synopsisController = TextEditingController(text: existing?.synopsis ?? '');
    _imageUrlController = TextEditingController(text: existing?.imageUrl ?? '');
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
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    var imageUrl = _imageUrlController.text.trim();

    // Si aucune image n'a été collée à la main, on cherche automatiquement
    // la vraie affiche correspondant au titre. Si rien n'est trouvé (ou
    // pas de connexion), on retombe sur l'image aléatoire comme avant.
    if (imageUrl.isEmpty) {
      final found = await PosterService.fetchPosterFor(
        title: title,
        categoryId: _categoryId,
      );
      imageUrl = found ?? 'https://picsum.photos/seed/$title/300/420';
    }

    if (!mounted) return;

    final synopsis = _synopsisController.text.trim();
    final existing = widget.editingItem;

    final item = Watchable(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      categoryId: _categoryId,
      rating: (_stars * 2).toDouble(),
      imageUrl: imageUrl,
      synopsis: synopsis.isEmpty ? 'Synopsis à compléter.' : synopsis,
    );

    if (_isEditing) {
      widget.appState.updateItem(item);
      // On revient au détail (qui affichera la version à jour).
      if (mounted) context.pop();
    } else {
      widget.appState.addItem(item);
      // On revient directement à l'accueil (et pas juste "en arrière"),
      // pour être sûres de retomber sur la liste à jour.
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editScreenTitle : l10n.addScreenTitle),
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
                  decoration: InputDecoration(
                    labelText: l10n.titleFieldLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.titleRequiredError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Champ 2 : catégorie
                DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: InputDecoration(
                    labelText: l10n.categoryFieldLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: widget.appState.categories
                      .map((c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.name)))
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
                    hintText: 'Synopsis à compléter.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Champ 4 : image (optionnel)
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image (URL) — optionnel',
                    hintText: 'Laisse vide pour une recherche automatique',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 4),
                Text(
                  'Si tu ne colles pas d\'URL, on cherche automatiquement '
                  'la vraie affiche du titre.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 16),
                // Champ 5 : note (1 à 5 étoiles)
                const Text('Note', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                StarRating(
                  value: _stars.toDouble(),
                  size: 32,
                  onChanged: (stars) => setState(() => _stars = stars),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? l10n.updateButton : l10n.saveButton),
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
