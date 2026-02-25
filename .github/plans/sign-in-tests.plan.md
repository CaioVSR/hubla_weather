# Plan: Sign-In Feature Tests

## Goal
Create comprehensive tests for the sign-in cubit, state, presentation events, and page widget.

## Analysis
- `SignInState` is a pure Dart class with `Equatable`, `copyWith`, `initial()`, and `hasValidInput` — straightforward unit tests.
- `SignInCubit` uses `BlocPresentationMixin` — needs both `blocTest` (state emissions) and `blocPresentationTest` (presentation events). No external dependencies to mock (constructor takes nothing).
- `SignInPresentationEvent` is a sealed class with 4 implementations using `Equatable` — equality tests.
- `SignInPage` is a `StatelessWidget` using `BlocBuilder`, `BlocPresentationListener`, design system widgets, and l10n — needs a pump helper with theme, l10n, and BlocProvider. Needs `MockSignInCubit` via `mocktail` + `bloc_test`.
- The page uses `HublaLoading.show/hide` and `HublaDialog.showError` — these push dialogs via Navigator, so widget tests can verify dialog presence.
- Google Fonts mocks are needed for any widget test (already have helpers).

## Steps

- [x] Step 1: Create mocks (`MockSignInCubit`) and a pump helper
  - Creates: `test/mocks/mock_sign_in_cubit.dart`, `test/helpers/pump_app.dart`
- [x] Step 2: Create `SignInState` unit tests
  - Creates: `test/app/presentation/pages/auth/sign_in/cubit/sign_in_state_test.dart`
- [x] Step 3: Create `SignInCubit` tests (state + presentation events)
  - Creates: `test/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit_test.dart`
- [x] Step 4: Create `SignInPage` widget tests
  - Creates: `test/app/presentation/pages/auth/sign_in/sign_in_page_test.dart`
- [x] Step 5: Verify — run all tests, ensure they pass

## Notes
- SignInCubit has no dependencies (no use cases/repos yet), so no mocks needed for cubit tests
- For widget tests, we need MockSignInCubit to control state and presentation events
- bloc_presentation_test provides `blocPresentationTest` and `whenListenPresentation`
