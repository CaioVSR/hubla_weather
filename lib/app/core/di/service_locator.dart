import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/http/hubla_http_client.dart';
import 'package:hubla_weather/app/core/services/hubla_connectivity_service.dart';
import 'package:hubla_weather/app/core/services/hubla_flutter_secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_hive_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_logger_service.dart';
import 'package:hubla_weather/app/core/services/hubla_secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_storage_service.dart';
import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';
import 'package:hubla_weather/app/data/weather/weather_repository.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/get_session_use_case.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_app_router.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  _registerCore();
  _registerData();
  _registerDomain();
  _registerRouter();
}

// ── Core ──────────────────────────────────────────────────────────────────────

void _registerCore() {
  serviceLocator
    ..registerLazySingleton<HublaLoggerService>(HublaLoggerService.new)
    ..registerLazySingleton<HublaConnectivityService>(HublaConnectivityService.new)
    ..registerLazySingleton<HublaStorageService>(HublaHiveStorageService.new)
    ..registerLazySingleton<HublaSecureStorageService>(HublaFlutterSecureStorageService.new)
    ..registerLazySingleton<HublaHttpClient>(
      () => HublaHttpClient(
        connectivityService: serviceLocator(),
        loggerService: serviceLocator(),
        storageService: serviceLocator(),
      ),
    );
}

// ── Data ──────────────────────────────────────────────────────────────────────

void _registerData() {
  serviceLocator
    // Auth
    ..registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(secureStorageService: serviceLocator()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(authLocalDatasource: serviceLocator()),
    )
    // Weather
    ..registerLazySingleton<WeatherRemoteDatasource>(
      () => WeatherRemoteDatasource(client: serviceLocator()),
    )
    ..registerLazySingleton<WeatherLocalDatasource>(
      () => WeatherLocalDatasource(storageService: serviceLocator()),
    )
    ..registerLazySingleton<WeatherRepository>(
      () => WeatherRepository(
        weatherRemoteDatasource: serviceLocator(),
        weatherLocalDatasource: serviceLocator(),
      ),
    );
}

// ── Domain ────────────────────────────────────────────────────────────────────

void _registerDomain() {
  serviceLocator
    // Auth
    ..registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(authRepository: serviceLocator()),
    )
    ..registerLazySingleton<GetSessionUseCase>(
      () => GetSessionUseCase(authRepository: serviceLocator()),
    )
    // Weather
    ..registerLazySingleton<GetAllCitiesWeatherUseCase>(
      () => GetAllCitiesWeatherUseCase(weatherRepository: serviceLocator()),
    );
}

// ── Router ────────────────────────────────────────────────────────────────────

void _registerRouter() {
  serviceLocator.registerLazySingleton<GoRouter>(
    () => createRouter(getSessionUseCase: serviceLocator()),
  );
}
