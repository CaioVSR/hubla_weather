import 'package:equatable/equatable.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_weather.g.dart';

/// Current weather data for a specific city.
///
/// Aggregates data from the OpenWeatherMap `/data/2.5/weather` endpoint.
/// Used to populate city weather cards on the City List screen.
@JsonSerializable()
class CityWeather extends Equatable {
  const CityWeather({
    required this.citySlug,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.humidity,
    required this.windSpeed,
    required this.weather,
    required this.dateTime,
    this.isStale = false,
  });

  factory CityWeather.fromJson(Map<String, dynamic> json) => _$CityWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$CityWeatherToJson(this);

  /// Slug of the city this weather data belongs to.
  /// Links to `City.slug`.
  final String citySlug;

  /// Current temperature in Celsius.
  final double temperature;

  /// Minimum temperature in Celsius.
  final double temperatureMin;

  /// Maximum temperature in Celsius.
  final double temperatureMax;

  /// Humidity percentage (0–100).
  final int humidity;

  /// Wind speed in m/s.
  final double windSpeed;

  /// Weather condition details (condition group, description, icon).
  final WeatherInfo weather;

  /// Timestamp of the weather observation.
  final DateTime dateTime;

  /// Whether this data is stale (served from cache after a failed refresh).
  ///
  /// Runtime-only flag — not persisted to JSON. Set by the repository when
  /// a remote fetch fails and cached data is returned instead.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isStale;

  /// Returns a copy with [isStale] set to the given value.
  CityWeather copyWith({bool? isStale}) => CityWeather(
    citySlug: citySlug,
    temperature: temperature,
    temperatureMin: temperatureMin,
    temperatureMax: temperatureMax,
    humidity: humidity,
    windSpeed: windSpeed,
    weather: weather,
    dateTime: dateTime,
    isStale: isStale ?? this.isStale,
  );

  @override
  List<Object?> get props => [
    citySlug,
    temperature,
    temperatureMin,
    temperatureMax,
    humidity,
    windSpeed,
    weather,
    dateTime,
    isStale,
  ];
}
