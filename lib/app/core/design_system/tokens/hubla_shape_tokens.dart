import 'package:flutter/material.dart';

/// Shape token scale for the Hubla Weather design system.
///
/// Follows M3's 10-step corner radius scale.
class HublaShapeTokens extends ThemeExtension<HublaShapeTokens> {
  const HublaShapeTokens({
    required this.none,
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.largeIncreased,
    required this.extraLarge,
    required this.extraLargeIncreased,
    required this.extraExtraLarge,
    required this.full,
  });

  /// 0dp — no rounding
  final double none;

  /// 4dp
  final double extraSmall;

  /// 8dp
  final double small;

  /// 12dp
  final double medium;

  /// 16dp
  final double large;

  /// 20dp
  final double largeIncreased;

  /// 28dp
  final double extraLarge;

  /// 32dp
  final double extraLargeIncreased;

  /// 48dp
  final double extraExtraLarge;

  /// 999dp — fully rounded
  final double full;

  @override
  HublaShapeTokens copyWith() => this;

  @override
  HublaShapeTokens lerp(covariant ThemeExtension<HublaShapeTokens>? other, double t) => this;
}
