import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_typography_theme.dart';

import '../../../../helpers/google_fonts_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(setUpGoogleFontsMocks);
  tearDown(tearDownGoogleFontsMocks);

  group('HublaTypographyTheme', () {
    late HublaTypographyTheme typography;

    setUp(() {
      typography = HublaTypographyTheme();
    });

    test('should have all 15 text styles with non-null fontSize', () {
      final styles = [
        typography.displayLarge,
        typography.displayMedium,
        typography.displaySmall,
        typography.headlineLarge,
        typography.headlineMedium,
        typography.headlineSmall,
        typography.titleLarge,
        typography.titleMedium,
        typography.titleSmall,
        typography.bodyLarge,
        typography.bodyMedium,
        typography.bodySmall,
        typography.labelLarge,
        typography.labelMedium,
        typography.labelSmall,
      ];

      for (final style in styles) {
        expect(style.fontSize, isNotNull, reason: 'Every text style should have a fontSize');
      }
    });

    test('should have display sizes in descending order', () {
      expect(typography.displayLarge.fontSize, greaterThan(typography.displayMedium.fontSize!));
      expect(typography.displayMedium.fontSize, greaterThan(typography.displaySmall.fontSize!));
    });

    test('should have headline sizes in descending order', () {
      expect(typography.headlineLarge.fontSize, greaterThan(typography.headlineMedium.fontSize!));
      expect(typography.headlineMedium.fontSize, greaterThan(typography.headlineSmall.fontSize!));
    });

    test('should have title sizes in descending order', () {
      expect(typography.titleLarge.fontSize, greaterThan(typography.titleMedium.fontSize!));
      expect(typography.titleMedium.fontSize, greaterThan(typography.titleSmall.fontSize!));
    });

    test('should have body sizes in descending order', () {
      expect(typography.bodyLarge.fontSize, greaterThan(typography.bodyMedium.fontSize!));
      expect(typography.bodyMedium.fontSize, greaterThan(typography.bodySmall.fontSize!));
    });

    test('should have label sizes in descending order', () {
      expect(typography.labelLarge.fontSize, greaterThan(typography.labelMedium.fontSize!));
      expect(typography.labelMedium.fontSize, greaterThan(typography.labelSmall.fontSize!));
    });

    test('should use Rubik font family for all styles', () {
      final styles = [
        typography.displayLarge,
        typography.displayMedium,
        typography.displaySmall,
        typography.headlineLarge,
        typography.headlineMedium,
        typography.headlineSmall,
        typography.titleLarge,
        typography.titleMedium,
        typography.titleSmall,
        typography.bodyLarge,
        typography.bodyMedium,
        typography.bodySmall,
        typography.labelLarge,
        typography.labelMedium,
        typography.labelSmall,
      ];

      for (final style in styles) {
        expect(style.fontFamily, contains('Rubik'), reason: 'All text styles should use the Rubik font');
      }
    });

    test('should have non-null lineHeight for all styles', () {
      final styles = [
        typography.displayLarge,
        typography.displayMedium,
        typography.displaySmall,
        typography.headlineLarge,
        typography.headlineMedium,
        typography.headlineSmall,
        typography.titleLarge,
        typography.titleMedium,
        typography.titleSmall,
        typography.bodyLarge,
        typography.bodyMedium,
        typography.bodySmall,
        typography.labelLarge,
        typography.labelMedium,
        typography.labelSmall,
      ];

      for (final style in styles) {
        expect(style.height, isNotNull, reason: 'Every text style should have a line height');
      }
    });
  });
}
