import 'package:hubla_weather/app/domain/weather/entities/forecast_entry.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';

import 'weather_info_factory.dart';

abstract class ForecastEntryFactory {
  static ForecastEntry create({
    DateTime? dateTime,
    double? temperature,
    int? humidity,
    double? windSpeed,
    WeatherInfo? weather,
  }) => ForecastEntry(
    dateTime: dateTime ?? DateTime.utc(2026, 2, 25, 15),
    temperature: temperature ?? 26.0,
    humidity: humidity ?? 70,
    windSpeed: windSpeed ?? 4.0,
    weather: weather ?? WeatherInfoFactory.create(),
  );
}
