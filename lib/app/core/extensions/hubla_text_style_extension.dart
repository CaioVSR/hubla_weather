import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_typography_tokens.dart';

/// Provides ergonomic access to [HublaTypographyTokens] from [BuildContext].
///
/// Usage: `context.hublaTextStyles.bodyMedium`
extension HublaTextStyleExtension on BuildContext {
  HublaTypographyTokens get hublaTextStyles => Theme.of(this).extension<HublaTypographyTokens>()!;
}
