import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/hubla_http_request.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/requests/get_geocoding_request.dart';

void main() {
  group('GetGeocodingRequest', () {
    late GetGeocodingRequest request;

    setUp(() {
      request = GetGeocodingRequest(cityName: 'São Paulo');
    });

    test('should have correct path', () {
      expect(request.path, '/geo/1.0/direct');
    });

    test('should use GET method', () {
      expect(request.method, HublaHttpMethod.get);
    });

    test('should include city name with default country code BR and limit 1', () {
      expect(request.queryParameters, {
        'q': 'São Paulo,BR',
        'limit': 1,
      });
    });

    test('should support custom country code', () {
      final customRequest = GetGeocodingRequest(
        cityName: 'London',
        countryCode: 'GB',
      );

      expect(customRequest.queryParameters, {
        'q': 'London,GB',
        'limit': 1,
      });
    });

    test('should not be cacheable', () {
      expect(request.isCacheable, isFalse);
    });

    test('should have empty body', () {
      expect(request.body, isEmpty);
    });
  });
}
