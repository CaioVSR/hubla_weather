import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_shape_tokens.dart';

/// Provides ergonomic access to [HublaShapeTokens] from [BuildContext].
///
/// Usage: `context.hublaShape.medium`
extension HublaShapeExtension on BuildContext {
  HublaShapeTokens get hublaShape => Theme.of(this).extension<HublaShapeTokens>()!;
}
