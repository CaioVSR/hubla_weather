# Plan: Cities Weather — Domain & Data Layers

## Goal
Implement the domain and data layers for the City List feature, including entities, enums, errors, use cases, repository, datasources (local + remote), and HTTP request objects — with full offline-first caching via the existing `CacheInterceptor` + `StorageService` infrastructure.

## Analysis

### What already exists
- **HttpClient** (`app_dio.dart`): Dio wrapper with interceptors (connectivity, cache, auth, logging, retry). Returns `Result<AppError, HttpResponse>`.
- **CacheInterceptor**: Caches GET responses in `StorageService` (Hive) keyed by `path|sorted_params`. Serves cached data when offline. Falls back to cache on errors. Triggered by `isCacheable: true` on the request.
- **AuthInterceptor**: Appends `appid` query param from `Env.openWeatherApiKey`.
- **StorageService / HiveStorageService**: Generic key-value store with box support. Already initialized in `main()`.
- **Env**: Has `openWeatherBaseUrl` and `openWeatherApiKey` from `--dart-define-from-file`.
- **HttpRequest**: Abstract base with `path`, `method`, `queryParameters`, `isCacheable`.
- **HttpResponse**: Wraps `data` + `isFromCache` flag.
- **AppError hierarchy**: NoConnectionError, HttpError, TimeoutError, SerializationError, UnknownError.
- **Result<E, S>**: Sealed Success/Error with `.when()`, `.getSuccess()`, `.getError()`.

### Key design decisions
1. **Cache strategy**: The `CacheInterceptor` already handles HTTP-level caching. The `WeatherLocalDatasource` provides a **domain-level** cache layer for structured entities (read/write `CityWeather` objects). Per-city keys in Hive (`weather_sao-paulo`) for granular updates and independent reads.
2. **Two datasources**: `WeatherRemoteDatasource` for API calls, `WeatherLocalDatasource` for persisting parsed entities to Hive.
3. **Repository orchestration**: Fetch all 10 cities in parallel. For each city: remote success → save to local → return. On per-city error → fall back to local cache with `isStale: true`. Return partial results always — never fail the whole batch. Only return `NoCachedDataError` if ALL cities fail AND there's zero cached data.
4. **City model**: Enhanced enum with lat/lon/slug. Not serializable (fixed set, never sent/received from API).
5. **Stale indicator**: `CityWeather` has an `isStale` flag (default `false`). Set to `true` when data comes from cache after a failed refresh. Presentation layer uses this to show a "data not live" indicator.
6. **OpenWeatherMap endpoints**:
   - `GET /data/2.5/weather?lat={lat}&lon={lon}&units=metric&lang=en` → current weather
   - `GET /data/2.5/forecast?lat={lat}&lon={lon}&units=metric&lang=en` → 5-day forecast (used later)

### Cross-dependencies
- Domain entities are used by both data and presentation layers
- Data layer depends on core (HttpClient, StorageService, AppError, Result) and domain (entities, errors)
- Use cases depend on the repository
- Presentation (future) will depend on use cases

## Steps

- [x] Step 1: Create `City` enhanced enum with hardcoded Brazilian cities
  - Creates: `lib/app/domain/weather/enums/city.dart`
  - Enhanced enum with name, slug (cityId), lat, lon
  - 10 cities as enum values, not @JsonSerializable

- [x] Step 2: Create `WeatherCondition` enum
  - Creates: `lib/app/domain/weather/enums/weather_condition.dart`
  - Maps OpenWeatherMap `main` field values (Clear, Clouds, Rain, Drizzle, Thunderstorm, Snow, Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall, Tornado) to enum values
  - Has `unknown` fallback + `@JsonValue` annotations

- [x] Step 3: Create `CityWeather` entity
  - Creates: `lib/app/domain/weather/entities/city_weather.dart`
  - Fields: city (City), condition (WeatherCondition), conditionDescription (String), iconCode (String), tempMax (double), tempMin (double), humidity (int), windSpeed (double), isStale (bool, default false)
  - `@JsonSerializable()`, Equatable, fromJson/toJson
  - `isStale` is NOT serialized (`@JsonKey(includeFromJson: false, includeToJson: false)`) — it's a runtime-only flag set by the repository

- [x] Step 4: Create `WeatherError` sealed class
  - Creates: `lib/app/domain/weather/errors/weather_error.dart`
  - `sealed class WeatherError extends AppError`
  - Concrete: `FetchWeatherError`, `NoCachedDataError`

- [x] Step 5: Create `WeatherRemoteDatasource` + HTTP request objects
  - Creates: `lib/app/data/weather/datasources/remote/weather_remote_datasource.dart`
  - Creates: `lib/app/data/weather/datasources/remote/requests/get_current_weather_request.dart`
  - Request: `GET /data/2.5/weather`, params: lat, lon, units=metric, lang=en, `isCacheable: true`
  - Datasource: takes HttpClient, calls request for a single city, parses response into `CityWeather`

- [x] Step 6: Create `WeatherLocalDatasource`
  - Creates: `lib/app/data/weather/datasources/local/weather_local_datasource.dart`
  - Uses StorageService to persist/retrieve `CityWeather` entities
  - Per-city keys: `weather_{cityId}` (e.g. `weather_sao-paulo`)
  - Methods: `saveCityWeather(CityWeather)`, `getCityWeather(String cityId) → CityWeather?`, `getAllCachedCitiesWeather() → List<CityWeather>`

- [x] Step 7: Create `WeatherRepository`
  - Creates: `lib/app/data/weather/weather_repository.dart`
  - Depends on: WeatherRemoteDatasource + WeatherLocalDatasource
  - `getAllCitiesWeather()`: Fetch weather for all 10 cities in parallel. Per-city: on success → save to local, return CityWeather. On error → fall back to cached CityWeather with `isStale: true`. Collect all results into a list. Return `NoCachedDataError` only if ALL cities fail AND zero cache exists.
  - `getCityWeather(City city)`: Fetch single city weather, save to local, return. Fallback to cache with `isStale: true` on error.

- [x] Step 8: Create `GetAllCitiesWeatherUseCase`
  - Creates: `lib/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart`
  - Callable class, delegates to `WeatherRepository.getAllCitiesWeather()`

- [x] Step 9: Register in DI (service_locator.dart)
  - Modifies: `lib/app/core/di/service_locator.dart`
  - Register: WeatherRemoteDatasource, WeatherLocalDatasource, WeatherRepository, GetAllCitiesWeatherUseCase

- [x] Step 10: Create test mocks, factories, and unit tests
  - Mocks: MockWeatherRepository, MockWeatherRemoteDatasource, MockWeatherLocalDatasource, MockGetAllCitiesWeatherUseCase
  - Factories: CityWeatherFactory, CityFactory (if needed)
  - Tests: WeatherRemoteDatasource, WeatherLocalDatasource, WeatherRepository, GetAllCitiesWeatherUseCase, entity/enum tests

- [x] Step 11: Verify — `flutter analyze` + `flutter test`

## Notes
- The `CacheInterceptor` gives HTTP-level offline caching. The `WeatherLocalDatasource` adds a domain-level structured cache for search/filter/stale detection.
- Per-city caching (keyed by slug) allows the forecast detail screen to reuse the same pattern later.
- The `isCacheable: true` flag on the request object enables the existing interceptor pipeline — no new interceptor code needed.
- `City` is an enhanced enum — not serializable. When `CityWeather` is serialized, the city is stored by its slug string and resolved back via `City.fromSlug()`.
- `isStale` is a runtime-only flag, not persisted. It's set by the repository when a refresh fails and cached data is returned instead.
- Partial failures: the repository always returns data when possible. The presentation layer decides how to visually indicate stale items.
