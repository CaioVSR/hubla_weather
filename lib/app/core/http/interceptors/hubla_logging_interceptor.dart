import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/services/hubla_logger_service.dart';

/// Interceptor that logs HTTP requests and responses via [HublaLoggerService].
///
/// Only active in debug mode (guarded internally by [HublaLoggerService]).
class HublaLoggingInterceptor extends Interceptor {
  HublaLoggingInterceptor({required HublaLoggerService loggerService}) : _loggerService = loggerService;

  final HublaLoggerService _loggerService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('──── REQUEST ────')
      ..writeln('${options.method} ${options.uri}')
      ..writeln('Headers: ${options.headers}');

    if (options.data != null) {
      buffer.writeln('Body: ${options.data}');
    }

    _loggerService.info(buffer.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('──── RESPONSE ────')
      ..writeln('${response.statusCode} ${response.requestOptions.uri}')
      ..writeln('Data: ${response.data}');

    _loggerService.info(buffer.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('──── ERROR ────')
      ..writeln('${err.type} ${err.requestOptions.uri}')
      ..writeln('Message: ${err.message}');

    if (err.response != null) {
      buffer.writeln('Status: ${err.response?.statusCode}');
      buffer.writeln('Data: ${err.response?.data}');
    }

    _loggerService.error(buffer.toString(), error: err, stackTrace: err.stackTrace);
    handler.next(err);
  }
}
