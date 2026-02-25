# Plan: Local DB + Cache Interceptor (Offline-First)

## Goal
Create an agnostic, decoupled local storage layer using Hive CE under the hood, plus a Dio cache interceptor that caches responses and serves them when offline — enabling the app's offline-first strategy.

## Decisions Made
- **Cache key**: Auto-generated from request path + sorted query params (excluding `appid`)
- **Cache scope**: Opt-in per request via `isCacheable` flag on `HttpRequest` (default `false`)
- **StorageService contract**: Abstract class in `core/services/`, with `HiveStorageService` implementation
- **Cache metadata**: `HttpResponse` wrapper with `data` + `isFromCache` — replaces `dynamic` return in `HttpClient`
- **Box strategy**: Default `'cache'` box for HTTP response caching; named boxes for feature-specific storage
- **Cache overwrite**: Always overwrite — latest successful response replaces old cached data (no TTL/expiration)

## Analysis

### Architecture
The storage layer sits in `core/services/` as cross-cutting infrastructure:
- `StorageService` (abstract) — agnostic contract, no Hive imports
- `HiveStorageService` (concrete) — Hive CE implementation, only class that imports `hive_ce`

The cache interceptor sits alongside the existing interceptors:
- `CacheInterceptor` — on successful response: cache it; on offline error: serve cached data

### Cross-Dependencies
- `CacheInterceptor` depends on `StorageService` (to read/write cached responses)
- `HttpClient` (`app_dio.dart`) gets a new interceptor + changed return type (`HttpResponse` instead of `dynamic`)
- `HttpRequest` gets an `isCacheable` getter (default `false`)
- `HttpResponse` is a new value class in `core/http/`
- `service_locator.dart` registers `StorageService` (as `HiveStorageService`) before `HttpClient`
- `main.dart` must call `StorageService.init()` before `runApp()`

### Interceptor Order (updated)
1. **Connectivity** — check connection, but DON'T reject if offline (new behavior needed)
2. **Cache** — if offline, serve cached; if online, pass through. On response, cache it.
3. **Auth** — append API key
4. **Logging** — log request/response
5. **Retry** — retry on 5xx/timeouts

> **Important change**: The `ConnectivityInterceptor` currently rejects when offline. With offline-first caching, we need a different approach: remove the connectivity interceptor's rejection, and let the **CacheInterceptor** handle offline by serving cached data. The connectivity interceptor should annotate the request with connection status instead of rejecting.

### Files to Create
```
lib/app/core/
├── http/
│   ├── http_response.dart                    # HttpResponse(data, isFromCache)
│   └── interceptors/
│       └── cache_interceptor.dart            # Cache read/write interceptor
├── services/
│   ├── storage_service.dart                  # Abstract StorageService contract
│   └── hive_storage_service.dart             # Hive CE implementation
```

### Files to Modify
```
lib/app/core/
├── http/
│   ├── app_dio.dart                          # Add cache interceptor, change return type
│   ├── http_request.dart                     # Add isCacheable getter
│   └── interceptors/
│       └── connectivity_interceptor.dart     # Annotate instead of reject
├── di/
│   └── service_locator.dart                  # Register StorageService
lib/
└── main.dart                                 # Init storage before runApp
```

## Steps

- [x] Step 1: Create `StorageService` abstract class at `lib/app/core/services/storage_service.dart`
  - Methods: `init()`, `read<T>()`, `write<T>()`, `delete()`, `clear()`
  - Default box name constant
  - No Hive imports — pure Dart contract
  - Creates: `storage_service.dart`

- [x] Step 2: Create `HiveStorageService` at `lib/app/core/services/hive_storage_service.dart`
  - Implements `StorageService`
  - `init()` calls `Hive.initFlutter()` and opens default box
  - Lazily opens named boxes on first access
  - Stores raw JSON (`Map<String, dynamic>` / `List` / primitives) — no custom type adapters needed for cache
  - Creates: `hive_storage_service.dart`

- [x] Step 3: Create `HttpResponse` at `lib/app/core/http/http_response.dart`
  - Fields: `dynamic data`, `bool isFromCache`
  - Equatable for testability
  - Creates: `http_response.dart`

- [x] Step 4: Add `isCacheable` getter to `HttpRequest`
  - Default: `false`
  - Subclasses override to `true` to opt in to caching
  - Modifies: `http_request.dart`

- [x] Step 5: Refactor `ConnectivityInterceptor` to annotate instead of reject
  - Instead of rejecting when offline, store `isOffline: true` in `options.extra`
  - Let the request proceed so the cache interceptor can handle it
  - Modifies: `connectivity_interceptor.dart`

- [x] Step 6: Create `CacheInterceptor` at `lib/app/core/http/interceptors/cache_interceptor.dart`
  - Depends on `StorageService`
  - `onRequest`:
    - Check `options.extra['isCacheable']` — skip if false
    - If offline (`options.extra['isOffline']`): look up cache, resolve with cached data + `isFromCache: true` header/extra, or pass through to fail naturally
  - `onResponse`:
    - If cacheable: write response data to storage (key = auto-generated from URL)
    - Pass response through
  - `onError`:
    - If cacheable + has cached data: resolve with cached response instead of error
    - Otherwise: pass error through
  - Cache key generation: `_generateCacheKey(RequestOptions options)` → `path|sorted_params`
  - Creates: `cache_interceptor.dart`

- [x] Step 7: Update `HttpClient` (`app_dio.dart`)
  - Add `CacheInterceptor` to interceptor list (position 2, after connectivity)
  - Change return type from `Result<AppError, dynamic>` to `Result<AppError, HttpResponse>`
  - Wrap successful Dio responses in `HttpResponse(data: ..., isFromCache: false)`
  - The cache interceptor marks cached responses via `response.extra['isFromCache']`
  - Modifies: `app_dio.dart`

- [x] Step 8: Propagate `isCacheable` from `HttpRequest` to Dio's `options.extra`
  - In `HttpClient.request()`, set `options.extra['isCacheable'] = request.isCacheable`  
  - Modifies: `app_dio.dart`

- [x] Step 9: Register `StorageService` in `service_locator.dart`
  - Register as `registerLazySingleton<StorageService>(HiveStorageService.new)`
  - Must be before `HttpClient` registration
  - Pass `StorageService` to `HttpClient` constructor (for cache interceptor)
  - Modifies: `service_locator.dart`

- [x] Step 10: Initialize storage in `main.dart`
  - Call `await serviceLocator<StorageService>().init()` after `setupServiceLocator()` and before `runApp()`
  - Modifies: `main.dart`

- [x] Step 11: Verify with `flutter analyze` — must pass with no errors/warnings

- [x] Step 12: Verify with `flutter test` — all existing tests must pass

## Notes
- Hive boxes store JSON-serializable data (Map/List/String/num/bool). For the cache interceptor, Dio response `data` (which is already decoded JSON) is stored directly — no custom TypeAdapters needed.
- The `StorageService` is generic enough to be used by feature local datasources too (e.g., `WeatherLocalDatasource` for explicit cache reads).
- Cache key excludes `appid` to avoid key changes if the API key rotates.
- No TTL/expiration — the spec says "latest successful response always overwrites the cache".
- `flutter_secure_storage` remains separate for auth/sensitive data — `StorageService` (Hive) is for non-sensitive cache/app data.
