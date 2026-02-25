import 'package:hubla_weather/app/core/design_system/tokens/hubla_elevation_tokens.dart';

/// Concrete elevation values for the Hubla Weather design system.
///
/// Follows M3's 6-level elevation system.
class HublaElevationTheme extends HublaElevationTokens {
  const HublaElevationTheme()
    : super(
        level0: 0,
        level1: 1,
        level2: 3,
        level3: 6,
        level4: 8,
        level5: 12,
      );
}
