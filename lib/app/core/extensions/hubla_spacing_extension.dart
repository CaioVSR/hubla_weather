import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_spacing_tokens.dart';

/// Provides ergonomic access to [HublaSpacingTokens] from [BuildContext].
///
/// Usage: `context.hublaSpacing.md`
extension HublaSpacingExtension on BuildContext {
  HublaSpacingTokens get hublaSpacing => Theme.of(this).extension<HublaSpacingTokens>()!;
}
