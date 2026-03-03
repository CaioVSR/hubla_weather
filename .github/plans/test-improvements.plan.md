# Plan: Test Suite Improvements — High-Priority Gaps

## Goal

Add missing tests for core infrastructure (`Result`, `AppError`, `HublaHiveStorageService`) and rewrite the `HublaHttpClient` test to test the real `request()` method instead of replicating private logic.

## Analysis

### High-priority gaps identified:
1. **`HublaHttpClient.request()`** — current test replicates private `_mapDioException`. Need to test via a real instance with a mock adapter.
2. **`Result`** — foundational sealed type with zero tests.
3. **`AppError`** — base error hierarchy with 5 subtypes, zero tests.
4. **`HublaHiveStorageService`** — concrete Hive impl with box caching, zero tests.

### Approach for HublaHttpClient:
- Can't easily mock Dio because `HublaHttpClient` creates its own `Dio` internally.
- Best approach: Use Dio's `HttpClientAdapter` to mock the HTTP transport layer. Alternatively, we can use a custom `Dio` instance injected via a `@visibleForTesting` constructor.
- Simplest: Keep the existing `_mapDioException` tests (they validate the mapping spec) but also add a note that this is a specification test. The real integration would need Dio adapter mocking.
- Actually, the best approach is to refactor slightly: expose a `@visibleForTesting` constructor that accepts a `Dio` instance, then mock that.

### Approach for HublaHiveStorageService:
- Hive CE supports `Hive.init()` with a temp directory (not `initFlutter`).
- We can test using a temp directory in setUp/tearDown.

## Steps

- [x] Step 1: Create `test/app/core/errors/result_test.dart`
- [x] Step 2: Create `test/app/core/errors/app_error_test.dart`
- [x] Step 3: Refactor `HublaHttpClient` — added `@visibleForTesting HublaHttpClient.withDio(Dio dio)` constructor
- [x] Step 4: Rewrite `test/app/core/http/hubla_http_client_test.dart` — tests real `request()` via MockDio
- [x] Step 5: Create `test/app/core/services/hubla_hive_storage_service_test.dart`
- [x] Step 6: Run `flutter analyze` (0 issues) + `flutter test` (412 tests pass, +71 new)

## Notes

- Added `@visibleForTesting` constructor to `HublaHttpClient` to allow injecting a mock `Dio` without changing production behavior.
- HublaHiveStorageService test uses `Hive.init(tempDir)` with real Hive in a temp directory (no mocks needed).
- Fixed `avoid_redundant_argument_values` lint warnings with `// ignore:` comments where explicit null/default values improve test readability.
- Test count went from 341 → 412 (71 new tests).
