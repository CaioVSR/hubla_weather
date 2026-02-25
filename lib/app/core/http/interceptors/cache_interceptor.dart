import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/http/interceptors/connectivity_interceptor.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';
import 'package:hubla_weather/app/core/services/storage_service.dart';

/// Interceptor that caches GET responses and serves them when offline.
///
/// Works with [ConnectivityInterceptor] which annotates requests with
/// `isOffline` status. Only caches requests whose `isCacheable` extra
/// flag is `true`.
///
/// **On request (offline + cacheable):** Serves cached data if available;
/// otherwise lets the request proceed to fail naturally.
///
/// **On response (cacheable):** Caches the response data for later offline use.
///
/// **On error (cacheable):** Falls back to cached data if available.
class CacheInterceptor extends Interceptor {
  CacheInterceptor({
    required StorageService storageService,
    required LoggerService loggerService,
  }) : _storageService = storageService,
       _loggerService = loggerService;

  final StorageService _storageService;
  final LoggerService _loggerService;

  /// Key stored in [RequestOptions.extra] indicating the request is cacheable.
  static const String isCacheableKey = 'isCacheable';

  /// Key stored in [Response.extra] indicating the response is from cache.
  static const String isFromCacheKey = 'isFromCache';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isCacheable = options.extra[isCacheableKey] as bool? ?? false;
    final isOffline = options.extra[ConnectivityInterceptor.isOfflineKey] as bool? ?? false;

    if (!isCacheable || !isOffline) {
      return handler.next(options);
    }

    // Offline + cacheable: try to serve from cache
    final cacheKey = _generateCacheKey(options);
    final cachedData = await _storageService.read<dynamic>(cacheKey);

    if (cachedData != null) {
      _loggerService.info('Cache hit (offline): $cacheKey');
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
          extra: {isFromCacheKey: true},
        ),
      );
    }

    _loggerService.warning('Cache miss (offline): $cacheKey');
    // No cached data — let request proceed to fail naturally
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final isCacheable = response.requestOptions.extra[isCacheableKey] as bool? ?? false;

    if (isCacheable && response.data != null) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      await _storageService.write(key: cacheKey, value: response.data);
      _loggerService.debug('Cached response: $cacheKey');
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isCacheable = err.requestOptions.extra[isCacheableKey] as bool? ?? false;

    if (!isCacheable) {
      return handler.next(err);
    }

    // Try to serve cached data as fallback
    final cacheKey = _generateCacheKey(err.requestOptions);
    final cachedData = await _storageService.read<dynamic>(cacheKey);

    if (cachedData != null) {
      _loggerService.info('Cache fallback on error: $cacheKey');
      return handler.resolve(
        Response<dynamic>(
          requestOptions: err.requestOptions,
          data: cachedData,
          statusCode: 200,
          extra: {isFromCacheKey: true},
        ),
      );
    }

    handler.next(err);
  }

  /// Generates a deterministic cache key from the request path and sorted
  /// query parameters, excluding the `appid` key.
  ///
  /// Example: `/data/2.5/weather|lang=en&lat=-23.5505&lon=-46.6333&units=metric`
  String _generateCacheKey(RequestOptions options) {
    final params = Map<String, dynamic>.of(options.queryParameters)..remove('appid');
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys.map((k) => '$k=${params[k]}').join('&');

    if (paramString.isEmpty) {
      return options.path;
    }
    return '${options.path}|$paramString';
  }
}
