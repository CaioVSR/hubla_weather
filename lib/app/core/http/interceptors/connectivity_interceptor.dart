import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';

/// Interceptor that fails fast when the device has no internet connection.
///
/// Checks [ConnectivityService.hasInternetConnection] before every request.
/// If offline, rejects with a [DioException] of type [DioExceptionType.connectionError].
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required ConnectivityService connectivityService}) : _connectivityService = connectivityService;

  final ConnectivityService _connectivityService;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await _connectivityService.hasInternetConnection();

    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
    }

    handler.next(options);
  }
}
