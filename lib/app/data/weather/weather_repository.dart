import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';
import 'package:hubla_weather/app/domain/weather/entities/city.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';

/// Repository that orchestrates weather data fetching and caching.
///
/// Implements an offline-first strategy:
/// - Fetches from the remote API in parallel for all cities
/// - Saves successful responses to local cache
/// - Falls back to cached data (marked as stale) on per-city errors
/// - Only returns [NoCachedDataError] when ALL cities fail AND no cache exists
class WeatherRepository {
  WeatherRepository({
    required WeatherRemoteDatasource weatherRemoteDatasource,
    required WeatherLocalDatasource weatherLocalDatasource,
  }) : _remoteDatasource = weatherRemoteDatasource,
       _localDatasource = weatherLocalDatasource;

  final WeatherRemoteDatasource _remoteDatasource;
  final WeatherLocalDatasource _localDatasource;

  /// Fetches current weather for all predefined cities.
  ///
  /// Requests are made in parallel. For each city:
  /// - On success: saves to cache and includes in results
  /// - On failure: falls back to cached data with [CityWeather.isStale] = true
  /// - If no cache: the city is omitted from results
  ///
  /// Returns [NoCachedDataError] only when the result list is completely empty.
  Future<Result<WeatherError, List<CityWeather>>> getAllCitiesWeather() async {
    final futures = predefinedCities.map(_fetchOrFallback);
    final results = await Future.wait(futures);

    final citiesWeather = results.whereType<CityWeather>().toList();

    if (citiesWeather.isEmpty) {
      return const Error(NoCachedDataError());
    }

    return Success(citiesWeather);
  }

  /// Fetches current weather for a single [city].
  ///
  /// On success: saves to cache and returns fresh data.
  /// On failure: returns cached data with [CityWeather.isStale] = true,
  /// or a [FetchWeatherError] if no cache exists.
  Future<Result<WeatherError, CityWeather>> getCityWeather({required City city}) async {
    final result = await _remoteDatasource.getCurrentWeather(city: city);

    return result.when(
      (error) async {
        final cached = await _localDatasource.getCityWeather(city.slug);
        if (cached != null) {
          return Success(cached.copyWith(isStale: true));
        }
        return Error(FetchWeatherError(errorMessage: error.errorMessage, stackTrace: error.stackTrace));
      },
      (cityWeather) async {
        await _localDatasource.saveCityWeather(cityWeather);
        return Success(cityWeather);
      },
    );
  }

  /// Attempts to fetch weather for a single city, falling back to cache.
  ///
  /// Returns `null` if both the remote fetch and cache lookup fail.
  Future<CityWeather?> _fetchOrFallback(City city) async {
    final result = await _remoteDatasource.getCurrentWeather(city: city);

    return result.when(
      (error) async {
        final cached = await _localDatasource.getCityWeather(city.slug);
        return cached?.copyWith(isStale: true);
      },
      (cityWeather) async {
        await _localDatasource.saveCityWeather(cityWeather);
        return cityWeather;
      },
    );
  }
}
