# Plan: Naming Consistency Refactor — Add `Hubla` Prefix to Core Classes

## Goal

Rename all generic-named classes in `lib/app/core/` (services, HTTP, interceptors) to use the project's `Hubla` prefix, matching the established pattern in the design system, routing, and some services. Also fix the broken test file and stale doc comment.

## Analysis

### Current inconsistency

The project uses `Hubla` prefix for:
- Design system: `HublaColorTokens`, `HublaThemes`, `HublaPrimaryButton`, etc.
- Routing: `HublaRoute`, `HublaBaseRoute`, `HublaRouteTransition`, etc.
- Some services: `HublaConnectivityService`, `HublaSecureStorageService` (concrete)

But NOT for:
- Services: `StorageService` (abstract), `HiveStorageService`, `SecureStorageService` (abstract), `LoggerService`
- HTTP: `HttpClient`, `HttpRequest`, `HttpResponse`, `HttpMethod`
- Interceptors: `LoggingInterceptor`, `ConnectivityInterceptor`, `CacheInterceptor`, `RetryInterceptor`, `AuthInterceptor`

### Rename mapping

| Current Name | New Name | File Rename | Type |
|---|---|---|---|
| `StorageService` | `HublaStorageService` | `storage_service.dart` → `hubla_storage_service.dart` | abstract |
| `HiveStorageService` | `HublaHiveStorageService` | `hive_storage_service.dart` → `hubla_hive_storage_service.dart` | concrete |
| `SecureStorageService` | `HublaSecureStorageService` | `secure_storage_service.dart` → `hubla_secure_storage_service.dart` | abstract |
| `HublaSecureStorageService` (concrete) | `HublaFlutterSecureStorageService` | `hubla_secure_storage_service.dart` → `hubla_flutter_secure_storage_service.dart` | concrete |
| `LoggerService` | `HublaLoggerService` | `logger_service.dart` → `hubla_logger_service.dart` | concrete |
| `HttpClient` | `HublaHttpClient` | `http_client.dart` → `hubla_http_client.dart` | concrete |
| `HttpRequest` | `HublaHttpRequest` | `http_request.dart` → `hubla_http_request.dart` | abstract |
| `HttpMethod` | `HublaHttpMethod` | (same file as HttpRequest) | enum |
| `HttpResponse` | `HublaHttpResponse` | `http_response.dart` → `hubla_http_response.dart` | concrete |
| `LoggingInterceptor` | `HublaLoggingInterceptor` | `logging_interceptor.dart` → `hubla_logging_interceptor.dart` | concrete |
| `ConnectivityInterceptor` | `HublaConnectivityInterceptor` | `connectivity_interceptor.dart` → `hubla_connectivity_interceptor.dart` | concrete |
| `CacheInterceptor` | `HublaCacheInterceptor` | `cache_interceptor.dart` → `hubla_cache_interceptor.dart` | concrete |
| `RetryInterceptor` | `HublaRetryInterceptor` | `retry_interceptor.dart` → `hubla_retry_interceptor.dart` | concrete |
| `AuthInterceptor` | `HublaAuthInterceptor` | `auth_interceptor.dart` → `hubla_auth_interceptor.dart` | concrete |

### Special handling: SecureStorageService collision

The abstract `SecureStorageService` will become `HublaSecureStorageService`, colliding with the current concrete class of the same name. Solution:
1. First rename concrete `HublaSecureStorageService` → `HublaFlutterSecureStorageService` (and its file)
2. Then rename abstract `SecureStorageService` → `HublaSecureStorageService` (and its file to the now-available `hubla_secure_storage_service.dart`)

### Bug fix: broken test file

- `test/app/core/services/flutter_secure_storage_service_test.dart` imports `flutter_secure_storage_service.dart` which doesn't exist
- The file should be renamed to `hubla_flutter_secure_storage_service_test.dart` and its import fixed
- The `SecureStorageService` abstract doc comment references `FlutterSecureStorageService` — needs updating

### Affected files (imports/references)

**lib/ files that need import updates:**
- `lib/main.dart` — `StorageService`
- `lib/app/core/di/service_locator.dart` — all services + HTTP
- `lib/app/core/http/http_client.dart` — `HttpRequest`, `HttpResponse`, `LoggerService`, `StorageService`, interceptors
- `lib/app/core/http/interceptors/logging_interceptor.dart` — `LoggerService`
- `lib/app/core/http/interceptors/connectivity_interceptor.dart` — (already uses `HublaConnectivityService`)
- `lib/app/core/http/interceptors/cache_interceptor.dart` — `StorageService`, `LoggerService`, `ConnectivityInterceptor`
- `lib/app/core/http/interceptors/retry_interceptor.dart` — `LoggerService`
- `lib/app/core/http/interceptors/auth_interceptor.dart` — (no service imports)
- `lib/app/core/services/hive_storage_service.dart` — `StorageService`
- `lib/app/core/services/hubla_secure_storage_service.dart` — `SecureStorageService`
- `lib/app/data/weather/datasources/remote/weather_remote_datasource.dart` — `HttpClient`
- `lib/app/data/weather/datasources/remote/requests/get_current_weather_request.dart` — `HttpRequest`
- `lib/app/data/weather/datasources/remote/requests/get_geocoding_request.dart` — `HttpRequest`
- `lib/app/data/weather/datasources/local/weather_local_datasource.dart` — `StorageService`
- `lib/app/data/auth/datasources/local/auth_local_datasource.dart` — `SecureStorageService`

**test/ files that need import updates:**
- `test/mocks/services_mocks.dart` — `LoggerService`, `SecureStorageService`, `StorageService`
- `test/mocks/general_mocks.dart` — `HttpClient`, `HttpRequest`
- `test/factories/datasources_factories.dart` — `HttpClient`, `SecureStorageService`, `StorageService`
- `test/widget_test.dart` — `SecureStorageService`
- `test/app/core/http/http_response_test.dart` — `HttpResponse`
- `test/app/core/http/http_request_test.dart` — `HttpRequest`, `HttpMethod`
- `test/app/core/http/app_dio_test.dart` — (no direct imports, but uses AppError)
- `test/app/core/http/interceptors/logging_interceptor_test.dart` — `LoggingInterceptor`
- `test/app/core/http/interceptors/retry_interceptor_test.dart` — `RetryInterceptor`
- `test/app/core/http/interceptors/auth_interceptor_test.dart` — `AuthInterceptor`
- `test/app/core/http/interceptors/cache_interceptor_test.dart` — `CacheInterceptor`, `ConnectivityInterceptor`
- `test/app/core/http/interceptors/connectivity_interceptor_test.dart` — `ConnectivityInterceptor`
- `test/app/core/services/flutter_secure_storage_service_test.dart` — broken import + rename
- `test/app/data/weather/datasources/remote/weather_remote_datasource_test.dart` — `HttpResponse`
- `test/app/data/weather/datasources/remote/requests/get_geocoding_request_test.dart` — `HttpRequest`
- `test/app/data/weather/datasources/remote/requests/get_current_weather_request_test.dart` — `HttpRequest`

## Steps

- [x] Step 1: Rename services (file + class + imports)
  - `StorageService` → `HublaStorageService`
  - `HiveStorageService` → `HublaHiveStorageService`
  - `LoggerService` → `HublaLoggerService`
  - Handle SecureStorageService collision (rename concrete first, then abstract)
  - Fix broken test file import/name
  - Fix stale doc comment

- [x] Step 2: Rename HTTP classes (file + class + imports)
  - `HttpClient` → `HublaHttpClient`
  - `HttpRequest` → `HublaHttpRequest` + `HttpMethod` → `HublaHttpMethod`
  - `HttpResponse` → `HublaHttpResponse`

- [x] Step 3: Rename interceptors (file + class + imports)
  - `LoggingInterceptor` → `HublaLoggingInterceptor`
  - `ConnectivityInterceptor` → `HublaConnectivityInterceptor`
  - `CacheInterceptor` → `HublaCacheInterceptor`
  - `RetryInterceptor` → `HublaRetryInterceptor`
  - `AuthInterceptor` → `HublaAuthInterceptor`

- [x] Step 4: Update all remaining imports across lib/ and test/

- [x] Step 5: Verify — `flutter analyze` passes with 0 issues, `flutter test` passes all 341 tests

## Notes

- The `RouteTransition` enum in `hubla_route_transition.dart` is a minor inconsistency but lives in an already-Hubla-prefixed file and is small enough to not rename now.
- `AppError`, `Result`, `Env` are framework-level primitives — generic naming is appropriate, not renaming.
- Domain entities, repositories, datasources, use cases correctly use domain-specific (not Hubla-prefixed) naming — no changes needed.
