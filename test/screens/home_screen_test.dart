import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:didis_pop/screens/home_screen.dart';
import 'package:didis_pop/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HomeScreen Widget', () {
    testWidgets('HomeScreen displays filter chips and grid',
        (WidgetTester tester) async {
      final appState = AppState()..load();
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(appState: appState),
        ),
      );
      await tester.pump();

      // Vérifier que les chips de filtrage sont présentes
      expect(find.text('Tous'), findsOneWidget);
      expect(find.text('K-drama'), findsOneWidget);
      expect(find.text('Anime'), findsOneWidget);

      // Vérifier que la grille est affichée
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('HomeScreen filters by category', (WidgetTester tester) async {
      final appState = AppState()..load();
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(appState: appState),
        ),
      );
      await tester.pump();

      // Cliquer sur le chip K-drama
      await tester.tap(find.text('K-drama'));
      await tester.pumpAndSettle();

      // La grille devrait toujours être présente
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
