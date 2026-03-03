import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/interceptors/hubla_auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/general_mocks.dart';

void main() {
  late HublaAuthInterceptor interceptor;
  late MockRequestInterceptorHandler mockHandler;

  setUp(() {
    interceptor = HublaAuthInterceptor();
    mockHandler = MockRequestInterceptorHandler();
  });

  group('HublaAuthInterceptor', () {
    test('should append appid query parameter to request', () {
      final options = RequestOptions(path: '/data/2.5/weather');

      interceptor.onRequest(options, mockHandler);

      expect(options.queryParameters['appid'], isNotNull);
      verify(() => mockHandler.next(options)).called(1);
    });

    test('should preserve existing query parameters', () {
      final options = RequestOptions(
        path: '/data/2.5/weather',
        queryParameters: {'lat': -23.5505, 'lon': -46.6333},
      );

      interceptor.onRequest(options, mockHandler);

      expect(options.queryParameters['lat'], -23.5505);
      expect(options.queryParameters['lon'], -46.6333);
      expect(options.queryParameters['appid'], isNotNull);
      verify(() => mockHandler.next(options)).called(1);
    });

    test('should call handler.next to continue the interceptor chain', () {
      final options = RequestOptions(path: '/data/2.5/weather');

      interceptor.onRequest(options, mockHandler);

      verify(() => mockHandler.next(options)).called(1);
      verifyNoMoreInteractions(mockHandler);
    });
  });
}
