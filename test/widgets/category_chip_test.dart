import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/widgets/category_chip.dart';
import 'package:didis_pop/models/app_category.dart';

void main() {
  group('CategoryChip Widget', () {
    testWidgets('CategoryChip displays correct label for K-drama',
        (WidgetTester tester) async {
      const category =
          AppCategory(id: 'kdrama', name: 'K-drama', colorValue: 0xFF9A5CB4);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: category),
          ),
        ),
      );

      expect(find.text('K-drama'), findsOneWidget);
    });

    testWidgets('CategoryChip displays correct label for Anime',
        (WidgetTester tester) async {
      const category =
          AppCategory(id: 'anime', name: 'Anime', colorValue: 0xFFF4A8C0);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: category),
          ),
        ),
      );

      expect(find.text('Anime'), findsOneWidget);
    });
  });
}
