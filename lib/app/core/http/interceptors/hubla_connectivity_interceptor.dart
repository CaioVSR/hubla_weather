import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/services/hubla_connectivity_service.dart';

/// Interceptor that annotates requests with the current connectivity status.
///
/// Checks [HublaConnectivityService.hasInternetConnection] before every request
/// and stores the result in `options.extra['isOffline']`. Downstream
/// interceptors (e.g., `HublaCacheInterceptor`) use this flag to decide whether
/// to serve cached data.
///
/// The key used in `extra` is exposed as [isOfflineKey] for consistency.
class HublaConnectivityInterceptor extends Interceptor {
  HublaConnectivityInterceptor({required HublaConnectivityService connectivityService}) : _connectivityService = connectivityService;

  final HublaConnectivityService _connectivityService;

  /// Key stored in [RequestOptions.extra] indicating offline status.
  static const String isOfflineKey = 'isOffline';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final hasConnection = await _connectivityService.hasInternetConnection();
    options.extra[isOfflineKey] = !hasConnection;
    handler.next(options);
  }
}
