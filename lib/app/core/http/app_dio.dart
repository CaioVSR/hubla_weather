import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/env/env.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/core/http/http_request.dart';
import 'package:hubla_weather/app/core/http/interceptors/auth_interceptor.dart';
import 'package:hubla_weather/app/core/http/interceptors/connectivity_interceptor.dart';
import 'package:hubla_weather/app/core/http/interceptors/logging_interceptor.dart';
import 'package:hubla_weather/app/core/http/interceptors/retry_interceptor.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';

/// Dio-based HTTP client that wraps all requests in a [Result] type.
///
/// Configures Dio with:
/// - Base URL and timeouts from [Env]
/// - [ConnectivityInterceptor] — fail fast when offline
/// - [AuthInterceptor] — append API key
/// - [LoggingInterceptor] — log requests/responses (debug only)
/// - [RetryInterceptor] — retry on 5xx / timeouts with exponential backoff
class HttpClient {
  HttpClient({
    required ConnectivityService connectivityService,
    required LoggerService loggerService,
  }) {
    _dio = Dio(
      BaseOptions(
        // ignore: avoid_redundant_argument_values
        baseUrl: Env.openWeatherBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    // Interceptor order matters:
    // 1. Connectivity — fail fast if offline
    // 2. Auth — append API key to every request
    // 3. Logging — log the fully-formed request/response
    // 4. Retry — wrap everything, retry on server errors/timeouts
    _dio.interceptors.addAll([
      ConnectivityInterceptor(connectivityService: connectivityService),
      AuthInterceptor(),
      LoggingInterceptor(loggerService: loggerService),
      RetryInterceptor(dio: _dio, loggerService: loggerService),
    ]);
  }

  late final Dio _dio;

  /// Executes the given [request] and returns a [Result] with either
  /// the response data or a typed [AppError].
  Future<Result<AppError, dynamic>> request(HttpRequest request) async {
    try {
      final response = await _dio.request<dynamic>(
        request.path,
        data: request.body.isNotEmpty ? request.body : null,
        queryParameters: request.queryParameters.isNotEmpty ? request.queryParameters : null,
        options: Options(
          method: request.method.name.toUpperCase(),
          headers: request.headers.isNotEmpty ? request.headers : null,
        ),
      );

      return Success(response.data);
    } on DioException catch (e, stackTrace) {
      return Error(_mapDioException(e, stackTrace));
    }
  }

  AppError _mapDioException(DioException exception, StackTrace stackTrace) {
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
}
