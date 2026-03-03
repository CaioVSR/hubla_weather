import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/hubla_http_response.dart';

void main() {
  group('HublaHttpResponse', () {
    group('equality', () {
      test('should be equal when all fields match', () {
        const a = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: false);

        expect(a, equals(b));
      });

      test('should not be equal when data differs', () {
        const a = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HublaHttpResponse(data: {'temp': 30.0}, isFromCache: false);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when isFromCache differs', () {
        const a = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: true);

        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('should include isFromCache and data', () {
        const response = HublaHttpResponse(data: {'temp': 25.0}, isFromCache: true);

        final result = response.toString();

        expect(result, contains('isFromCache: true'));
        expect(result, contains('temp'));
      });
    });

    test('should store data as dynamic', () {
      const response = HublaHttpResponse(data: 'plain string', isFromCache: false);

      expect(response.data, 'plain string');
    });

    test('should store null data', () {
      const response = HublaHttpResponse(data: null, isFromCache: false);

      expect(response.data, isNull);
    });
  });
}
