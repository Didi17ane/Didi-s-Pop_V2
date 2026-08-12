import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/models/watchable.dart';

void main() {
  group('Watchable Model', () {
    test('Watchable creation with valid data', () {
      final watchable = Watchable(
        id: '1',
        title: 'Test Title',
        category: Category.kdrama,
        rating: 8.5,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test synopsis',
      );

      expect(watchable.id, '1');
      expect(watchable.title, 'Test Title');
      expect(watchable.category, Category.kdrama);
      expect(watchable.rating, 8.5);
      expect(watchable.imageUrl, 'https://example.com/image.jpg');
      expect(watchable.synopsis, 'Test synopsis');
    });

    test('Category label is correct', () {
      expect(Category.kdrama.label, 'K-drama');
      expect(Category.anime.label, 'Anime');
    });

    test('Rating can be 0 to 10', () {
      final watchable1 = Watchable(
        id: '1',
        title: 'Low Rating',
        category: Category.anime,
        rating: 0,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test',
      );

      final watchable2 = Watchable(
        id: '2',
        title: 'High Rating',
        category: Category.anime,
        rating: 10,
        imageUrl: 'https://example.com/image.jpg',
        synopsis: 'Test',
      );

      expect(watchable1.rating, 0);
      expect(watchable2.rating, 10);
    });
  });
}
