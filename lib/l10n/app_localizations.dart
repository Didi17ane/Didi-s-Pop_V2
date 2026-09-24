import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Onglet Accueil dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Onglet Recherche dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get navSearch;

  /// Onglet Profil dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Libellé du bouton flottant d'ajout
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addButton;

  /// Filtre de catégorie : tous les titres
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// Message d'accueil personnalisé
  ///
  /// In fr, this message translates to:
  /// **'Hiii {name}! 👋'**
  String homeGreeting(String name);

  /// Titre de l'écran d'ajout
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un titre'**
  String get addScreenTitle;

  /// Bouton de validation du formulaire d'ajout
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveButton;

  /// Titre de l'écran de profil
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileScreenTitle;

  /// Libellé du switch de thème sombre
  ///
  /// In fr, this message translates to:
  /// **'Thème sombre'**
  String get darkModeLabel;

  /// Titre de l'écran de recherche
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get searchScreenTitle;

  /// Texte indicatif du champ de recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un K-drama ou un anime...'**
  String get searchHint;

  /// Statut de visionnage : à voir
  ///
  /// In fr, this message translates to:
  /// **'À voir'**
  String get statusToWatch;

  /// Statut de visionnage : en cours
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusWatching;

  /// Statut de visionnage : vu
  ///
  /// In fr, this message translates to:
  /// **'Vu'**
  String get statusWatched;

  /// Label d'accessibilité pour une étoile de notation
  ///
  /// In fr, this message translates to:
  /// **'Noter {value} sur 5'**
  String starRatingSemanticLabel(int value);

  /// Label d'accessibilité résumant une carte de titre
  ///
  /// In fr, this message translates to:
  /// **'{title}, catégorie {category}, statut {status}'**
  String posterCardSemanticLabel(String title, String category, String status);

  /// No description provided for @editScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le titre'**
  String get editScreenTitle;

  /// No description provided for @updateButton.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get updateButton;

  /// No description provided for @titleFieldLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get titleFieldLabel;

  /// No description provided for @titleRequiredError.
  ///
  /// In fr, this message translates to:
  /// **'Le titre est obligatoire'**
  String get titleRequiredError;

  /// No description provided for @categoryFieldLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryFieldLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
