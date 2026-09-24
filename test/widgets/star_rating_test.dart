import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/l10n/app_localizations.dart';
import 'package:didis_pop/widgets/star_rating.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('StarRating Widget', () {
    testWidgets('displays 5 stars and fills them according to value',
        (tester) async {
      await tester.pumpWidget(_wrap(const StarRating(value: 3)));

      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('tapping a star calls onChanged with the tapped star number',
        (tester) async {
      int? tappedValue;
      await tester.pumpWidget(
        _wrap(StarRating(
          value: 2,
          onChanged: (value) => tappedValue = value,
        )),
      );

      // Tape la 4e étoile.
      final semantics = find.bySemanticsLabel('Noter 4 sur 5');
      expect(semantics, findsOneWidget);
      await tester.tap(semantics);
      await tester.pump();

      expect(tappedValue, 4);
    });

    testWidgets('read-only mode (no onChanged) is not tappable',
        (tester) async {
      await tester.pumpWidget(_wrap(const StarRating(value: 4)));

      expect(find.byType(InkWell), findsNothing);
    });
  });
}