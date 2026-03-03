import 'package:hubla_weather/app/core/http/hubla_http_request.dart';

/// GET request for geocoding a city name via the OpenWeatherMap Geocoding API.
///
/// Converts a city name into geographic coordinates (lat/lon).
/// Response is **not** cacheable by the HTTP layer — caching is handled
/// by the local datasource for permanent coordinate storage.
///
/// See: https://openweathermap.org/api/geocoding-api
class GetGeocodingRequest extends HublaHttpRequest {
  GetGeocodingRequest({
    required this.cityName,
    this.countryCode = 'BR',
  });

  final String cityName;
  final String countryCode;

  @override
  String get path => '/geo/1.0/direct';

  @override
  HublaHttpMethod get method => HublaHttpMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'q': '$cityName,$countryCode',
    'limit': 1,
  };
}
