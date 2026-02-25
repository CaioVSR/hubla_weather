import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';

abstract class WeatherInfoFactory {
  static WeatherInfo create({
    int? id,
    WeatherCondition? condition,
    String? description,
    String? icon,
  }) => WeatherInfo(
    id: id ?? 800,
    condition: condition ?? WeatherCondition.clear,
    description: description ?? 'clear sky',
    icon: icon ?? '01d',
  );
}
