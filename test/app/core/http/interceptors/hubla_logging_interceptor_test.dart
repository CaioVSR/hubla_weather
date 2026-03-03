import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/interceptors/hubla_logging_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/general_mocks.dart';
import '../../../../mocks/services_mocks.dart';

void main() {
  late HublaLoggingInterceptor interceptor;
  late MockLoggerService mockLoggerService;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockResponseInterceptorHandler mockResponseHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  setUp(() {
    mockLoggerService = MockLoggerService();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockResponseHandler = MockResponseInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();
    interceptor = HublaLoggingInterceptor(loggerService: mockLoggerService);
  });

  group('HublaLoggingInterceptor', () {
    group('onRequest', () {
      test('should log request details and call handler.next', () {
        final options = RequestOptions(
          path: '/data/2.5/weather',
          method: 'GET',
          queryParameters: {'lat': -23.5505},
        );

        interceptor.onRequest(options, mockRequestHandler);

        verify(() => mockLoggerService.info(any())).called(1);
        verify(() => mockRequestHandler.next(options)).called(1);
      });

      test('should log request body when present', () {
        final options = RequestOptions(
          path: '/test',
          method: 'POST',
          data: {'key': 'value'},
        );

        interceptor.onRequest(options, mockRequestHandler);

        verify(
          () => mockLoggerService.info(any(that: contains('Body:'))),
        ).called(1);
        verify(() => mockRequestHandler.next(options)).called(1);
      });
    });

    group('onResponse', () {
      test('should log response details and call handler.next', () {
        final options = RequestOptions(path: '/data/2.5/weather');
        final response = Response<dynamic>(
          requestOptions: options,
          data: {'temp': 25.0},
          statusCode: 200,
        );

        interceptor.onResponse(response, mockResponseHandler);

        verify(() => mockLoggerService.info(any())).called(1);
        verify(() => mockResponseHandler.next(response)).called(1);
      });
    });

    group('onError', () {
      test('should log error details and call handler.next', () {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        interceptor.onError(error, mockErrorHandler);

        verify(
          () => mockLoggerService.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
        verify(() => mockErrorHandler.next(error)).called(1);
      });

      test('should log response status when error has a response', () {
        final options = RequestOptions(path: '/test');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: options,
            statusCode: 500,
            data: 'Internal Server Error',
          ),
        );

        interceptor.onError(error, mockErrorHandler);

        verify(
          () => mockLoggerService.error(
            any(),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          ),
        ).called(1);
        verify(() => mockErrorHandler.next(error)).called(1);
      });
    });
  });
}
