import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';

import 'weather_info_factory.dart';

abstract class CityWeatherFactory {
  static CityWeather create({
    String? citySlug,
    double? temperature,
    double? temperatureMin,
    double? temperatureMax,
    int? humidity,
    double? windSpeed,
    WeatherInfo? weather,
    DateTime? dateTime,
  }) => CityWeather(
    citySlug: citySlug ?? 'sao-paulo',
    temperature: temperature ?? 25.0,
    temperatureMin: temperatureMin ?? 20.0,
    temperatureMax: temperatureMax ?? 30.0,
    humidity: humidity ?? 65,
    windSpeed: windSpeed ?? 3.5,
    weather: weather ?? WeatherInfoFactory.create(),
    dateTime: dateTime ?? DateTime.utc(2026, 2, 25, 12),
  );
}
