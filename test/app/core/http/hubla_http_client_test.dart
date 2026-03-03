import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';
import 'package:hubla_weather/app/core/http/hubla_http_client.dart';
import 'package:hubla_weather/app/core/http/hubla_http_request.dart';
import 'package:hubla_weather/app/core/http/hubla_http_response.dart';
import 'package:hubla_weather/app/core/http/interceptors/hubla_cache_interceptor.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/general_mocks.dart';

void main() {
  late MockDio mockDio;
  late HublaHttpClient client;

  setUp(() {
    mockDio = MockDio();
    client = HublaHttpClient.withDio(mockDio);
  });

  setUpAll(() {
    registerFallbackValue(RequestOptions());
    registerFallbackValue(Options());
  });

  group('HublaHttpClient.request', () {
    group('successful responses', () {
      test('should return Success with HublaHttpResponse on successful request', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(
            requestOptions: RequestOptions(),
            data: {'temp': 25.0},
            statusCode: 200,
          ),
        );

        final result = await client.request(request);

        expect(result.isSuccess, isTrue);
        final response = result.getSuccess()!;
        expect(response, isA<HublaHttpResponse>());
        expect(response.data, {'temp': 25.0});
        expect(response.isFromCache, isFalse);
      });

      test('should set isFromCache to true when response extra contains cache flag', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(
            requestOptions: RequestOptions(),
            data: {'temp': 25.0},
            statusCode: 200,
            extra: {HublaCacheInterceptor.isFromCacheKey: true},
          ),
        );

        final result = await client.request(request);

        expect(result.isSuccess, isTrue);
        expect(result.getSuccess()!.isFromCache, isTrue);
      });

      test('should pass request path to Dio', () async {
        final request = _TestGetRequest(testPath: '/data/2.5/weather');
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(requestOptions: RequestOptions(), data: {}),
        );

        await client.request(request);

        verify(
          () => mockDio.request<dynamic>(
            '/data/2.5/weather',
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should pass body as data when body is not empty', () async {
        final request = _TestPostRequest(testBody: {'name': 'test'});
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(requestOptions: RequestOptions(), data: {}),
        );

        await client.request(request);

        verify(
          () => mockDio.request<dynamic>(
            any(),
            data: {'name': 'test'},
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should pass null data when body is empty', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(requestOptions: RequestOptions(), data: {}),
        );

        await client.request(request);

        verify(
          () => mockDio.request<dynamic>(
            any(),
            // ignore: avoid_redundant_argument_values
            data: null,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should pass query parameters when not empty', () async {
        final request = _TestGetRequest(testQueryParams: {'lat': -23.5, 'lon': -46.6});
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(requestOptions: RequestOptions(), data: {}),
        );

        await client.request(request);

        verify(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: {'lat': -23.5, 'lon': -46.6},
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should pass null queryParameters when empty', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<dynamic>(requestOptions: RequestOptions(), data: {}),
        );

        await client.request(request);

        verify(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            // ignore: avoid_redundant_argument_values
            queryParameters: null,
            options: any(named: 'options'),
          ),
        ).called(1);
      });
    });

    group('error mapping (_mapDioException)', () {
      test('should map connectionTimeout to TimeoutError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionTimeout));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<TimeoutError>());
      });

      test('should map sendTimeout to TimeoutError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.sendTimeout));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<TimeoutError>());
      });

      test('should map receiveTimeout to TimeoutError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.receiveTimeout));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<TimeoutError>());
      });

      test('should map connectionError to NoConnectionError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<NoConnectionError>());
      });

      test('should map badResponse to HttpError with status code and message', () async {
        final request = _TestGetRequest();
        final requestOptions = RequestOptions();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(requestOptions: requestOptions, statusCode: 404, statusMessage: 'Not Found'),
          ),
        );

        final result = await client.request(request);

        expect(result.isError, isTrue);
        final error = result.getError()!;
        expect(error, isA<HttpError>());
        expect(error.statusCode, 404);
        expect(error.errorMessage, 'Not Found');
      });

      test('should use "Server error" as fallback message when statusMessage is null', () async {
        final request = _TestGetRequest();
        final requestOptions = RequestOptions();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: requestOptions,
            type: DioExceptionType.badResponse,
            response: Response<dynamic>(requestOptions: requestOptions, statusCode: 500),
          ),
        );

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError()!.errorMessage, 'Server error');
      });

      test('should map cancel to UnknownError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.cancel));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        final error = result.getError()!;
        expect(error, isA<UnknownError>());
        expect(error.errorMessage, 'Request was cancelled');
      });

      test('should map badCertificate to UnknownError', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(), type: DioExceptionType.badCertificate));

        final result = await client.request(request);

        expect(result.isError, isTrue);
        final error = result.getError()!;
        expect(error, isA<UnknownError>());
        expect(error.errorMessage, 'Certificate verification failed');
      });

      test('should map unknown DioException to UnknownError with message', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          // ignore: avoid_redundant_argument_values
          DioException(requestOptions: RequestOptions(), type: DioExceptionType.unknown, message: 'Something broke'),
        );

        final result = await client.request(request);

        expect(result.isError, isTrue);
        final error = result.getError()!;
        expect(error, isA<UnknownError>());
        expect(error.errorMessage, 'Something broke');
      });

      test('should use default message for unknown DioException without message', () async {
        final request = _TestGetRequest();
        when(
          () => mockDio.request<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          // ignore: avoid_redundant_argument_values
          DioException(requestOptions: RequestOptions(), type: DioExceptionType.unknown),
        );

        final result = await client.request(request);

        expect(result.isError, isTrue);
        expect(result.getError()!.errorMessage, 'An unexpected error occurred');
      });
    });
  });
}

/// GET request for testing.
class _TestGetRequest extends HublaHttpRequest {
  _TestGetRequest({
    this.testPath = '/test',
    this.testQueryParams = const {},
  });

  final String testPath;
  final Map<String, dynamic> testQueryParams;

  @override
  String get path => testPath;

  @override
  HublaHttpMethod get method => HublaHttpMethod.get;

  @override
  Map<String, dynamic> get queryParameters => testQueryParams;
}

/// POST request with body for testing.
class _TestPostRequest extends HublaHttpRequest {
  _TestPostRequest({required this.testBody});

  final Map<String, dynamic> testBody;

  @override
  String get path => '/test';

  @override
  HublaHttpMethod get method => HublaHttpMethod.post;

  @override
  Map<String, dynamic> get body => testBody;
}
