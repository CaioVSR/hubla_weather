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
  ];
}
