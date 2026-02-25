import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// Weather condition groups returned by the OpenWeatherMap API.
///
/// Maps to the `weather[0].main` field in API responses.
/// See: https://openweathermap.org/weather-conditions
enum WeatherCondition {
  @JsonValue('Clear')
  clear('Clear', 'CLEAR'),

  @JsonValue('Clouds')
  clouds('Clouds', 'CLOUDS'),

  @JsonValue('Rain')
  rain('Rain', 'RAIN'),

  @JsonValue('Drizzle')
  drizzle('Drizzle', 'DRIZZLE'),

  @JsonValue('Thunderstorm')
  thunderstorm('Thunderstorm', 'THUNDERSTORM'),

  @JsonValue('Snow')
  snow('Snow', 'SNOW'),

  @JsonValue('Mist')
  mist('Mist', 'MIST'),

  @JsonValue('Smoke')
  smoke('Smoke', 'SMOKE'),

  @JsonValue('Haze')
  haze('Haze', 'HAZE'),

  @JsonValue('Dust')
  dust('Dust', 'DUST'),

  @JsonValue('Fog')
  fog('Fog', 'FOG'),

  @JsonValue('Sand')
  sand('Sand', 'SAND'),

  @JsonValue('Ash')
  ash('Ash', 'ASH'),

  @JsonValue('Squall')
  squall('Squall', 'SQUALL'),

  @JsonValue('Tornado')
  tornado('Tornado', 'TORNADO'),

  @JsonValue('unknown')
  unknown('Unknown', 'UNKNOWN')
  ;

  const WeatherCondition(this.label, this.apiValue);

  /// Human-readable label for display.
  final String label;

  /// The raw API string value.
  final String apiValue;

  /// Material icon representing this weather condition.
  ///
  /// Used for offline-capable icon display on city weather cards.
  IconData get icon => switch (this) {
    WeatherCondition.clear => Icons.wb_sunny_rounded,
    WeatherCondition.clouds => Icons.cloud_rounded,
    WeatherCondition.rain => Icons.water_drop_rounded,
    WeatherCondition.drizzle => Icons.grain_rounded,
    WeatherCondition.thunderstorm => Icons.thunderstorm_rounded,
    WeatherCondition.snow => Icons.ac_unit_rounded,
    WeatherCondition.mist => Icons.blur_on_rounded,
    WeatherCondition.smoke => Icons.blur_circular_rounded,
    WeatherCondition.haze => Icons.blur_on_rounded,
    WeatherCondition.dust => Icons.blur_linear_rounded,
    WeatherCondition.fog => Icons.cloud_rounded,
    WeatherCondition.sand => Icons.blur_linear_rounded,
    WeatherCondition.ash => Icons.blur_circular_rounded,
    WeatherCondition.squall => Icons.air_rounded,
    WeatherCondition.tornado => Icons.tornado_rounded,
    WeatherCondition.unknown => Icons.help_outline_rounded,
  };
}
