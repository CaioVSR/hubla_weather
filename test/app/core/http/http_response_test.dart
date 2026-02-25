import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/http_response.dart';

void main() {
  group('HttpResponse', () {
    group('equality', () {
      test('should be equal when all fields match', () {
        const a = HttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HttpResponse(data: {'temp': 25.0}, isFromCache: false);

        expect(a, equals(b));
      });

      test('should not be equal when data differs', () {
        const a = HttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HttpResponse(data: {'temp': 30.0}, isFromCache: false);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when isFromCache differs', () {
        const a = HttpResponse(data: {'temp': 25.0}, isFromCache: false);
        const b = HttpResponse(data: {'temp': 25.0}, isFromCache: true);

        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('should include isFromCache and data', () {
        const response = HttpResponse(data: {'temp': 25.0}, isFromCache: true);

        final result = response.toString();

        expect(result, contains('isFromCache: true'));
        expect(result, contains('temp'));
      });
    });

    test('should store data as dynamic', () {
      const response = HttpResponse(data: 'plain string', isFromCache: false);

      expect(response.data, 'plain string');
    });

    test('should store null data', () {
      const response = HttpResponse(data: null, isFromCache: false);

      expect(response.data, isNull);
    });
  });
}
