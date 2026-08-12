import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/watchable.dart';
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final items = widget.appState.items;
        final kdramaCount =
            items.where((w) => w.category == Category.kdrama).length;
        final animeCount =
            items.where((w) => w.category == Category.anime).length;

        // Si le prénom a changé ailleurs, on garde le champ synchronisé
        // sans écraser ce que l'utilisatrice est en train de taper.
        final fieldHasFocus = FocusScope.of(context).hasFocus;
        if (!fieldHasFocus && _nameController.text != widget.appState.userName) {
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
                Row(
                  children: [
                    _StatCard(label: 'Total', value: '${items.length}'),
                    const SizedBox(width: 12),
                    _StatCard(label: 'K-drama', value: '$kdramaCount'),
                    const SizedBox(width: 12),
                    _StatCard(label: 'Anime', value: '$animeCount'),
                  ],
                ),
                const SizedBox(height: 24),
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

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
