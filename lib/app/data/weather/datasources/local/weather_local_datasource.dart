import 'package:hubla_weather/app/core/services/storage_service.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';

/// Local datasource for persisting and retrieving cached [CityWeather] data.
///
/// Uses [StorageService] (Hive) with per-city keys for granular cache
/// management. Key format: `weather_{citySlug}` (e.g. `weather_sao-paulo`).
class WeatherLocalDatasource {
  WeatherLocalDatasource({required StorageService storageService}) : _storageService = storageService;

  final StorageService _storageService;

  static const String _boxName = 'weather_cache';
  static const String _keyPrefix = 'weather_';

  /// Persists weather data for a single city.
  Future<void> saveCityWeather(CityWeather cityWeather) => _storageService.write(
    key: '$_keyPrefix${cityWeather.citySlug}',
    value: cityWeather.toJson(),
    boxName: _boxName,
  );

  /// Retrieves cached weather data for a city by its [citySlug].
  ///
  /// Returns `null` if no cached data exists for the given city.
  Future<CityWeather?> getCityWeather(String citySlug) async {
    final data = await _storageService.read<Map<dynamic, dynamic>>(
      '$_keyPrefix$citySlug',
      boxName: _boxName,
    );
    if (data == null) {
      return null;
    }

    final jsonMap = Map<String, dynamic>.from(data);
    return CityWeather.fromJson(jsonMap);
  }

  /// Retrieves all cached city weather data for the predefined cities.
  ///
  /// Returns only cities that have cached data. Cities with no cache
  /// are omitted from the result.
  Future<List<CityWeather>> getAllCachedCitiesWeather() async {
    final results = <CityWeather>[];
    for (final city in predefinedCities) {
      final cached = await getCityWeather(city.slug);
      if (cached != null) {
        results.add(cached);
      }
    }
    return results;
  }
}
