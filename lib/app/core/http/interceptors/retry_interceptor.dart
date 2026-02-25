import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';

/// Interceptor that retries failed requests on 5xx errors and timeouts.
///
/// - Max retries: 3
/// - Backoff: exponential (1s, 2s, 4s)
/// - Retryable conditions: server errors (5xx) and timeout exceptions
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    required LoggerService loggerService,
    this.maxRetries = 3,
  }) : _dio = dio,
       _loggerService = loggerService;

  final Dio _dio;
  final LoggerService _loggerService;

  /// Maximum number of retry attempts.
  final int maxRetries;

  static const _retryCountKey = 'retryCount';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = (err.requestOptions.extra[_retryCountKey] as int?) ?? 0;

    if (!_shouldRetry(err) || retryCount >= maxRetries) {
      return handler.next(err);
    }

    final nextRetry = retryCount + 1;
    final backoffDuration = Duration(seconds: 1 << retryCount); // 1s, 2s, 4s

    _loggerService.warning('Retry $nextRetry/$maxRetries after ${backoffDuration.inSeconds}s for ${err.requestOptions.uri}');

    await Future<void>.delayed(backoffDuration);

    err.requestOptions.extra[_retryCountKey] = nextRetry;

    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException err) {
    // Retry on timeout errors
    if (_isTimeoutError(err)) {
      return true;
    }

    // Retry on 5xx server errors
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }

    return false;
  }

  bool _isTimeoutError(DioException err) => switch (err.type) {
    DioExceptionType.connectionTimeout => true,
    DioExceptionType.receiveTimeout => true,
    DioExceptionType.sendTimeout => true,
    _ => false,
  };
}
