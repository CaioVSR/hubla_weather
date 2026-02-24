---
applyTo: "lib/app/core/**"
---

<!-- Version: 1.0.0 -->

# Dependency Injection (v1.0.0)

This project uses `get_it` as the service locator for dependency injection.

## Setup

```dart
final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Core services
  serviceLocator
    ..registerLazySingleton<HttpClient>(() => HttpClient())
    ..registerLazySingleton<StorageService>(() => StorageService());

  // Feature: Weather
  serviceLocator
    ..registerLazySingleton<WeatherLocalDatasource>(
      () => WeatherLocalDatasource(storageService: serviceLocator()),
    )
    ..registerLazySingleton<WeatherRemoteDatasource>(
      () => WeatherRemoteDatasource(client: serviceLocator()),
    )
    ..registerLazySingleton<WeatherRepository>(
      () => WeatherRepository(
        localDatasource: serviceLocator(),
        remoteDatasource: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetCityWeatherUseCase>(
      () => GetCityWeatherUseCase(weatherRepository: serviceLocator()),
    );

  // Cubits (use registerFactory — new instance per screen)
  serviceLocator
    ..registerFactory<CitiesCubit>(
      () => CitiesCubit(getCityWeatherUseCase: serviceLocator()),
    );

  // Router
  serviceLocator.registerLazySingleton<GoRouter>(() => createRouter(serviceLocator()));
}
```

## Rules

- Use `registerLazySingleton` for stateless services, datasources, repositories, and use cases
- Use `registerFactory` for cubits — each screen gets a fresh instance
- Registration order matters: register dependencies before their dependants
- Group registrations by feature for readability
- Never access `serviceLocator` (GetIt) inside cubits — inject all dependencies via constructor
- Call `setupServiceLocator()` in `main()` before `runApp()`
- Use `serviceLocator<T>()` (call syntax) to resolve — equivalent to `serviceLocator.get<T>()`
- Use `serviceLocator.reset()` only in tests
