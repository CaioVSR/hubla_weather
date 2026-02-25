import 'package:flutter/material.dart';

/// Abstract color token contract for the Hubla Weather design system.
///
/// Defines all available color roles. Concrete implementations
/// provide actual values for light and dark themes.
abstract class HublaColorTokens extends ThemeExtension<HublaColorTokens> {
  const HublaColorTokens({
    // Primary — Sunshine
    required this.sunDark,
    required this.sun,
    required this.sunLight,
    // Secondary — Sky
    required this.skyDark,
    required this.sky,
    required this.skyLight,
    // Tertiary — Core
    required this.coreDark,
    required this.core,
    required this.coreLight,
    // Accent — Coral
    required this.coralDark,
    required this.coral,
    required this.coralLight,
    // Accent — Mint
    required this.mintDark,
    required this.mint,
    required this.mintLight,
    // Accent — Lavender
    required this.lavenderDark,
    required this.lavender,
    required this.lavenderLight,
    // Neutrals
    required this.gray90,
    required this.gray80,
    required this.gray70,
    required this.gray60,
    required this.gray50,
    required this.gray40,
    required this.gray30,
    required this.gray20,
    required this.gray10,
    required this.white,
    // Semantic — Success
    required this.successDark,
    required this.success,
    required this.successLight,
    // Semantic — Warning
    required this.warningDark,
    required this.warning,
    required this.warningLight,
    // Semantic — Danger
    required this.dangerDark,
    required this.danger,
    required this.dangerLight,
    // Semantic — Info
    required this.infoDark,
    required this.info,
    required this.infoLight,
    // Surface
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    // Gradient
    required this.backgroundGradient,
  });

  // Primary — Sunshine
  final Color sunDark;
  final Color sun;
  final Color sunLight;

  // Secondary — Sky
  final Color skyDark;
  final Color sky;
  final Color skyLight;

  // Tertiary — Core
  final Color coreDark;
  final Color core;
  final Color coreLight;

  // Accent — Coral
  final Color coralDark;
  final Color coral;
  final Color coralLight;

  // Accent — Mint
  final Color mintDark;
  final Color mint;
  final Color mintLight;

  // Accent — Lavender
  final Color lavenderDark;
  final Color lavender;
  final Color lavenderLight;

  // Neutrals
  final Color gray90;
  final Color gray80;
  final Color gray70;
  final Color gray60;
  final Color gray50;
  final Color gray40;
  final Color gray30;
  final Color gray20;
  final Color gray10;
  final Color white;

  // Semantic — Success
  final Color successDark;
  final Color success;
  final Color successLight;

  // Semantic — Warning
  final Color warningDark;
  final Color warning;
  final Color warningLight;

  // Semantic — Danger
  final Color dangerDark;
  final Color danger;
  final Color dangerLight;

  // Semantic — Info
  final Color infoDark;
  final Color info;
  final Color infoLight;

  // Surface
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;

  // Gradient
  final LinearGradient backgroundGradient;

  @override
  ThemeExtension<HublaColorTokens> copyWith() => this;

  @override
  ThemeExtension<HublaColorTokens> lerp(covariant ThemeExtension<HublaColorTokens>? other, double t) => this;
}
