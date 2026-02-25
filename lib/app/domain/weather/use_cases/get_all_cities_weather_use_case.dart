import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/data/weather/weather_repository.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';

class GetAllCitiesWeatherUseCase {
  GetAllCitiesWeatherUseCase({required WeatherRepository weatherRepository}) : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  Future<Result<WeatherError, List<CityWeather>>> call() => _weatherRepository.getAllCitiesWeather();
}
