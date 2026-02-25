import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';

/// Provides ergonomic access to [HublaColorTokens] from [BuildContext].
///
/// Usage: `context.hublaColors.sky`
extension HublaColorExtension on BuildContext {
  HublaColorTokens get hublaColors => Theme.of(this).extension<HublaColorTokens>()!;
}
