import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/http/app_dio.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_app_router.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Core services
  serviceLocator
    ..registerLazySingleton<LoggerService>(LoggerService.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<HttpClient>(
      () => HttpClient(
        connectivityService: serviceLocator(),
        loggerService: serviceLocator(),
      ),
    );

  // Router
  serviceLocator.registerLazySingleton<GoRouter>(createRouter);
}
