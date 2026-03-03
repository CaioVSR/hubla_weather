import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/hubla_http_request.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/requests/get_current_weather_request.dart';

void main() {
  group('GetCurrentWeatherRequest', () {
    late GetCurrentWeatherRequest request;

    setUp(() {
      request = GetCurrentWeatherRequest(lat: -23.5505, lon: -46.6333);
    });

    test('should have correct path', () {
      expect(request.path, '/data/2.5/weather');
    });

    test('should use GET method', () {
      expect(request.method, HublaHttpMethod.get);
    });

    test('should include lat, lon, units, and lang in query params', () {
      expect(request.queryParameters, {
        'lat': -23.5505,
        'lon': -46.6333,
        'units': 'metric',
        'lang': 'en',
      });
    });

    test('should be cacheable', () {
      expect(request.isCacheable, isTrue);
    });

    test('should have empty body', () {
      expect(request.body, isEmpty);
    });
  });
}
