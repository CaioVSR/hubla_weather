---
applyTo: "test/**"
---

<!-- Version: 1.0.0 -->

# Testing (v1.0.0)

## Mocking

Prefer `mocktail` (unless the project uses `mockito`):

```dart
class MockFeatureRepository extends Mock implements FeatureRepository {}
class MockGetSomethingUseCase extends Mock implements GetSomethingUseCase {}
class MockFeatureCubit extends MockCubit<FeatureState> implements FeatureCubit {}
```

## File Organization

- Mocks in `test/mocks/`
- Entity factories in `test/factories/`
- JSON fixtures in `test/fixtures/`
- Test file naming mirrors source: `lib/app/.../foo.dart` → `test/app/.../foo_test.dart`

## Cubit Tests (with `bloc_test`)

```dart
blocTest<FeatureCubit, FeatureState>(
  'should emit state with updated field',
  build: () => createFeatureCubit(),
  act: (cubit) => cubit.updateField('value'),
  expect: () => [FeatureState.initial().copyWith(field: 'value')],
);
```

## Presentation Event Tests (with `bloc_presentation_test`)

```dart
blocPresentationTest<FeatureCubit, FeatureState, FeaturePresentationEvent>(
  'should emit loading and error events on failure',
  build: () => createFeatureCubit(/* mocks */),
  act: (cubit) => cubit.doSomething(),
  expectPresentation: () => [
    ShowLoadingEvent(),
    const ErrorEvent('Something went wrong'),
    HideLoadingEvent(),
  ],
);
```

## Widget Tests

- Use a shared `pump` helper that wraps the widget with required providers (theme, localization, router, etc.)
- Use `whenListenPresentation()` to mock presentation event streams
- Use a mock router (e.g., `MockGoRouter`) to verify navigation calls
- Prefer `find.byType` and `find.text` over `find.byKey` unless keys are semantically meaningful

## General Rules

- Every public method in a cubit/use-case/repository should have at least one test
- Test both success and error paths
- Use descriptive test names: `'should <expected behavior> when <condition>'`
- Keep `setUp` / `tearDown` minimal — prefer factory functions for test object creation
