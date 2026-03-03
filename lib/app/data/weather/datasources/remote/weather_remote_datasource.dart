import 'package:hubla_weather/app/core/errors/app_error.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/core/http/hubla_http_client.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/requests/get_current_weather_request.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/requests/get_geocoding_request.dart';
import 'package:hubla_weather/app/domain/weather/entities/city.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';

/// Remote datasource that fetches weather data from the OpenWeatherMap API.
class WeatherRemoteDatasource {
  WeatherRemoteDatasource({required HublaHttpClient client}) : _client = client;

  final HublaHttpClient _client;

  /// Fetches current weather for the given [city].
  ///
  /// Parses the raw API response into a [CityWeather] entity.
  /// Returns an [Error] with the appropriate [AppError] on failure.
  Future<Result<AppError, CityWeather>> getCurrentWeather({required City city}) async {
    final responseResult = await _client.request(
      GetCurrentWeatherRequest(lat: city.latitude, lon: city.longitude),
    );

    return responseResult.when(
      Error.new,
      (response) {
        try {
          final data = response.data as Map<String, dynamic>;
          final cityWeather = _parseCityWeather(
            data,
            city.slug,
            isFromCache: response.isFromCache,
          );
          return Success(cityWeather);
        } catch (error, stackTrace) {
          return Error(SerializationError('Failed to parse weather data: $error', stackTrace: stackTrace));
        }
      },
    );
  }

  /// Parses the OpenWeatherMap current weather response into a [CityWeather].
  ///
  /// API response shape:
  /// ```json
  /// {
  ///   "main": { "temp": 25.0, "temp_min": 20.0, "temp_max": 30.0, "humidity": 65 },
  ///   "wind": { "speed": 3.5 },
  ///   "weather": [{ "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }],
  ///   "dt": 1740400000
  /// }
  /// ```
  CityWeather _parseCityWeather(
    Map<String, dynamic> data,
    String citySlug, {
    bool isFromCache = false,
  }) {
    final main = data['main'] as Map<String, dynamic>;
    final wind = data['wind'] as Map<String, dynamic>;
    final weatherList = data['weather'] as List<dynamic>;
    final weatherJson = weatherList.first as Map<String, dynamic>;
    final dt = data['dt'] as int;

    return CityWeather(
      citySlug: citySlug,
      temperature: (main['temp'] as num).toDouble(),
      temperatureMin: (main['temp_min'] as num).toDouble(),
      temperatureMax: (main['temp_max'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
      weather: WeatherInfo.fromJson(weatherJson),
      dateTime: DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true),
      isStale: isFromCache,
    );
  }

  /// Geocodes a city name to geographic coordinates using the
  /// OpenWeatherMap Geocoding API.
  ///
  /// Returns the latitude and longitude of the first matching result.
  /// Returns an [Error] if the API call fails or no results are found.
  Future<Result<AppError, ({double lat, double lon})>> geocodeCity({
    required String cityName,
  }) async {
    final responseResult = await _client.request(
      GetGeocodingRequest(cityName: cityName),
    );

    return responseResult.when(
      Error.new,
      (response) {
        try {
          final data = response.data as List<dynamic>;

          if (data.isEmpty) {
            return const Error(
              UnknownError(errorMessage: 'No geocoding results found'),
            );
          }

          final location = data.first as Map<String, dynamic>;
          final lat = (location['lat'] as num).toDouble();
          final lon = (location['lon'] as num).toDouble();

          return Success((lat: lat, lon: lon));
        } catch (error, stackTrace) {
          return Error(
            SerializationError(
              'Failed to parse geocoding data: $error',
              stackTrace: stackTrace,
            ),
          );
        }
      },
    );
  }
}
