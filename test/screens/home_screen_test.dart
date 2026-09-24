import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:didis_pop/l10n/app_localizations.dart';
import 'package:didis_pop/screens/home_screen.dart';
import 'package:didis_pop/app_state.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

/// Pompe des frames jusqu'à ce que [finder] trouve quelque chose (ou jusqu'à
/// [maxTries] essais). Contrairement à `pumpAndSettle()`, ça ne boucle pas
/// indéfiniment : la grille affiche des `CachedNetworkImage` dont le
/// placeholder (`CircularProgressIndicator`) anime en continu tant que
/// l'image n'a pas fini de charger, ce qui empêcherait `pumpAndSettle` de
/// jamais se terminer. Contrairement à un `pump(duration)` fixe, ça ne
/// dépend pas non plus de la vitesse de la machine qui exécute le test.
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

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HomeScreen Widget', () {
    testWidgets('HomeScreen displays the grid and the greeting',
        (WidgetTester tester) async {
      final appState = AppState();
      await appState.load();
      await tester.pumpWidget(_wrap(HomeScreen(appState: appState)));
      await tester.pump();

      // La grille est affichée dès l'ouverture, avec au moins un titre de
      // démo.
      expect(find.byType(GridView), findsOneWidget);
      expect(find.textContaining('Hiii'), findsOneWidget);
    });

    testWidgets(
        'Opening the filters sheet shows category chips and filters by category',
        (WidgetTester tester) async {
      final appState = AppState();
      await appState.load();
      await tester.pumpWidget(_wrap(HomeScreen(appState: appState)));
      await tester.pump();

      // Les chips de filtrage ne sont pas visibles tant que la feuille de
      // filtres n'est pas ouverte.
      expect(find.text('Tous'), findsNothing);

      await tester.tap(find.text('Filtres'));
      await tester.pump();
      await _pumpUntilFound(tester, find.byType(BottomSheet));

      // La grille reste dans l'arbre de widgets sous la feuille modale (ses
      // propres cartes affichent aussi "K-drama"/"Anime" via CategoryChip),
      // donc on restreint la recherche à la feuille de filtres elle-même.
      final sheet = find.byType(BottomSheet);
      expect(sheet, findsOneWidget);
      Finder inSheet(String text) =>
          find.descendant(of: sheet, matching: find.text(text));

      expect(inSheet('Tous'), findsWidgets);
      expect(inSheet('K-drama'), findsOneWidget);
      expect(inSheet('Anime'), findsOneWidget);

      await tester.tap(inSheet('K-drama'));
      await tester.pump(const Duration(milliseconds: 300));

      // Fermer la feuille (tap en dehors) et vérifier que la grille est
      // toujours affichée, filtrée.
      await tester.tapAt(const Offset(200, 100));
      await tester.pump();
      await _pumpUntilFound(tester, find.byType(GridView));
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
