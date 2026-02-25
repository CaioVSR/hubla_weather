import 'package:equatable/equatable.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forecast_entry.g.dart';

/// A single 3-hour forecast slot from the OpenWeatherMap 5-day forecast.
///
/// The City Forecast screen displays the next 12 entries (36 hours).
@JsonSerializable()
class ForecastEntry extends Equatable {
  const ForecastEntry({
    required this.dateTime,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weather,
  });

  factory ForecastEntry.fromJson(Map<String, dynamic> json) => _$ForecastEntryFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastEntryToJson(this);

  /// Forecast date and time (UTC).
  final DateTime dateTime;

  /// Forecasted temperature in Celsius.
  final double temperature;

  /// Forecasted humidity percentage (0–100).
  final int humidity;

  /// Forecasted wind speed in m/s.
  final double windSpeed;

  /// Weather condition details (condition group, description, icon).
  final WeatherInfo weather;

  @override
  List<Object?> get props => [dateTime, temperature, humidity, windSpeed, weather];
}
