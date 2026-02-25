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
}
