# Plan: Update Tests for Git Changes

## Goal
Create and update tests for all code changes currently in git — fix broken tests, add missing test coverage, and reorganize mock files to follow conventions.

## Analysis
- `widget_test.dart` fails because `HublaWeatherApp` now depends on `serviceLocator<GoRouter>()` but the test doesn't call `setupServiceLocator()`.
- Mock files use old naming (`mock_sign_in_cubit.dart`) — should be `cubits_mocks.dart` per testing conventions.
- `SignInPresentationEvent` sealed class has 4 events with Equatable — no dedicated tests.
- `HublaRoute` enum has `fromRouteName` method and value assertions — no tests.
- Existing sign-in cubit, state, and page tests are complete and passing.

## Steps

- [x] Step 1: Fix `widget_test.dart` — add `setupServiceLocator()` in setUp and `GetIt.I.reset()` in tearDown
  - Modifies: `test/widget_test.dart`
- [x] Step 2: Rename `test/mocks/mock_sign_in_cubit.dart` → `test/mocks/cubits_mocks.dart`
  - Update import in `sign_in_page_test.dart`
  - Modifies: mock file, page test
- [x] Step 3: Add `SignInPresentationEvent` tests
  - Creates: `test/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event_test.dart`
  - Tests: equality, props, each event variant, type checks
- [x] Step 4: Add `HublaRoute` tests
  - Creates: `test/app/presentation/routing/hubla_route_test.dart`
  - Tests: enum values, paths, screenNames, `fromRouteName` success, case-insensitivity, and failure
- [x] Step 5: Run all tests — 101 pass, 0 fail

## Notes
- Design system widget tests (HublaTextInput, HublaPrimaryButton, HublaDialog, HublaLoading) are lower priority — they're exercised indirectly via SignInPage widget tests.
