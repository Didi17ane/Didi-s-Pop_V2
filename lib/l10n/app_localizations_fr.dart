// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navProfile => 'Profil';

  @override
  String get addButton => 'Ajouter';

  @override
  String get filterAll => 'Tous';

  @override
  String homeGreeting(String name) {
    return 'Hiii $name! 👋';
  }

  @override
  String get addScreenTitle => 'Ajouter un titre';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get profileScreenTitle => 'Profil';

  @override
  String get darkModeLabel => 'Thème sombre';

  @override
  String get searchScreenTitle => 'Recherche';

  @override
  String get searchHint => 'Rechercher un K-drama ou un anime...';

  @override
  String get statusToWatch => 'À voir';

  @override
  String get statusWatching => 'En cours';

  @override
  String get statusWatched => 'Vu';

  @override
  String starRatingSemanticLabel(int value) {
    return 'Noter $value sur 5';
  }

  @override
  String posterCardSemanticLabel(String title, String category, String status) {
    return '$title, catégorie $category, statut $status';
  }

  @override
  String get editScreenTitle => 'Modifier le titre';

  @override
  String get updateButton => 'Mettre à jour';

  @override
  String get titleFieldLabel => 'Titre';

  @override
  String get titleRequiredError => 'Le titre est obligatoire';

  @override
  String get categoryFieldLabel => 'Catégorie';
}
