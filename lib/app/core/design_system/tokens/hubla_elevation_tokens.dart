import 'package:flutter/material.dart';

/// Elevation token scale for the Hubla Weather design system.
///
/// Follows M3's 6-level elevation system (levels 0–5).
class HublaElevationTokens extends ThemeExtension<HublaElevationTokens> {
  const HublaElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  /// 0dp — flat surface
  final double level0;

  /// 1dp — banners, bottom sheets, elevated buttons/cards/chips
  final double level1;

  /// 3dp — app bar (scrolled), menus, navigation bar, tooltips
  final double level2;

  /// 6dp — dialogs, FABs, date/time pickers
  final double level3;

  /// 8dp — hover elevation increase
  final double level4;

  /// 12dp — maximum elevation
  final double level5;

  @override
  HublaElevationTokens copyWith() => this;

  @override
  HublaElevationTokens lerp(covariant ThemeExtension<HublaElevationTokens>? other, double t) => this;
}
