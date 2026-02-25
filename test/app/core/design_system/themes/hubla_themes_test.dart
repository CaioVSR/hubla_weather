import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_dark_color_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_light_color_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_themes.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_elevation_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_shape_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_spacing_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_typography_tokens.dart';

import '../../../../helpers/google_fonts_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(setUpGoogleFontsMocks);
  tearDown(tearDownGoogleFontsMocks);

  group('HublaThemes', () {
    group('lightTheme', () {
      late ThemeData theme;

      setUp(() {
        theme = HublaThemes.lightTheme;
      });

      test('should have light brightness', () {
        expect(theme.brightness, Brightness.light);
      });

      test('should contain HublaColorTokens extension', () {
        expect(theme.extension<HublaColorTokens>(), isNotNull);
        expect(theme.extension<HublaColorTokens>(), isA<HublaLightColorTheme>());
      });

      test('should contain HublaTypographyTokens extension', () {
        expect(theme.extension<HublaTypographyTokens>(), isNotNull);
      });

      test('should contain HublaSpacingTokens extension', () {
        expect(theme.extension<HublaSpacingTokens>(), isNotNull);
      });

      test('should contain HublaShapeTokens extension', () {
        expect(theme.extension<HublaShapeTokens>(), isNotNull);
      });

      test('should contain HublaElevationTokens extension', () {
        expect(theme.extension<HublaElevationTokens>(), isNotNull);
      });

      test('should map primary to sky color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.primary, colors.sky);
      });

      test('should map secondary to sun color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.secondary, colors.sun);
      });

      test('should map tertiary to core color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.tertiary, colors.core);
      });

      test('should map error to danger color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.error, colors.danger);
      });

      test('should map surface colors', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.surface, colors.surface);
        expect(theme.colorScheme.onSurface, colors.onSurface);
      });

      test('should set scaffoldBackgroundColor to surface', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.scaffoldBackgroundColor, colors.surface);
      });
    });

    group('darkTheme', () {
      late ThemeData theme;

      setUp(() {
        theme = HublaThemes.darkTheme;
      });

      test('should have dark brightness', () {
        expect(theme.brightness, Brightness.dark);
      });

      test('should contain HublaColorTokens extension', () {
        expect(theme.extension<HublaColorTokens>(), isNotNull);
        expect(theme.extension<HublaColorTokens>(), isA<HublaDarkColorTheme>());
      });

      test('should contain HublaTypographyTokens extension', () {
        expect(theme.extension<HublaTypographyTokens>(), isNotNull);
      });

      test('should contain HublaSpacingTokens extension', () {
        expect(theme.extension<HublaSpacingTokens>(), isNotNull);
      });

      test('should contain HublaShapeTokens extension', () {
        expect(theme.extension<HublaShapeTokens>(), isNotNull);
      });

      test('should contain HublaElevationTokens extension', () {
        expect(theme.extension<HublaElevationTokens>(), isNotNull);
      });

      test('should map primary to sky color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.primary, colors.sky);
      });

      test('should map secondary to sun color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.secondary, colors.sun);
      });

      test('should map tertiary to core color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.tertiary, colors.core);
      });

      test('should map error to danger color', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.error, colors.danger);
      });

      test('should map surface colors', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.colorScheme.surface, colors.surface);
        expect(theme.colorScheme.onSurface, colors.onSurface);
      });

      test('should set scaffoldBackgroundColor to surface', () {
        final colors = theme.extension<HublaColorTokens>()!;
        expect(theme.scaffoldBackgroundColor, colors.surface);
      });
    });

    test('should have exactly 5 extensions in both themes', () {
      expect(HublaThemes.lightTheme.extensions.values.length, 5);
      expect(HublaThemes.darkTheme.extensions.values.length, 5);
    });
  });
}
