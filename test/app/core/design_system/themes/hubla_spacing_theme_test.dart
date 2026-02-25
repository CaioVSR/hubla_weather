import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_spacing_theme.dart';

void main() {
  group('HublaSpacingTheme', () {
    const spacing = HublaSpacingTheme();

    test('should have monotonically increasing values', () {
      final values = [
        spacing.xxxs,
        spacing.xxs,
        spacing.xs,
        spacing.sm,
        spacing.md,
        spacing.lg,
        spacing.xl,
        spacing.xxl,
        spacing.xxxl,
      ];

      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: 'Spacing value at index $i should be greater than value at index ${i - 1}',
        );
      }
    });

    test('should have all positive values', () {
      final values = [
        spacing.xxxs,
        spacing.xxs,
        spacing.xs,
        spacing.sm,
        spacing.md,
        spacing.lg,
        spacing.xl,
        spacing.xxl,
        spacing.xxxl,
      ];

      for (final value in values) {
        expect(value, greaterThan(0), reason: 'All spacing values should be positive');
      }
    });
  });
}
