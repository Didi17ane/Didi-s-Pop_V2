// Tests d'intégration : ils font tourner plusieurs écrans ensemble à
// travers de vraies interactions (tap, saisie, navigation) plutôt que
// d'isoler un seul widget. Nécessitent le package `integration_test`
// (déjà ajouté en dev_dependency) et un device (voir README : émulateur
// Android ou support desktop activé — le mode web n'est pas supporté par
// `flutter test integration_test`).
//
// Lancer avec : flutter test integration_test/app_flow_test.dart -d <device>
// (ou `flutter test integration_test` pour tout le dossier).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:didis_pop/app_state.dart';
import 'package:didis_pop/l10n/app_localizations.dart';
import 'package:didis_pop/router/app_router.dart';

/// Pompe des frames jusqu'à ce que [finder] trouve quelque chose (ou jusqu'à
/// [maxTries] essais). Contrairement à `pumpAndSettle()`, ça ne boucle pas
/// indéfiniment : les écrans affichent des `CachedNetworkImage` dont le
/// placeholder (`CircularProgressIndicator`) anime en continu tant que
/// l'image n'a pas fini de charger, ce qui empêcherait `pumpAndSettle` de
/// jamais se terminer.
Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 100),
  int maxTries = 50,
}) async {
  for (var i = 0; i < maxTries; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(step);
  }
}

/// Symétrique de [_pumpUntilFound] : attend que [finder] ne trouve plus
/// rien. Utile pour être sûr qu'un écran précédent (ex. AddScreen après
/// navigation vers l'accueil) a bien fini d'être démonté avant de vérifier
/// l'unicité d'un texte à l'écran.
Future<void> _pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 100),
  int maxTries = 50,
}) async {
  for (var i = 0; i < maxTries; i++) {
    if (finder.evaluate().isEmpty) return;
    await tester.pump(step);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> loadedAppState() async {
    final appState = AppState();
    await appState.load();
    return appState;
  }

  Widget appFor(AppState appState) {
    return MaterialApp.router(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: buildAppRouter(appState),
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Parcours complet', () {
    testWidgets(
        "Ajouter un titre depuis l'accueil le fait apparaître dans la grille "
        'et survit à un redémarrage', (tester) async {
      final appState = await loadedAppState();
      await tester.pumpWidget(appFor(appState));
      await tester.pump();
      await _pumpUntilFound(tester, find.byIcon(Icons.add));

      // Ouvre l'écran d'ajout.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await _pumpUntilFound(
          tester, find.widgetWithText(TextFormField, 'Titre'));

      // Remplit le formulaire. On fournit une URL d'image manuellement
      // pour ne pas dépendre d'un appel réseau réel pendant le test.
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Titre'), 'Solo Leveling');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Image (URL) — optionnel'),
        'https://example.com/poster.jpg',
      );

      await tester.tap(find.text('Enregistrer'));
      await tester.pump();
      // On attend que le champ "Titre" de l'écran d'ajout ait totalement
      // disparu (transition de route terminée) avant de vérifier
      // l'unicité : sinon, pendant la transition, le champ (encore affiché
      // avec "Solo Leveling" dedans) et la nouvelle carte de la grille
      // coexistent brièvement, ce qui ferait échouer `findsOneWidget`.
      await _pumpUntilGone(tester, find.widgetWithText(TextFormField, 'Titre'));
      await _pumpUntilFound(tester, find.text('Solo Leveling'));

      // De retour à l'accueil, le nouveau titre est visible dans la grille.
      expect(find.text('Solo Leveling'), findsOneWidget);

      // Un nouvel AppState (simulant un redémarrage de l'app) doit
      // retrouver le titre depuis shared_preferences.
      final restarted = await loadedAppState();
      expect(
        restarted.items.any((w) => w.title == 'Solo Leveling'),
        true,
      );
    });

    testWidgets(
        'Changer le thème depuis le profil le répercute immédiatement et '
        'il est conservé après redémarrage', (tester) async {
      final appState = await loadedAppState();
      await tester.pumpWidget(appFor(appState));
      await tester.pump();
      await _pumpUntilFound(tester, find.byIcon(Icons.person_outline));

      expect(appState.themeMode, ThemeMode.light);

      // Onglet Profil (dernier item de la barre de navigation).
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();
      await _pumpUntilFound(tester, find.byType(SwitchListTile));

      // Le message de Flutter suggère que le widget peut être hors-écran :
      // ProfileScreen est un SingleChildScrollView, et selon la hauteur de
      // l'écran/du contenu (catégories + préférences), le switch peut être
      // en dehors du viewport tant qu'on n'a pas scrollé jusqu'à lui.
      // `ensureVisible` scrolle jusqu'à ce qu'il soit garanti visible avant
      // de taper (contrairement à `pumpAndSettle`, l'animation de scroll
      // est bornée, donc ça ne peut pas boucler indéfiniment).
      final switchLabel = find.text('Thème sombre');
      await tester.ensureVisible(switchLabel);
      await tester.pump();

      await tester.tap(switchLabel);
      await tester.pump();

      expect(appState.themeMode, ThemeMode.dark);

      final restarted = await loadedAppState();
      expect(restarted.themeMode, ThemeMode.dark);
    });
  });
}
