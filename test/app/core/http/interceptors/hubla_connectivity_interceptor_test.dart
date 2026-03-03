import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/interceptors/hubla_connectivity_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/general_mocks.dart';
import '../../../../mocks/services_mocks.dart';

void main() {
  late HublaConnectivityInterceptor interceptor;
  late MockConnectivityService mockConnectivityService;
  late MockRequestInterceptorHandler mockHandler;

  setUp(() {
    mockConnectivityService = MockConnectivityService();
    mockHandler = MockRequestInterceptorHandler();
    interceptor = HublaConnectivityInterceptor(connectivityService: mockConnectivityService);
  });

  group('HublaConnectivityInterceptor', () {
    test('should set isOffline to false when device has internet', () async {
      when(() => mockConnectivityService.hasInternetConnection()).thenAnswer((_) async => true);
      final options = RequestOptions(path: '/data/2.5/weather');

      await interceptor.onRequest(options, mockHandler);

      expect(options.extra[HublaConnectivityInterceptor.isOfflineKey], isFalse);
      verify(() => mockHandler.next(options)).called(1);
    });

    test('should set isOffline to true when device has no internet', () async {
      when(() => mockConnectivityService.hasInternetConnection()).thenAnswer((_) async => false);
      final options = RequestOptions(path: '/data/2.5/weather');

      await interceptor.onRequest(options, mockHandler);

      expect(options.extra[HublaConnectivityInterceptor.isOfflineKey], isTrue);
      verify(() => mockHandler.next(options)).called(1);
    });

    test('should always call handler.next to continue the chain', () async {
      when(() => mockConnectivityService.hasInternetConnection()).thenAnswer((_) async => true);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, mockHandler);

      verify(() => mockHandler.next(options)).called(1);
      verifyNoMoreInteractions(mockHandler);
    });
  });
}
