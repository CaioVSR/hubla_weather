import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';

/// A themed full-screen loading dialog using the Hubla design system tokens.
///
/// Displays a playful weather-icon animation where icons drop from above,
/// bounce inside a cloud-shaped container, and overflow out the sides.
///
/// Use the static [show] and [hide] methods to manage its lifecycle — they
/// share a route name so that [hide] always pops the correct dialog, and
/// calling [show] twice without [hide] is safe (the second call is a no-op).
///
/// ```dart
/// HublaLoading.show(context);
/// await doSomethingAsync();
/// HublaLoading.hide(context);
/// ```
class HublaLoading extends StatelessWidget {
  const HublaLoading._();

  static const String _routeName = 'hubla-loading-dialog';

  /// Shows a non-dismissible loading overlay.
  ///
  /// Safe to call multiple times — subsequent calls are ignored if the
  /// dialog is already visible.
  static void show(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);

    // Prevent stacking duplicate dialogs.
    if (_isShowing(navigator)) {
      return;
    }

    navigator.push(
      DialogRoute<void>(
        context: context,
        barrierDismissible: false,
        settings: const RouteSettings(name: _routeName),
        builder: (_) => const HublaLoading._(),
      ),
    );
  }

  /// Hides the loading dialog if it is currently showing.
  ///
  /// Safe to call even when no dialog is present — the call is a no-op.
  static void hide(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);

    if (_isShowing(navigator)) {
      navigator.pop();
    }
  }

  static bool _isShowing(NavigatorState navigator) {
    var isShowing = false;
    navigator.popUntil((route) {
      if (route.settings.name == _routeName) {
        isShowing = true;
      }
      return true; // never actually pops
    });
    return isShowing;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final shape = context.hublaShape;
    final spacing = context.hublaSpacing;

    return Center(
      child: Container(
        width: 160,
        height: 160,
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(shape.extraLarge),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const _WeatherIconsAnimation(),
      ),
    );
  }
}

// ── Weather icon entries (icon + color pairs) ──

class _WeatherIconEntry {
  const _WeatherIconEntry(this.icon, this.color);

  final IconData icon;
  final Color color;
}

const _weatherIconEntries = [
  _WeatherIconEntry(Icons.wb_sunny_rounded, Color(0xFFFBBF24)),
  _WeatherIconEntry(Icons.cloud_rounded, Color(0xFF9CA3AF)),
  _WeatherIconEntry(Icons.water_drop_rounded, Color(0xFF38BDF8)),
  _WeatherIconEntry(Icons.thunderstorm_rounded, Color(0xFF6366F1)),
  _WeatherIconEntry(Icons.air_rounded, Color(0xFF78909C)),
  _WeatherIconEntry(Icons.ac_unit_rounded, Color(0xFF7DD3FC)),
];

// ── Animation widget ──

/// Shows one weather icon at a time in a drop → bounce → fall loop.
/// As the current icon falls out, the next one drops in from the top.
/// The icon sequence is shuffled each time the widget is created.
class _WeatherIconsAnimation extends StatefulWidget {
  const _WeatherIconsAnimation();

  @override
  State<_WeatherIconsAnimation> createState() => _WeatherIconsAnimationState();
}

class _WeatherIconsAnimationState extends State<_WeatherIconsAnimation> with SingleTickerProviderStateMixin {
  static const _cycleDuration = Duration(milliseconds: 1600);
  static const _overlapStart = 0.72;
  static const _dropEnd = 0.22;

  /// Icon size relative to the available inner space (~128px).
  static const _iconSize = 44.0;

  /// Vertical travel distance in logical pixels.
  static const _travelDistance = 56.0;

  late final AnimationController _controller;
  late final List<int> _shuffledIndices;
  var _sequencePosition = 0;

  int get _currentEntry => _shuffledIndices[_sequencePosition % _shuffledIndices.length];
  int get _nextEntry => _shuffledIndices[(_sequencePosition + 1) % _shuffledIndices.length];

  @override
  void initState() {
    super.initState();

    // Shuffle icon order so every loading session feels different.
    _shuffledIndices = List.generate(_weatherIconEntries.length, (i) => i)..shuffle();

    _controller = AnimationController(vsync: this, duration: _cycleDuration)
      ..addStatusListener(_onAnimationStatus)
      ..forward();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _sequencePosition++;
      });
      // Start after the drop phase — it was already shown in the overlap.
      _controller.forward(from: _dropEnd);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final t = _controller.value;

      return Stack(
        alignment: Alignment.center,
        children: [
          _BouncingWeatherIcon(progress: t, entryIndex: _currentEntry),
          if (t >= _overlapStart)
            _BouncingWeatherIcon(
              progress: (t - _overlapStart) / (1.0 - _overlapStart) * _dropEnd,
              entryIndex: _nextEntry,
            ),
        ],
      );
    },
  );
}

// ── Single bouncing icon widget ──

class _BouncingWeatherIcon extends StatelessWidget {
  const _BouncingWeatherIcon({
    required this.progress,
    required this.entryIndex,
  });

  /// Current animation progress (0.0 – 1.0).
  final double progress;

  /// Index into [_weatherIconEntries].
  final int entryIndex;

  static const _dropEnd = _WeatherIconsAnimationState._dropEnd;
  static const _bounceEnd = 0.62;
  static const _iconSize = _WeatherIconsAnimationState._iconSize;
  static const _travelDistance = _WeatherIconsAnimationState._travelDistance;

  @override
  Widget build(BuildContext context) {
    final t = progress;

    final double yOffset;
    final double opacity;
    final double scale;
    final double rotation;

    if (t < _dropEnd) {
      final dropT = Curves.easeOutBack.transform(t / _dropEnd);
      yOffset = -1.0 + dropT;
      opacity = Curves.easeOut.transform((t / (_dropEnd * 0.5)).clamp(0, 1));
      scale = 0.6 + dropT * 0.4;
      rotation = (1.0 - dropT) * 0.2;
    } else if (t < _bounceEnd) {
      final bounceT = (t - _dropEnd) / (_bounceEnd - _dropEnd);
      final dampedSin = sin(bounceT * pi * 3) * (1.0 - bounceT);
      yOffset = -dampedSin * 0.18;
      opacity = 1.0;
      scale = 1.0 + dampedSin.abs() * 0.08;
      rotation = dampedSin * 0.05;
    } else {
      final fallT = Curves.easeInCubic.transform((t - _bounceEnd) / (1.0 - _bounceEnd));
      yOffset = fallT * 1.3;
      opacity = (1.0 - Curves.easeIn.transform(fallT)).clamp(0, 1);
      scale = 1.0 - fallT * 0.3;
      rotation = -fallT * 0.35;
    }

    final entry = _weatherIconEntries[entryIndex];

    return Transform.translate(
      offset: Offset(0, yOffset * _travelDistance),
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: rotation,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              entry.icon,
              size: _iconSize,
              color: entry.color,
            ),
          ),
        ),
      ),
    );
  }
}
