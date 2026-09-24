// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navProfile => 'Profile';

  @override
  String get addButton => 'Add';

  @override
  String get filterAll => 'All';

  @override
  String homeGreeting(String name) {
    return 'Hiii $name! 👋';
  }

  @override
  String get addScreenTitle => 'Add a title';

  @override
  String get saveButton => 'Save';

  @override
  String get profileScreenTitle => 'Profile';

  @override
  String get darkModeLabel => 'Dark theme';

  @override
  String get searchScreenTitle => 'Search';

  @override
  String get searchHint => 'Search for a K-drama or anime...';

  @override
  String get statusToWatch => 'To watch';

  @override
  String get statusWatching => 'Watching';

  @override
  String get statusWatched => 'Watched';

  @override
  String starRatingSemanticLabel(int value) {
    return 'Rate $value out of 5';
  }

  @override
  String posterCardSemanticLabel(String title, String category, String status) {
    return '$title, category $category, status $status';
  }

  @override
  String get editScreenTitle => 'Edit title';

  @override
  String get updateButton => 'Update';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get titleRequiredError => 'Title is required';

  @override
  String get categoryFieldLabel => 'Category';
}
