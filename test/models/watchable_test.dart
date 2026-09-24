import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/models/watchable.dart';
import 'package:didis_pop/models/app_category.dart';

void main() {
  group('Watchable Model', () {
    test('Watchable creation with valid data', () {
      const watchable = Watchable(
        id: '1',
        title: 'Test Title',
        categoryId: 'kdrama',
        rating: 8.5,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test synopsis',
      );

      expect(watchable.id, '1');
      expect(watchable.title, 'Test Title');
      expect(watchable.categoryId, 'kdrama');
      expect(watchable.rating, 8.5);
      expect(watchable.imageUrl, 'https://example.com/image.jpg');
      expect(watchable.synopsis, 'Test synopsis');
    });

    test('Default categories have the expected names', () {
      final defaults = AppCategory.defaults();
      expect(defaults.firstWhere((c) => c.id == 'kdrama').name, 'K-drama');
      expect(defaults.firstWhere((c) => c.id == 'anime').name, 'Anime');
    });

    test('Rating can be 0 to 10', () {
      const watchable1 = Watchable(
        id: '1',
        title: 'Low Rating',
        categoryId: 'anime',
        rating: 0,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test',
      );

      const watchable2 = Watchable(
        id: '2',
        title: 'High Rating',
        categoryId: 'anime',
        rating: 10,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test',
      );

      expect(watchable1.rating, 0);
      expect(watchable2.rating, 10);
    });
  });
}