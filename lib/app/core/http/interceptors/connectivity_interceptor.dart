import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';

/// Interceptor that annotates requests with the current connectivity status.
///
/// Checks [ConnectivityService.hasInternetConnection] before every request
/// and stores the result in `options.extra['isOffline']`. Downstream
/// interceptors (e.g., `CacheInterceptor`) use this flag to decide whether
/// to serve cached data.
///
/// The key used in `extra` is exposed as [isOfflineKey] for consistency.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required ConnectivityService connectivityService}) : _connectivityService = connectivityService;

  final ConnectivityService _connectivityService;

  /// Key stored in [RequestOptions.extra] indicating offline status.
  static const String isOfflineKey = 'isOffline';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await _connectivityService.hasInternetConnection();
    options.extra[isOfflineKey] = !hasConnection;
    handler.next(options);
  }
}
