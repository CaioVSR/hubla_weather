import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_elevation_tokens.dart';

/// Provides ergonomic access to [HublaElevationTokens] from [BuildContext].
///
/// Usage: `context.hublaElevation.level2`
extension HublaElevationExtension on BuildContext {
  HublaElevationTokens get hublaElevation => Theme.of(this).extension<HublaElevationTokens>()!;
}
