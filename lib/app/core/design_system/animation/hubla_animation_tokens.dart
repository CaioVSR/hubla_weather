import 'package:flutter/material.dart';

/// Animation tokens for the Hubla Weather design system.
///
/// Static constants for durations and curves, following M3's
/// easing + duration system. Not a ThemeExtension since
/// animation values don't change between light/dark themes.
abstract final class HublaAnimationTokens {
  // ── Durations ──

  /// 50ms — micro interactions (e.g., icon state change)
  static const Duration short1 = Duration(milliseconds: 50);

  /// 100ms — quick feedback (e.g., ripple start)
  static const Duration short2 = Duration(milliseconds: 100);

  /// 150ms — small element transitions (e.g., switch toggle)
  static const Duration short3 = Duration(milliseconds: 150);

  /// 200ms — standard small transition
  static const Duration short4 = Duration(milliseconds: 200);

  /// 250ms — medium transition start
  static const Duration medium1 = Duration(milliseconds: 250);

  /// 300ms — standard transition (default for most animations)
  static const Duration medium2 = Duration(milliseconds: 300);

  /// 350ms — page element entrance
  static const Duration medium3 = Duration(milliseconds: 350);

  /// 400ms — complex element transition
  static const Duration medium4 = Duration(milliseconds: 400);

  /// 450ms — large area transition start
  static const Duration long1 = Duration(milliseconds: 450);

  /// 500ms — full-screen transition
  static const Duration long2 = Duration(milliseconds: 500);

  /// 550ms — complex page transition
  static const Duration long3 = Duration(milliseconds: 550);

  /// 600ms — elaborate transition
  static const Duration long4 = Duration(milliseconds: 600);

  /// 800ms — extra long transition (e.g., loading shimmer)
  static const Duration extraLong = Duration(milliseconds: 800);

  // ── Curves ──

  /// Standard easing — used for most transitions
  static const Curve standard = Curves.easeInOutCubicEmphasized;

  /// Standard accelerate — element leaving the screen
  static const Curve standardAccelerate = Curves.easeInCubic;

  /// Standard decelerate — element entering the screen
  static const Curve standardDecelerate = Curves.easeOutCubic;

  /// Emphasized — hero transitions, important state changes
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Emphasized accelerate — element leaving with emphasis
  static const Curve emphasizedAccelerate = Curves.easeInQuart;

  /// Emphasized decelerate — element arriving with emphasis
  static const Curve emphasizedDecelerate = Curves.easeOutQuart;
}
