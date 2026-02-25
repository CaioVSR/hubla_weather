import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/interceptors/cache_interceptor.dart';
import 'package:hubla_weather/app/core/http/interceptors/connectivity_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/general_mocks.dart';
import '../../../../mocks/services_mocks.dart';

void main() {
  late CacheInterceptor interceptor;
  late MockStorageService mockStorageService;
  late MockLoggerService mockLoggerService;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockResponseInterceptorHandler mockResponseHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  setUpAll(() {
    registerFallbackValue(Response<dynamic>(requestOptions: RequestOptions()));
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    mockStorageService = MockStorageService();
    mockLoggerService = MockLoggerService();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockResponseHandler = MockResponseInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();
    interceptor = CacheInterceptor(
      storageService: mockStorageService,
      loggerService: mockLoggerService,
    );
  });

  // ignore: no_leading_underscores_for_local_identifiers
  RequestOptions _createOptions({
    bool isCacheable = true,
    bool isOffline = false,
    String path = '/data/2.5/weather',
    Map<String, dynamic>? queryParameters,
  }) => RequestOptions(
    path: path,
    queryParameters: queryParameters ?? {'lat': -23.5505, 'lon': -46.6333, 'units': 'metric'},
    extra: {
      CacheInterceptor.isCacheableKey: isCacheable,
      ConnectivityInterceptor.isOfflineKey: isOffline,
    },
  );

  group('CacheInterceptor', () {
    group('onRequest', () {
      test('should call handler.next when request is not cacheable', () async {
        final options = _createOptions(isCacheable: false, isOffline: true);

        await interceptor.onRequest(options, mockRequestHandler);

        verify(() => mockRequestHandler.next(options)).called(1);
        verifyNever(() => mockStorageService.read<dynamic>(any()));
      });

      test('should call handler.next when device is online', () async {
        // ignore: avoid_redundant_argument_values
        final options = _createOptions(isOffline: false);

        await interceptor.onRequest(options, mockRequestHandler);

        verify(() => mockRequestHandler.next(options)).called(1);
        verifyNever(() => mockStorageService.read<dynamic>(any()));
      });

      test('should resolve with cached data when offline and cache hit', () async {
        final cachedData = {'temp': 25.0};
        final options = _createOptions(isOffline: true);

        when(() => mockStorageService.read<dynamic>(any())).thenAnswer((_) async => cachedData);

        await interceptor.onRequest(options, mockRequestHandler);

        final captured = verify(() => mockRequestHandler.resolve(captureAny())).captured;
        final response = captured.first as Response<dynamic>;

        expect(response.data, cachedData);
        expect(response.extra[CacheInterceptor.isFromCacheKey], isTrue);
        expect(response.statusCode, 200);
        verifyNever(() => mockRequestHandler.next(any()));
      });

      test('should call handler.next when offline and cache miss', () async {
        final options = _createOptions(isOffline: true);

        when(() => mockStorageService.read<dynamic>(any())).thenAnswer((_) async => null);

        await interceptor.onRequest(options, mockRequestHandler);

        verify(() => mockRequestHandler.next(options)).called(1);
        verifyNever(() => mockRequestHandler.resolve(any()));
      });
    });

    group('onResponse', () {
      test('should cache response data when request is cacheable', () async {
        final options = _createOptions();
        final responseData = {'temp': 25.0};
        final response = Response<dynamic>(requestOptions: options, data: responseData, statusCode: 200);

        when(
          () => mockStorageService.write<dynamic>(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        ).thenAnswer((_) async {});

        await interceptor.onResponse(response, mockResponseHandler);

        verify(
          () => mockStorageService.write<dynamic>(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        ).called(1);
        verify(() => mockResponseHandler.next(response)).called(1);
      });

      test('should not cache response when request is not cacheable', () async {
        final options = _createOptions(isCacheable: false);
        final response = Response<dynamic>(requestOptions: options, data: {'temp': 25.0}, statusCode: 200);

        await interceptor.onResponse(response, mockResponseHandler);

        verifyNever(
          () => mockStorageService.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        );
        verify(() => mockResponseHandler.next(response)).called(1);
      });

      test('should not cache response when data is null', () async {
        final options = _createOptions();
        final response = Response<dynamic>(requestOptions: options, statusCode: 200);

        await interceptor.onResponse(response, mockResponseHandler);

        verifyNever(
          () => mockStorageService.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        );
        verify(() => mockResponseHandler.next(response)).called(1);
      });
    });

    group('onError', () {
      test('should resolve with cached data on error when cache hit', () async {
        final options = _createOptions();
        final cachedData = {'temp': 25.0};
        final error = DioException(requestOptions: options, type: DioExceptionType.connectionError);

        when(() => mockStorageService.read<dynamic>(any())).thenAnswer((_) async => cachedData);

        await interceptor.onError(error, mockErrorHandler);

        final captured = verify(() => mockErrorHandler.resolve(captureAny())).captured;
        final response = captured.first as Response<dynamic>;

        expect(response.data, cachedData);
        expect(response.extra[CacheInterceptor.isFromCacheKey], isTrue);
        verifyNever(() => mockErrorHandler.next(any()));
      });

      test('should call handler.next when cache miss on error', () async {
        final options = _createOptions();
        final error = DioException(requestOptions: options, type: DioExceptionType.connectionError);

        when(() => mockStorageService.read<dynamic>(any())).thenAnswer((_) async => null);

        await interceptor.onError(error, mockErrorHandler);

        verify(() => mockErrorHandler.next(error)).called(1);
        verifyNever(() => mockErrorHandler.resolve(any()));
      });

      test('should call handler.next when request is not cacheable', () async {
        final options = _createOptions(isCacheable: false);
        final error = DioException(requestOptions: options, type: DioExceptionType.connectionError);

        await interceptor.onError(error, mockErrorHandler);

        verify(() => mockErrorHandler.next(error)).called(1);
        verifyNever(() => mockStorageService.read<dynamic>(any()));
      });
    });
  });
}
