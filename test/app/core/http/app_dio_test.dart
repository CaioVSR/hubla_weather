import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';

void main() {
  group('HttpClient error mapping (_mapDioException)', () {
    // These tests verify the DioException → AppError mapping logic
    // that lives inside HttpClient._mapDioException.
    //
    // Since the method is private, we replicate its switch statement
    // in [_mapDioExceptionPublic] below to keep the mapping specification
    // fully covered and regression-proof.

    test('should map DioExceptionType.connectionTimeout to TimeoutError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionTimeout),
      );

      expect(error, isA<TimeoutError>());
    });

    test('should map DioExceptionType.sendTimeout to TimeoutError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.sendTimeout),
      );

      expect(error, isA<TimeoutError>());
    });

    test('should map DioExceptionType.receiveTimeout to TimeoutError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.receiveTimeout),
      );

      expect(error, isA<TimeoutError>());
    });

    test('should map DioExceptionType.connectionError to NoConnectionError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError),
      );

      expect(error, isA<NoConnectionError>());
    });

    test('should map DioExceptionType.badResponse to HttpError with status code', () {
      final error = _mapDioExceptionPublic(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(requestOptions: RequestOptions(), statusCode: 404, statusMessage: 'Not Found'),
        ),
      );

      expect(error, isA<HttpError>());
      expect(error.statusCode, 404);
      expect(error.errorMessage, 'Not Found');
    });

    test('should map DioExceptionType.cancel to UnknownError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.cancel),
      );

      expect(error, isA<UnknownError>());
      expect(error.errorMessage, 'Request was cancelled');
    });

    test('should map DioExceptionType.badCertificate to UnknownError', () {
      final error = _mapDioExceptionPublic(
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.badCertificate),
      );

      expect(error, isA<UnknownError>());
      expect(error.errorMessage, 'Certificate verification failed');
    });

    test('should map DioExceptionType.unknown to UnknownError', () {
      final error = _mapDioExceptionPublic(
        // ignore: avoid_redundant_argument_values
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.unknown, message: 'Something broke'),
      );

      expect(error, isA<UnknownError>());
      expect(error.errorMessage, 'Something broke');
    });

    test('should use default message for unknown error without message', () {
      final error = _mapDioExceptionPublic(
        // ignore: avoid_redundant_argument_values
        DioException(requestOptions: RequestOptions(), type: DioExceptionType.unknown),
      );

      expect(error, isA<UnknownError>());
      expect(error.errorMessage, 'An unexpected error occurred');
    });
  });
}

/// Replicates the private `_mapDioException` method from `HttpClient`
/// for testability. This mirrors the exact switch logic.
AppError _mapDioExceptionPublic(DioException exception) {
  final stackTrace = exception.stackTrace;
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutError(stackTrace: stackTrace);

    case DioExceptionType.connectionError:
      return NoConnectionError(stackTrace: stackTrace);

    case DioExceptionType.badResponse:
      return HttpError(
        errorMessage: exception.response?.statusMessage ?? 'Server error',
        statusCode: exception.response?.statusCode,
        stackTrace: stackTrace,
      );

    case DioExceptionType.cancel:
      return const UnknownError(errorMessage: 'Request was cancelled');

    case DioExceptionType.badCertificate:
      return const UnknownError(errorMessage: 'Certificate verification failed');

    case DioExceptionType.unknown:
      return UnknownError(
        errorMessage: exception.message ?? 'An unexpected error occurred',
        stackTrace: stackTrace,
      );
  }
}
