# Plan: Sign-In Feature

## Goal

Implement the full sign-in flow: credential validation against hardcoded values, session persistence via `flutter_secure_storage`, navigation to the cities screen on success, and auth guard redirect on the router.

## Analysis

### What already exists
- **Domain**: `User` entity with `email` + `name`, `fromJson`/`toJson`, test + factory
- **Presentation**: `SignInCubit` (placeholder `signIn()` with a 2-second delay), `SignInState` (email, password, obscurePassword), `SignInPresentationEvent` (Show/HideLoading, Error, Success), `SignInPage` (fully built UI), `SignInRoute` (provides cubit via BlocProvider)
- **Routing**: `HublaRoute` enum (login, cities, forecast), `HublaAppRouter` with only `SignInRoute`, `HublaBaseRoute`
- **Core**: `StorageService` (abstract) + `HiveStorageService` (Hive impl), `ConnectivityService`, `HttpClient` (Dio wrapper), `LoggerService`, `AppError` hierarchy (NoConnection, Http, Timeout, Serialization, Unknown), `Result<E, S>`
- **DI**: `service_locator.dart` registers core services + router, no feature registrations yet
- **Tests**: User entity test, cubit test (placeholder signIn), state/event tests, page widget tests with mocks

### What needs to be created
1. **Core**: `SecureStorageService` (abstract) + `FlutterSecureStorageService` (implementation)
2. **Domain**: `AuthError` sealed class + `InvalidCredentialsError`
3. **Data**: `AuthRepository` (validates hardcoded credentials + persists/reads/clears session), `AuthLocalDatasource` (wraps SecureStorageService for auth token/session)
4. **Presentation**: Update `SignInCubit` to use `AuthRepository`, emit success/error events, navigate on success
5. **Routing**: Add auth redirect guard to router, add cities route placeholder
6. **DI**: Register `SecureStorageService`, `AuthLocalDatasource`, `AuthRepository` in service locator
7. **Tests**: All new classes + update existing cubit test

### Cross-dependencies
- `SignInCubit` → `AuthRepository` (new dependency)
- `AuthRepository` → `AuthLocalDatasource` → `SecureStorageService`
- `SignInRoute` → needs to inject `AuthRepository` into cubit
- `HublaAppRouter` → needs `AuthRepository` to check auth state for redirect guard
- Existing cubit test will break when constructor signature changes

### Design decisions (confirmed with user)
- **SecureStorageService**: Dedicated abstract class in `core/services/` (like `StorageService` pattern)
- **Auth errors**: Sealed `AuthError extends AppError` with `InvalidCredentialsError`
- **Credential validation**: Lives in `AuthRepository` (data layer)

## Steps

- [x] Step 1: Create `SecureStorageService` (abstract) in `lib/app/core/services/`
  - Creates: `lib/app/core/services/secure_storage_service.dart`

- [x] Step 2: Create `FlutterSecureStorageService` (implementation) in `lib/app/core/services/`
  - Depends on: Step 1, `flutter_secure_storage` package
  - Creates: `lib/app/core/services/flutter_secure_storage_service.dart`

- [x] Step 3: Create `AuthError` sealed class + `InvalidCredentialsError` in `lib/app/domain/auth/errors/`
  - Depends on: `AppError` base class
  - Creates: `lib/app/domain/auth/errors/auth_error.dart`

- [x] Step 4: Create `AuthLocalDatasource` in `lib/app/data/auth/datasources/local/`
  - Depends on: Steps 1-2 (SecureStorageService)
  - Creates: `lib/app/data/auth/datasources/local/auth_local_datasource.dart`
  - Stores/reads/clears the authenticated User JSON in secure storage

- [x] Step 5: Create `AuthRepository` in `lib/app/data/auth/`
  - Depends on: Steps 3-4 (AuthError, AuthLocalDatasource)
  - Creates: `lib/app/data/auth/auth_repository.dart`
  - Methods: `signIn({email, password})` → validates against hardcoded creds, persists user, returns `Result<AuthError, User>`
  - Methods: `getSession()` → reads persisted user, returns `User?`
  - Methods: `signOut()` → clears persisted session

- [x] Step 6: Register new classes in DI service locator
  - Modifies: `lib/app/core/di/service_locator.dart`
  - Registers: `SecureStorageService`, `AuthLocalDatasource`, `AuthRepository`

- [x] Step 7: Update `SecureStorageService.init()` call in `main.dart`
  - No init needed — FlutterSecureStorage doesn't require initialization

- [x] Step 8: Update `SignInCubit` to use `AuthRepository`
  - Modifies: `lib/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart`
  - Injects `AuthRepository` via constructor
  - `signIn()` calls `authRepository.signIn()`, emits `SuccessEvent` or `ErrorEvent`

- [x] Step 9: Update `SignInPage` to navigate on `SuccessEvent`
  - Modifies: `lib/app/presentation/pages/auth/sign_in/sign_in_page.dart`
  - On `SuccessEvent` → `context.go(HublaRoute.cities.path)`

- [x] Step 10: Update `SignInRoute` to inject `AuthRepository` into cubit
  - Modifies: `lib/app/presentation/routing/routes/sign_in_route.dart`
  - Resolves `AuthRepository` from service locator

- [x] Step 11: Add auth redirect guard to `HublaAppRouter`
  - Modifies: `lib/app/presentation/routing/hubla_app_router.dart`
  - If authenticated → redirect `/login` to `/cities`
  - If not authenticated → redirect `/cities` (and sub-routes) to `/login`
  - Uses `AuthRepository.getSession()` to check auth state
  - Added placeholder `CitiesRoute` for `/cities`

- [x] Step 12: Create mock files for new classes
  - Creates: `test/mocks/repositories_mocks.dart` (MockAuthRepository)
  - Creates: `test/mocks/datasources_mocks.dart` (MockAuthLocalDatasource)
  - Modifies: `test/mocks/services_mocks.dart` (add MockSecureStorageService)

- [x] Step 13: Create test factories for new classes
  - Creates: `test/factories/repositories_factories.dart`
  - Creates: `test/factories/datasources_factories.dart`
  - Creates: `test/factories/cubits_factories.dart`

- [x] Step 14: Write `SecureStorageService` / `FlutterSecureStorageService` tests
  - Creates: `test/app/core/services/flutter_secure_storage_service_test.dart`

- [x] Step 15: Write `AuthError` tests
  - Creates: `test/app/domain/auth/errors/auth_error_test.dart`

- [x] Step 16: Write `AuthLocalDatasource` tests
  - Creates: `test/app/data/auth/datasources/local/auth_local_datasource_test.dart`

- [x] Step 17: Write `AuthRepository` tests
  - Creates: `test/app/data/auth/auth_repository_test.dart`

- [x] Step 18: Update `SignInCubit` tests (new constructor, real signIn logic)
  - Modifies: `test/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit_test.dart`

- [x] Step 19: Update `SignInPage` widget tests (navigation on success)
  - Modifies: `test/app/presentation/pages/auth/sign_in/sign_in_page_test.dart`
  - Added `pumpAppWithRouter` helper to `test/helpers/pump_app.dart`

- [x] Step 20: Verify — `flutter analyze` and `flutter test`
  - ✅ `flutter analyze`: No issues found
  - ✅ `flutter test`: 215 tests passed

## Notes

- The `data/` directory didn't exist — created with the auth feature (first data layer code in the project).
- `flutter_secure_storage` was in pubspec.yaml but unused — now wrapped by `SecureStorageService` / `FlutterSecureStorageService`.
- `AppError` was `sealed` which prevented cross-library extension. Changed to `abstract` to allow `AuthError extends AppError` in the domain layer (consistent with architecture instructions).
- `FlutterSecureStorage` doesn't require an `init()` call, so Step 7 was a no-op — no changes to `main.dart` needed.
- Added `pumpAppWithRouter` helper in `test/helpers/pump_app.dart` for widget tests that need `GoRouter` (e.g., navigation assertion tests).
- Updated `test/widget_test.dart` to mock `SecureStorageService` since the auth redirect guard calls `FlutterSecureStorage` which needs platform channels unavailable in tests.
- Added a placeholder `CitiesRoute` (just a Scaffold with "Cities" text) so the auth redirect has a valid destination.
- The cubit now takes `AuthRepository` via constructor injection (was previously parameterless) — updated route, tests, mocks, and factories accordingly.
