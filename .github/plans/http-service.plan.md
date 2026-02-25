# Plan: HTTP Service (Dio Wrapper + Core Infrastructure)

## Goal
Create a decoupled HTTP service layer using Dio, along with the supporting core infrastructure: Result type, AppError hierarchy, Env config, ConnectivityService, LoggerService, and four Dio interceptors.

## Analysis

### Decisions Made
- **Contract**: `HttpClient.request(HttpRequest) → Future<Result<AppError, dynamic>>` (matches data-layer instructions)
- **Base URL**: From `--dart-define-from-file` via `Env` class (`OPEN_WEATHER_BASE_URL` + `OPEN_WEATHER_API_KEY`)
- **Result type**: Custom sealed class `Result<E, S>` with `Success`/`Error` (à la `result_dart`)
- **Interceptors**: Auth (API key), Logging (via `logger` package, debug only), Connectivity (fail-fast with `NoConnectionError`), Retry (3 attempts on 5xx/timeout, exponential backoff)
- **Connectivity check**: `internet_connection_checker_plus` for real reachability
- **Logger**: `logger` package from pub.dev
- **Timeouts**: connect 10s, receive 15s, send 10s

### Files to Create

```
lib/app/core/
├── env/
│   └── env.dart                          # String.fromEnvironment for API key + base URL
├── errors/
│   ├── app_error.dart                    # AppError base, NoConnectionError, SerializationError, HttpError, TimeoutError
│   └── result.dart                       # Result<E, S> sealed class, Success, Error
├── http/
│   ├── http_client.dart                  # Dio wrapper class
│   ├── http_request.dart                 # Abstract HttpRequest + HttpMethod enum
│   └── interceptors/
│       ├── auth_interceptor.dart         # Appends appid query param
│       ├── logging_interceptor.dart      # Logs via logger package (debug only)
│       ├── connectivity_interceptor.dart # Checks real internet, fails fast
│       └── retry_interceptor.dart        # 3 retries, exponential backoff, 5xx + timeout
├── services/
│   ├── connectivity_service.dart         # Wraps internet_connection_checker_plus
│   └── logger_service.dart              # Wraps logger package, debug-only guard
```

### Dependencies
- `dio` — already in pubspec.yaml
- `connectivity_plus` — already in pubspec.yaml
- `internet_connection_checker_plus` — already in pubspec.yaml
- `logger` — **needs to be added** to pubspec.yaml

### Cross-Dependencies
- `ConnectivityInterceptor` depends on `ConnectivityService`
- `LoggingInterceptor` depends on `LoggerService`
- `AuthInterceptor` depends on `Env.openWeatherApiKey`
- `HttpClient` composes Dio + all four interceptors
- `service_locator.dart` will register all new classes

## Steps

- [x] Step 1: Add `logger` package to `pubspec.yaml`
  - Run `flutter pub add logger`

- [x] Step 2: Create `Env` class at `lib/app/core/env/env.dart`
  - `OPEN_WEATHER_API_KEY` and `OPEN_WEATHER_BASE_URL` via `String.fromEnvironment`
  - Creates: `env.dart`

- [x] Step 3: Create `Result<E, S>` sealed class at `lib/app/core/errors/result.dart`
  - `Result`, `Success<E, S>`, `Error<E, S>`
  - Methods: `when`, `getSuccess`, `getError`, `isSuccess`, `isError`
  - Creates: `result.dart`

- [x] Step 4: Create `AppError` hierarchy at `lib/app/core/errors/app_error.dart`
  - Base: `AppError` (with `errorMessage`, optional `statusCode`, `stackTrace`)
  - Subclasses: `NoConnectionError`, `HttpError`, `TimeoutError`, `SerializationError`, `UnknownError`
  - Creates: `app_error.dart`

- [x] Step 5: Create `LoggerService` at `lib/app/core/services/logger_service.dart`
  - Wraps `logger` package's `Logger`
  - All methods guarded by `kDebugMode`
  - Methods: `debug`, `info`, `warning`, `error`
  - Creates: `logger_service.dart`

- [x] Step 6: Create `ConnectivityService` at `lib/app/core/services/connectivity_service.dart`
  - Wraps `InternetConnection` from `internet_connection_checker_plus`
  - Method: `Future<bool> hasInternetConnection()`
  - Stream: `Stream<InternetStatus> onStatusChanged` (for offline banner)
  - Creates: `connectivity_service.dart`

- [x] Step 7: Create `HttpRequest` + `HttpMethod` at `lib/app/core/http/http_request.dart`
  - `HttpMethod` enum: `get`, `post`, `put`, `patch`, `delete`
  - Abstract `HttpRequest`: `path`, `method`, `body`, `queryParameters`, `headers`
  - Creates: `http_request.dart`

- [x] Step 8: Create `AuthInterceptor` at `lib/app/core/http/interceptors/auth_interceptor.dart`
  - Extends `Interceptor`
  - `onRequest`: appends `appid` query param from `Env.openWeatherApiKey`
  - Creates: `auth_interceptor.dart`

- [x] Step 9: Create `ConnectivityInterceptor` at `lib/app/core/http/interceptors/connectivity_interceptor.dart`
  - Extends `Interceptor`
  - `onRequest`: checks `ConnectivityService.hasInternetConnection()`, rejects with `NoConnectionError` if offline
  - Creates: `connectivity_interceptor.dart`

- [x] Step 10: Create `LoggingInterceptor` at `lib/app/core/http/interceptors/logging_interceptor.dart`
  - Extends `Interceptor`
  - Logs request (method, URL, headers, body) and response (status, body) via `LoggerService`
  - Only active in debug mode
  - Creates: `logging_interceptor.dart`

- [x] Step 11: Create `RetryInterceptor` at `lib/app/core/http/interceptors/retry_interceptor.dart`
  - Extends `Interceptor`
  - `onError`: retries on 5xx or timeout (DioExceptionType.connectionTimeout, receiveTimeout, sendTimeout)
  - Max 3 retries, exponential backoff (1s, 2s, 4s)
  - Creates: `retry_interceptor.dart`

- [x] Step 12: Create `HttpClient` at `lib/app/core/http/app_dio.dart`
  - Composes Dio with base URL, timeouts, and all 4 interceptors
  - Method: `Future<Result<AppError, dynamic>> request(HttpRequest request)`
  - Catches `DioException` and maps to typed `AppError` subclasses
  - Creates: `app_dio.dart`

- [x] Step 13: Register all new classes in `service_locator.dart`
  - Order: LoggerService → ConnectivityService → HttpClient (with interceptors)
  - Modifies: `service_locator.dart`

- [x] Step 14: Verify with `flutter analyze` — must pass with no errors/warnings

## Notes
- `config/dev.json` file should be gitignored — document the expected format but don't commit it
- The interceptor order on Dio matters: Connectivity → Auth → Logging → Retry (connectivity first to fail fast, retry last to wrap everything)
- File named `app_dio.dart` (not `http_client.dart`) to match architecture instructions
- Added `meta` as direct dependency for `@immutable` annotation on `Success`/`Error`
- `AppError.label` field used instead of `runtimeType.toString()` to satisfy `no_runtimetype_tostring` lint
- `Env` fields use `// ignore: do_not_use_environment` since `String.fromEnvironment` is the intended compile-time injection mechanism
