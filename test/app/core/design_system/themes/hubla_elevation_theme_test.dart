import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_elevation_theme.dart';

void main() {
  group('HublaElevationTheme', () {
    const elevation = HublaElevationTheme();

    test('should have monotonically increasing values', () {
      final values = [
        elevation.level0,
        elevation.level1,
        elevation.level2,
        elevation.level3,
        elevation.level4,
        elevation.level5,
      ];

      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: 'Elevation level $i should be greater than level ${i - 1}',
        );
      }
    });

    test('should start at zero for level0', () {
      expect(elevation.level0, 0);
    });

    test('should have non-negative values', () {
      final values = [
        elevation.level0,
        elevation.level1,
        elevation.level2,
        elevation.level3,
        elevation.level4,
        elevation.level5,
      ];

      for (final value in values) {
        expect(value, greaterThanOrEqualTo(0), reason: 'All elevation values should be non-negative');
      }
    });
  });
}
