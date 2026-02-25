import 'package:flutter/material.dart';

/// Spacing token scale for the Hubla Weather design system.
///
/// Provides a consistent 9-step spacing scale from 2dp to 64dp.
class HublaSpacingTokens extends ThemeExtension<HublaSpacingTokens> {
  const HublaSpacingTokens({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// 2dp
  final double xxxs;

  /// 4dp
  final double xxs;

  /// 8dp
  final double xs;

  /// 12dp
  final double sm;

  /// 16dp
  final double md;

  /// 24dp
  final double lg;

  /// 32dp
  final double xl;

  /// 48dp
  final double xxl;

  /// 64dp
  final double xxxl;

  @override
  HublaSpacingTokens copyWith() => this;

  @override
  HublaSpacingTokens lerp(covariant ThemeExtension<HublaSpacingTokens>? other, double t) => this;
}
