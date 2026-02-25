import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_dark_color_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_elevation_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_light_color_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_shape_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_spacing_theme.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_typography_theme.dart';

/// Orchestrator that wires all design system theme extensions
/// into Flutter's [ThemeData] and maps tokens to Material's [ColorScheme].
abstract final class HublaThemes {
  static const _lightColors = HublaLightColorTheme();
  static const _darkColors = HublaDarkColorTheme();
  static final _typography = HublaTypographyTheme();
  static const _spacing = HublaSpacingTheme();
  static const _shape = HublaShapeTheme();
  static const _elevation = HublaElevationTheme();

  /// Light theme with joyful sunshine palette.
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _lightColors.sky,
      onPrimary: _lightColors.white,
      primaryContainer: _lightColors.skyLight,
      onPrimaryContainer: _lightColors.skyDark,
      secondary: _lightColors.sun,
      onSecondary: _lightColors.gray90,
      secondaryContainer: _lightColors.sunLight,
      onSecondaryContainer: _lightColors.sunDark,
      tertiary: _lightColors.core,
      onTertiary: _lightColors.white,
      tertiaryContainer: _lightColors.coreLight,
      onTertiaryContainer: _lightColors.coreDark,
      error: _lightColors.danger,
      onError: _lightColors.white,
      errorContainer: _lightColors.dangerLight,
      onErrorContainer: _lightColors.dangerDark,
      surface: _lightColors.surface,
      onSurface: _lightColors.onSurface,
      surfaceContainerHighest: _lightColors.surfaceVariant,
      onSurfaceVariant: _lightColors.onSurfaceVariant,
      outline: _lightColors.gray40,
      outlineVariant: _lightColors.gray20,
    ),
    scaffoldBackgroundColor: _lightColors.surface,
    extensions: [_lightColors, _typography, _spacing, _shape, _elevation],
  );

  /// Dark theme with muted, deeper tones.
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _darkColors.sky,
      onPrimary: _darkColors.gray90,
      primaryContainer: _darkColors.skyLight,
      onPrimaryContainer: _darkColors.skyDark,
      secondary: _darkColors.sun,
      onSecondary: _darkColors.gray10,
      secondaryContainer: _darkColors.sunLight,
      onSecondaryContainer: _darkColors.sunDark,
      tertiary: _darkColors.core,
      onTertiary: _darkColors.gray10,
      tertiaryContainer: _darkColors.coreLight,
      onTertiaryContainer: _darkColors.coreDark,
      error: _darkColors.danger,
      onError: _darkColors.gray10,
      errorContainer: _darkColors.dangerLight,
      onErrorContainer: _darkColors.dangerDark,
      surface: _darkColors.surface,
      onSurface: _darkColors.onSurface,
      surfaceContainerHighest: _darkColors.surfaceVariant,
      onSurfaceVariant: _darkColors.onSurfaceVariant,
      outline: _darkColors.gray50,
      outlineVariant: _darkColors.gray30,
    ),
    scaffoldBackgroundColor: _darkColors.surface,
    extensions: [_darkColors, _typography, _spacing, _shape, _elevation],
  );
}
