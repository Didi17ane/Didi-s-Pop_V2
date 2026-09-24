# Changelog

Toutes les évolutions notables de Didi's Pop sont documentées dans ce
fichier. Format inspiré de [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/).

## [1.2.0] - 2026-09-23

### Ajouté
- Support multilingue FR/EN (`flutter_localizations` + ARB) sur la
  navigation, l'accueil, l'ajout de titre, la recherche et le profil.
- Labels d'accessibilité (`Semantics`) sur les cartes de titres, le badge
  de statut et les étoiles de notation.
- Mise en cache et redimensionnement des affiches (`cached_network_image`
  + `memCacheWidth`) sur la grille, le détail et la recherche.
- Suite de tests élargie : tests unitaires sur `AppCategory` et les
  catégories d'`AppState`, tests widgets sur `StarRating` et `PosterCard`,
  et 2 tests d'intégration bout en bout (ajout d'un titre, changement de
  thème avec persistance).
- Pipeline CI (GitHub Actions) : formatage, `flutter analyze`, tests
  unitaires/widgets avec couverture, puis tests d'intégration.

### Corrigé
- Le test widget `HomeScreen` vérifiait la présence des chips de filtre
  directement sur l'écran d'accueil alors qu'ils ont été déplacés dans la
  feuille de filtres modale ; le test ouvre désormais la feuille avant de
  vérifier leur contenu.

## [1.1.0] - 2026-08-24

### Ajouté
- Catégories personnalisées (création/suppression, limite de 5,
  palette de couleurs auto-assignée).
- Statuts de visionnage (à voir / en cours / vu) avec badge dédié.
- Filtres combinés (catégorie, note minimum, statut) et tri
  (récents / mieux notés) dans une feuille modale.
- Recherche de titre depuis un onglet dédié.
- Intégration Jikan (anime) / TMDB (K-drama) pour récupérer
  automatiquement une affiche à l'ajout d'un titre.

## [1.0.0] - Version initiale

### Ajouté
- Application Flutter construite à partir de zéro avec `ChangeNotifier`
  pour l'état et `GoRouter` pour la navigation.
- Persistance locale (`shared_preferences`) des titres, du thème et du
  prénom.
- Écrans Accueil, Détail, Ajout et Profil avec thème clair/sombre.
- Notation en étoiles et catégories par défaut (K-drama, Anime).
