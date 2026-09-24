import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/l10n/app_localizations.dart';
import 'package:didis_pop/models/app_category.dart';
import 'package:didis_pop/models/watchable.dart';
import 'package:didis_pop/widgets/poster_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(width: 200, height: 300, child: child)),
  );
}

const _category =
    AppCategory(id: 'kdrama', name: 'K-drama', colorValue: 0xFF9A5CB4);

Watchable _item({WatchStatus status = WatchStatus.watching}) => Watchable(
      id: '1',
      title: 'Crash Landing on You',
      categoryId: 'kdrama',
      rating: 9.0,
      imageUrl: 'https://example.com/poster.jpg',
      synopsis: '...',
      status: status,
    );

void main() {
  group('PosterCard Widget', () {
    testWidgets('displays the title and category, and reacts to a tap',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(PosterCard(
        item: _item(),
        category: _category,
        onTap: () => tapped = true,
      )));
      await tester.pump();

      expect(find.text('Crash Landing on You'), findsOneWidget);
      expect(find.text('K-drama'), findsOneWidget);

      await tester.tap(find.byType(PosterCard));
      expect(tapped, true);
    });

    testWidgets(
        'exposes a single accessible semantic label combining title, '
        'category and status', (tester) async {
      await tester.pumpWidget(_wrap(PosterCard(
        item: _item(status: WatchStatus.watched),
        category: _category,
        onTap: () {},
      )));
      await tester.pump();

      expect(
        find.bySemanticsLabel('Crash Landing on You, catégorie K-drama, '
            'statut Vu'),
        findsOneWidget,
      );
    });
  });
}