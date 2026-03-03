import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/env/env.dart';

/// Interceptor that appends the OpenWeatherMap API key to every request.
///
/// Adds `appid` as a query parameter from [Env.openWeatherApiKey].
class HublaAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['appid'] = Env.openWeatherApiKey;
    handler.next(options);
  }
}
