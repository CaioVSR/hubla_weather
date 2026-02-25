---
applyTo: "lib/app/core/**"
---

<!-- Version: 1.1.0 -->

# Dependency Injection (v1.1.0)

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

  // Router
  serviceLocator.registerLazySingleton<GoRouter>(() => createRouter(serviceLocator()));
}
```

## Rules

- Use `registerLazySingleton` for stateless services, datasources, repositories, and use cases
- **Never register cubits in the service locator** — instantiate them directly in the route's `BlocProvider.create` callback
- Registration order matters: register dependencies before their dependants
- Group registrations by feature for readability
- Never access `serviceLocator` (GetIt) inside cubits — inject all dependencies via constructor
- Call `setupServiceLocator()` in `main()` before `runApp()`
- Use `serviceLocator<T>()` (call syntax) to resolve — equivalent to `serviceLocator.get<T>()`
- Use `serviceLocator.reset()` only in tests

## Cubits at the Route Level

Cubits are **not** managed by the service locator. They are instantiated directly inside the route definition via `BlocProvider`:

```dart
class FeatureRoute extends HublaBaseRoute {
  @override
  GoRouterWidgetBuilder get builder =>
      (context, state) => BlocProvider(
        create: (_) => FeatureCubit(
          someUseCase: serviceLocator(),
        ),
        child: const FeaturePage(),
      );
}
```

Use `serviceLocator()` to resolve use-case / service dependencies inside the `create` callback, but the cubit itself is always `new`'d there.
