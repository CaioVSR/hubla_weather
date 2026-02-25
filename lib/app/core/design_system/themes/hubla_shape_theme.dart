import 'package:hubla_weather/app/core/design_system/tokens/hubla_shape_tokens.dart';

/// Concrete shape (corner radius) values for the Hubla Weather design system.
///
/// Follows M3's 10-step corner radius scale.
class HublaShapeTheme extends HublaShapeTokens {
  const HublaShapeTheme()
    : super(
        none: 0,
        extraSmall: 4,
        small: 8,
        medium: 12,
        large: 16,
        largeIncreased: 20,
        extraLarge: 28,
        extraLargeIncreased: 32,
        extraExtraLarge: 48,
        full: 999,
      );
}
