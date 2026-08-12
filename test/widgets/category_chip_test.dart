import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/widgets/category_chip.dart';
import 'package:didis_pop/models/watchable.dart';

void main() {
  group('CategoryChip Widget', () {
    testWidgets('CategoryChip displays correct label for K-drama',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: Category.kdrama),
          ),
        ),
      );

      expect(find.text('K-drama'), findsOneWidget);
    });

    testWidgets('CategoryChip displays correct label for Anime',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: Category.anime),
          ),
        ),
      );

      expect(find.text('Anime'), findsOneWidget);
    });
  });
}
