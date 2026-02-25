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
  static const String _geocodingBoxName = 'geocoding_cache';
  static const String _geocodingKeyPrefix = 'geocoding_';

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

  /// Persists geocoded coordinates for a city.
  ///
  /// Coordinates are stored permanently since geographic locations
  /// do not change. Key format: `geocoding_{citySlug}`.
  Future<void> saveGeocodingResult({
    required String citySlug,
    required double lat,
    required double lon,
  }) => _storageService.write(
    key: '$_geocodingKeyPrefix$citySlug',
    value: {'lat': lat, 'lon': lon},
    boxName: _geocodingBoxName,
  );

  /// Retrieves cached geocoding coordinates for a city.
  ///
  /// Returns `null` if no cached geocoding data exists.
  Future<({double lat, double lon})?> getGeocodingResult(String citySlug) async {
    final data = await _storageService.read<Map<dynamic, dynamic>>(
      '$_geocodingKeyPrefix$citySlug',
      boxName: _geocodingBoxName,
    );
    if (data == null) {
      return null;
    }

    return (
      lat: (data['lat'] as num).toDouble(),
      lon: (data['lon'] as num).toDouble(),
    );
  }
}
