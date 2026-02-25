import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_shape_theme.dart';

void main() {
  group('HublaShapeTheme', () {
    const shape = HublaShapeTheme();

    test('should have monotonically increasing values', () {
      final values = [
        shape.none,
        shape.extraSmall,
        shape.small,
        shape.medium,
        shape.large,
        shape.largeIncreased,
        shape.extraLarge,
        shape.extraLargeIncreased,
        shape.extraExtraLarge,
        shape.full,
      ];

      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: 'Shape value at index $i should be greater than value at index ${i - 1}',
        );
      }
    });

    test('should start at zero for none', () {
      expect(shape.none, 0);
    });

    test('should have non-negative values', () {
      final values = [
        shape.none,
        shape.extraSmall,
        shape.small,
        shape.medium,
        shape.large,
        shape.largeIncreased,
        shape.extraLarge,
        shape.extraLargeIncreased,
        shape.extraExtraLarge,
        shape.full,
      ];

      for (final value in values) {
        expect(value, greaterThanOrEqualTo(0), reason: 'All shape values should be non-negative');
      }
    });
  });
}
