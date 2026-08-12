import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_state.dart';
import '../models/watchable.dart';

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
  late final TextEditingController _ratingController;
  late final TextEditingController _synopsisController;
  late Category _category;

  bool get _isEditing => widget.editingItem != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.editingItem;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _ratingController =
        TextEditingController(text: existing?.rating.toString() ?? '');
    _synopsisController =
        TextEditingController(text: existing?.synopsis ?? '');
    _category = existing?.category ?? Category.kdrama;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ratingController.dispose();
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
      category: _category,
      rating: double.parse(_ratingController.text),
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
                DropdownButtonFormField<Category>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                  items: Category.values
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.label)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
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
                // Champ 4 : note
                TextFormField(
                  controller: _ratingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Note (0 à 10)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La note est obligatoire';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 0 || parsed > 10) {
                      return 'Entre 0 et 10 uniquement';
                    }
                    return null;
                  },
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
