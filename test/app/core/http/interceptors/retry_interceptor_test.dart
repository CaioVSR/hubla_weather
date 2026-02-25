import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/interceptors/retry_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/general_mocks.dart';
import '../../../../mocks/services_mocks.dart';

void main() {
  late RetryInterceptor interceptor;
  late MockDio mockDio;
  late MockLoggerService mockLoggerService;
  late MockErrorInterceptorHandler mockHandler;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
    registerFallbackValue(Response<dynamic>(requestOptions: RequestOptions()));
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
  });

  setUp(() {
    mockDio = MockDio();
    mockLoggerService = MockLoggerService();
    mockHandler = MockErrorInterceptorHandler();
    interceptor = RetryInterceptor(
      dio: mockDio,
      loggerService: mockLoggerService,
      // ignore: avoid_redundant_argument_values
      maxRetries: 3,
    );
  });

  group('RetryInterceptor', () {
    group('should retry on retryable errors', () {
      test('should retry on 500 server error and resolve on success', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 500),
        );
        final successResponse = Response<dynamic>(
          requestOptions: options,
          data: {'temp': 25.0},
          statusCode: 200,
        );

        when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async => successResponse);

        await interceptor.onError(error, mockHandler);

        verify(() => mockDio.fetch<dynamic>(any())).called(1);
        verify(() => mockHandler.resolve(successResponse)).called(1);
        verifyNever(() => mockHandler.next(any()));
      });

      test('should retry on connection timeout', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        );
        final successResponse = Response<dynamic>(
          requestOptions: options,
          data: {'temp': 25.0},
          statusCode: 200,
        );

        when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async => successResponse);

        await interceptor.onError(error, mockHandler);

        verify(() => mockDio.fetch<dynamic>(any())).called(1);
        verify(() => mockHandler.resolve(successResponse)).called(1);
      });

      test('should retry on receive timeout', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        );
        final successResponse = Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
        );

        when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async => successResponse);

        await interceptor.onError(error, mockHandler);

        verify(() => mockDio.fetch<dynamic>(any())).called(1);
        verify(() => mockHandler.resolve(successResponse)).called(1);
      });

      test('should retry on send timeout', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.sendTimeout,
        );
        final successResponse = Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
        );

        when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async => successResponse);

        await interceptor.onError(error, mockHandler);

        verify(() => mockDio.fetch<dynamic>(any())).called(1);
        verify(() => mockHandler.resolve(successResponse)).called(1);
      });
    });

    group('should not retry on non-retryable errors', () {
      test('should not retry on 400 client error', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 400),
        );

        await interceptor.onError(error, mockHandler);

        verifyNever(() => mockDio.fetch<dynamic>(any()));
        verify(() => mockHandler.next(error)).called(1);
      });

      test('should not retry on connection error', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );

        await interceptor.onError(error, mockHandler);

        verifyNever(() => mockDio.fetch<dynamic>(any()));
        verify(() => mockHandler.next(error)).called(1);
      });

      test('should not retry on cancel', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
        );

        await interceptor.onError(error, mockHandler);

        verifyNever(() => mockDio.fetch<dynamic>(any()));
        verify(() => mockHandler.next(error)).called(1);
      });
    });

    group('max retries', () {
      test('should not retry when max retries exceeded', () async {
        final options = RequestOptions(
          path: '/data/2.5/weather',
          extra: {'retryCount': 3},
        );
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 500),
        );

        await interceptor.onError(error, mockHandler);

        verifyNever(() => mockDio.fetch<dynamic>(any()));
        verify(() => mockHandler.next(error)).called(1);
      });
    });

    group('retry failure', () {
      test('should call handler.next when retry also fails', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 500),
        );
        final retryError = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: options, statusCode: 502),
        );

        when(() => mockDio.fetch<dynamic>(any())).thenThrow(retryError);

        await interceptor.onError(error, mockHandler);

        verify(() => mockDio.fetch<dynamic>(any())).called(1);
        verify(() => mockHandler.next(retryError)).called(1);
        verifyNever(() => mockHandler.resolve(any()));
      });
    });

    group('retry count tracking', () {
      test('should increment retry count in request extras', () async {
        final options = RequestOptions(path: '/data/2.5/weather');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        );
        final successResponse = Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
        );

        when(() => mockDio.fetch<dynamic>(any())).thenAnswer((_) async => successResponse);

        await interceptor.onError(error, mockHandler);

        expect(options.extra['retryCount'], 1);
      });
    });
  });
}
