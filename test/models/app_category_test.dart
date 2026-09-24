import 'package:flutter_test/flutter_test.dart';
import 'package:didis_pop/models/app_category.dart';

void main() {
  group('AppCategory', () {
    test('defaults() returns K-drama and Anime with their historical ids',
        () {
      final defaults = AppCategory.defaults();

      expect(defaults.length, 2);
      expect(defaults[0].id, 'kdrama');
      expect(defaults[0].name, 'K-drama');
      expect(defaults[1].id, 'anime');
      expect(defaults[1].name, 'Anime');
    });

    test('colorForIndex wraps around the palette', () {
      final paletteLength = AppCategory.palette.length;

      expect(
        AppCategory.colorForIndex(0),
        AppCategory.colorForIndex(paletteLength),
      );
      expect(
        AppCategory.colorForIndex(1),
        AppCategory.colorForIndex(paletteLength + 1),
      );
    });

    test('toJson/fromJson round-trip preserves all fields', () {
      const category =
          AppCategory(id: 'film', name: 'Film', colorValue: 0xFF123456);

      final restored = AppCategory.fromJson(category.toJson());

      expect(restored.id, category.id);
      expect(restored.name, category.name);
      expect(restored.colorValue, category.colorValue);
    });

    test('color getter converts colorValue into a Color', () {
      const category =
          AppCategory(id: 'x', name: 'X', colorValue: 0xFFAABBCC);

      expect(category.color.toARGB32(), 0xFFAABBCC);
    });
  });
}
