# Didi's Pop

Application Flutter pour suivre des K-dramas et des animés.

## À propos du projet

**Didi's Pop** est une application Flutter multi-écrans permettant de gérer et suivre une liste personnelle de K-dramas et d'animés préférés. L'application démontre les concepts fondamentaux de Flutter : navigation multi-écrans, gestion d'état, formulaires avec validation, passage de paramètres et adaptation au thème clair/sombre.

### Fonctionnalités principales

- 📱 **Navigation multi-écrans** avec GoRouter (routes nommées)
- 🏠 **Accueil** : grille de titres avec filtrage par catégorie (K-drama/Anime)
- 🔍 **Recherche** : écran dédié avec champ de recherche textuel
- 📝 **Détail** : affichage complet avec image, note, synopsis
- ➕ **Ajout** : formulaire avec validation (titre, catégorie, note, synopsis)
- 👤 **Profil** : statistiques et gestion du thème clair/sombre
- 🎨 **Thème** : support complet des thèmes clair et sombre

## Lancer le projet

1. Cloner le dépôt.
2. Installer les dépendances.

```bash
flutter pub get
```

3. Lancer l'application.

```bash
flutter run
```

## Architecture et structure

```
lib/
  main.dart              # Point d'entrée de l'application
  app_state.dart         # Gestion d'état centralisée (ChangeNotifier)
  models/
    watchable.dart       # Modèle de données (Watchable) et énumération Category
  data/
    sample_data.dart     # Données d'exemple pour le démarrage
  theme/
    app_theme.dart       # Définition des thèmes clair et sombre
  router/
    app_router.dart      # Configuration des routes avec GoRouter
  screens/
    home_screen.dart     # Écran d'accueil avec grille et filtrage
    search_screen.dart   # Écran de recherche
    detail_screen.dart   # Écran de détail d'un titre
    add_screen.dart      # Écran d'ajout avec formulaire
    profile_screen.dart  # Écran de profil avec statistiques
    root_shell.dart      # Shell de navigation (BottomNavigationBar)
  widgets/
    poster_card.dart     # Carte affichant le poster et les infos
    category_chip.dart   # Badge de catégorie
    section_title.dart   # Titre de section réutilisable

test/                    # Tests unitaires et de widgets
  models/
    watchable_test.dart
  app_state_test.dart
  widgets/
    category_chip_test.dart
```

### Points clés de l'architecture

- **Modèle de données** : `Watchable` représente un K-drama ou anime avec id, titre, catégorie, note, image et synopsis
- **Gestion d'état** : `AppState` (ChangeNotifier) gère la liste d'éléments et le mode thème
- **Navigation** : GoRouter avec routes nommées (`/`, `/detail/:id`, `/add`) et passage de paramètres via `extra`
- **Widgets réutilisables** : `CategoryChip`, `PosterCard`, `SectionTitle` pour éviter la duplication
- **Responsivité** : adaptée mobile et tablette (2 colonnes mobile, 4+ tablette)

## Écrans

Captures des écrans principaux du projet :

### Accueil
![Accueil](screenshots/acceuil.jpeg)

### Recherche
![Recherche](screenshots/recherche.jpeg)

### Détail
![Détail](screenshots/detail.jpeg)

### Ajout
![Ajout](screenshots/ajout.jpeg)

### Profil
![Profil](screenshots/profil.jpeg)

## Tests

Le projet inclut des tests unitaires et de widgets :

```bash
flutter test
```

### Couverture des tests

- **Tests unitaires** : modèle `Watchable`, logique d'`AppState`
- **Tests de widgets** : validation des widgets réutilisables (`CategoryChip`, etc.)
- À étendre avec des tests d'écrans et d'intégration au fil du développement

## Dépendances principales

- **flutter_test** : framework de test Flutter
- **go_router** : navigation déclarative avec GoRouter
- **flutter_lints** : linting des bonnes pratiques Flutter

## Notes de développement

- Aucune donnée n'est en dur dans les widgets ; tout provient de `models/` et `data/`
- Les contrôleurs de formulaire sont correctement nettoyés dans `dispose()`
- Les images réseau incluent un `errorBuilder` pour gérer les erreurs de chargement
- La navigation utilise les patterns recommandés par GoRouter (routes nommées, `context.push()`, etc.)
- L'écran de recherche offre un filtrage textuel complet
- Le passage des paramètres en détail utilise `state.extra` pour plus de flexibilité

## À propos

Projet Flutter pour suivre des K-dramas et des animés, avec navigation, recherche, ajout d'éléments et thème clair/sombre.

## Changelog — corrections du 12/08/2026

- **Persistance des données** : les titres ajoutés et le thème choisi sont maintenant sauvegardés avec `shared_preferences` (package ajouté au `pubspec.yaml`). Ils survivent à la fermeture de l'app.
- **Thème clair/sombre instantané** : le point de bascule dans `main.dart` utilise désormais un seul `AnimatedBuilder` sur `AppState` (au lieu d'un double mécanisme `setState` + `refreshListenable` de GoRouter qui provoquait un délai avant de pouvoir re-basculer).
- **Retour à l'accueil après ajout** : `AddScreen` utilise `context.go('/')` au lieu de `context.pop()`.
- **Prénom personnalisable** : un champ texte dans l'écran Profil permet de définir son prénom (`AppState.setUserName`), affiché ensuite dans le message d'accueil ("Hiii {prénom}!").
- **Icône de l'app** : nouvelle icône (fond dégradé rose/violet, monogramme "D") générée pour Android et le web. Les fichiers `assets/icon/app_icon.png` (source) et les mipmaps Android/icônes web sont déjà à jour — aucune action nécessaire avant `flutter run`.
  Si tu changes l'image source (`assets/icon/app_icon.png`), régénère les icônes avec :
  ```bash
  flutter pub get
  dart run flutter_launcher_icons
  ```

### Architecture (mise à jour)

Les écrans (`HomeScreen`, `SearchScreen`, `ProfileScreen`, `AddScreen`) reçoivent maintenant directement l'objet `AppState` (au lieu de listes/callbacks séparés) et s'enveloppent dans un `AnimatedBuilder(animation: appState, ...)` pour se reconstruire automatiquement dès que l'état change (nouvel item, thème, prénom) — sans passer par une re-navigation GoRouter.
