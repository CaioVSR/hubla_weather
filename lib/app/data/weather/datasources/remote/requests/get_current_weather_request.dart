import 'package:hubla_weather/app/core/http/http_request.dart';

/// GET request for current weather data from the OpenWeatherMap API.
///
/// Fetches weather for a single city by geographic coordinates.
/// Response is cacheable for offline-first support.
///
/// See: https://openweathermap.org/current
class GetCurrentWeatherRequest extends HttpRequest {
  GetCurrentWeatherRequest({
    required this.lat,
    required this.lon,
  });

  final double lat;
  final double lon;

  @override
  String get path => '/data/2.5/weather';

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'lat': lat,
    'lon': lon,
    'units': 'metric',
    'lang': 'en',
  };

  @override
  bool get isCacheable => true;
}
