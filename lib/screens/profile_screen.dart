import 'package:flutter/material.dart';
import '../app_state.dart';
import '../widgets/section_title.dart';

class ProfileScreen extends StatefulWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appState.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    FocusScope.of(context).unfocus();
    widget.appState.setUserName(_nameController.text);
  }

  Future<void> _openAddCategoryDialog() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle catégorie'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ex: Film, Manga, Documentaire...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (name != null && name.trim().isNotEmpty) {
      final error = await widget.appState.addCategory(name);
      if (error != null && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  Future<void> _confirmDeleteCategory(
      BuildContext context, String categoryId, String categoryName) async {
    final count = widget.appState.itemCountForCategory(categoryId);
    final message = count > 0
        ? 'Cette catégorie contient $count titre${count > 1 ? 's' : ''}. '
            'La supprimer supprimera aussi ces titres définitivement.'
        : 'Supprimer la catégorie "$categoryName" ?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer "$categoryName" ?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:
                const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.appState.deleteCategory(categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final items = widget.appState.items;
        final categories = widget.appState.categories;

        // Si le prénom a changé ailleurs, on garde le champ synchronisé
        // sans écraser ce que l'utilisatrice est en train de taper.
        final fieldHasFocus = FocusScope.of(context).hasFocus;
        if (!fieldHasFocus &&
            _nameController.text != widget.appState.userName) {
          _nameController.text = widget.appState.userName;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      AssetImage('assets/avatar/default_avatar.png'),
                ),
                const SizedBox(height: 20),
                const SectionTitle(text: 'Ton prénom'),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Entre ton prénom',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Enregistrer',
                      onPressed: _saveName,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveName(),
                ),
                const SizedBox(height: 24),

                const SectionTitle(text: 'Statistiques'),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _StatCard(label: 'Total', value: '${items.length}'),
                      for (final cat in categories) ...[
                        const SizedBox(width: 12),
                        _StatCard(
                          label: cat.name,
                          value:
                              '${widget.appState.itemCountForCategory(cat.id)}',
                          color: cat.color,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    SectionTitle(
                      text:
                          'Mes catégories (${categories.length}/${AppState.maxCategories})',
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Ajouter une catégorie',
                      onPressed: _openAddCategoryDialog,
                    ),
                  ],
                ),
                for (final cat in categories)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: cat.color,
                      ),
                      title: Text(cat.name),
                      subtitle: Text(
                        '${widget.appState.itemCountForCategory(cat.id)} titre(s)',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Supprimer',
                        onPressed: () =>
                            _confirmDeleteCategory(context, cat.id, cat.name),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                const SectionTitle(text: 'Préférences'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Thème sombre'),
                  value: widget.appState.themeMode == ThemeMode.dark,
                  onChanged: widget.appState.setDarkMode,
                ),
                // Petite marge en bas pour respirer au-dessus du clavier.
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatCard({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  )),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
