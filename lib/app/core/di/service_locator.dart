import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/http/app_dio.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/core/services/flutter_secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/hive_storage_service.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';
import 'package:hubla_weather/app/core/services/secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/storage_service.dart';
import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/get_session_use_case.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_app_router.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Core services
  serviceLocator
    ..registerLazySingleton<LoggerService>(LoggerService.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<StorageService>(HiveStorageService.new)
    ..registerLazySingleton<SecureStorageService>(FlutterSecureStorageService.new)
    ..registerLazySingleton<HttpClient>(
      () => HttpClient(
        connectivityService: serviceLocator(),
        loggerService: serviceLocator(),
        storageService: serviceLocator(),
      ),
    );

  // Feature: Auth
  serviceLocator
    ..registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(secureStorageService: serviceLocator()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(authLocalDatasource: serviceLocator()),
    )
    ..registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(authRepository: serviceLocator()),
    )
    ..registerLazySingleton<GetSessionUseCase>(
      () => GetSessionUseCase(authRepository: serviceLocator()),
    );

  // Router
  serviceLocator.registerLazySingleton<GoRouter>(() => createRouter(getSessionUseCase: serviceLocator()));
}
