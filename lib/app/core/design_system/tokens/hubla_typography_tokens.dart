import 'package:flutter/material.dart';

/// Typography token scale for the Hubla Weather design system.
///
/// Follows M3's 5 roles × 3 sizes = 15 text styles.
class HublaTypographyTokens extends ThemeExtension<HublaTypographyTokens> {
  const HublaTypographyTokens({
    // Display
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    // Headline
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    // Title
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    // Body
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    // Label
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  // Display
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;

  // Headline
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;

  // Title
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;

  // Body
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;

  // Label
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  @override
  HublaTypographyTokens copyWith() => this;

  @override
  HublaTypographyTokens lerp(covariant ThemeExtension<HublaTypographyTokens>? other, double t) => this;
}
