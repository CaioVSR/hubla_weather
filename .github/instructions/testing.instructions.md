---
applyTo: "test/**"
---

<!-- Version: 2.0.0 -->

# Testing (v2.0.0)

---

## File Organization

Mirror the source tree under `test/`. Shared test infrastructure lives in dedicated top-level folders:

```
test/
  app/                          # mirrors lib/app/
    data/
      feature/
        datasources/
          remote/
            feature_remote_datasource_test.dart
            requests/
              get_feature_request_test.dart
            responses/
              get_feature_response.dart          # raw JSON maps
          local/
            feature_local_datasource_test.dart
        feature_repository_test.dart
    domain/
      feature/
        entities/
          feature_entity_test.dart
        use_cases/
          get_feature_use_case_test.dart
    presentation/
      pages/
        feature/
          cubit/
            feature_cubit_test.dart
            feature_state_test.dart
          feature_page_test.dart
  factories/                    # object builders with sensible defaults
    entities/
      feature_entity_factory.dart
    cubits_factories.dart
    repositories_factories.dart
    datasources_factories.dart
    use_cases_factories.dart
  fixtures/                     # pre-built domain objects for common scenarios
    feature_fixtures.dart
  mocks/                        # mocktail Mock classes, one file per layer
    cubits_mocks.dart
    datasources_mocks.dart
    repositories_mocks.dart
    use_cases_mocks.dart
    services_mocks.dart
    general_mocks.dart
  helpers/                      # shared pump helpers, font mocks, etc.
    pump_app.dart
    google_fonts_mocks.dart
```

### Naming convention

`lib/app/.../foo.dart` → `test/app/.../foo_test.dart`

---

## Mocking (mocktail)

Use **`mocktail`** for all mocks. Group mocks by layer in dedicated files under `test/mocks/`.

### Repository / Datasource / Use-case / Service mocks

```dart
// test/mocks/repositories_mocks.dart
class MockFeatureRepository extends Mock implements FeatureRepository {}

// test/mocks/datasources_mocks.dart
class MockFeatureRemoteDatasource extends Mock implements FeatureRemoteDatasource {}
class MockFeatureLocalDatasource extends Mock implements FeatureLocalDatasource {}

// test/mocks/use_cases_mocks.dart
class MockGetFeatureUseCase extends Mock implements GetFeatureUseCase {}

// test/mocks/services_mocks.dart
class MockStorageService extends Mock implements StorageService {}
```

### Cubit mocks (with `bloc_presentation_test`)

When the cubit uses `BlocPresentationMixin`, use `MockPresentationCubit`:

```dart
// test/mocks/cubits_mocks.dart
class MockFeatureCubit extends MockPresentationCubit<FeatureState, FeaturePresentationEvent>
    implements FeatureCubit {}
```

When the cubit does **not** use presentation events, use `MockCubit`:

```dart
class MockSimpleCubit extends MockCubit<SimpleState> implements SimpleCubit {}
```

### Registering fallback values

Register fallback values in `setUpAll` for any type passed to `any()`:

```dart
setUpAll(() {
  registerFallbackValue(FakeGetFeatureRequest());
});
```

---

## Factories

Factories create **real** instances with sensible defaults. Every constructor parameter is optional and defaults to a safe value (or a mock for dependencies). This lets each test override **only** the fields it cares about.

### Entity factories (`test/factories/entities/`)

```dart
abstract class FeatureEntityFactory {
  static FeatureEntity create({
    String? id,
    String? name,
    bool? isActive,
  }) => FeatureEntity(
    id: id ?? '1',
    name: name ?? 'Default Name',
    isActive: isActive ?? true,
  );
}
```

### Repository factories (`test/factories/repositories_factories.dart`)

```dart
abstract class RepositoriesFactories {
  static FeatureRepository createFeatureRepository({
    FeatureRemoteDatasource? featureRemoteDatasource,
    FeatureLocalDatasource? featureLocalDatasource,
  }) => FeatureRepository(
    featureRemoteDatasource: featureRemoteDatasource ?? MockFeatureRemoteDatasource(),
    featureLocalDatasource: featureLocalDatasource ?? MockFeatureLocalDatasource(),
  );
}
```

### Use-case factories (`test/factories/use_cases_factories.dart`)

```dart
abstract class UseCaseFactories {
  static GetFeatureUseCase createGetFeatureUseCase({
    FeatureRepository? featureRepository,
  }) => GetFeatureUseCase(
    featureRepository: featureRepository ?? MockFeatureRepository(),
  );
}
```

### Cubit factories (`test/factories/cubits_factories.dart`)

```dart
abstract class CubitsFactories {
  static FeatureCubit createFeatureCubit({
    GetFeatureUseCase? getFeatureUseCase,
    UpdateFeatureUseCase? updateFeatureUseCase,
    // ... all constructor dependencies
  }) => FeatureCubit(
    getFeatureUseCase: getFeatureUseCase ?? MockGetFeatureUseCase(),
    updateFeatureUseCase: updateFeatureUseCase ?? MockUpdateFeatureUseCase(),
  );
}
```

---

## Fixtures

Fixtures are pre-built domain objects for **common scenarios** (e.g., an authenticated customer, an open store). They compose entity factories:

```dart
// test/fixtures/feature_fixtures.dart
abstract class FeatureFixtures {
  static FeatureEntity createActiveFeature() => FeatureEntityFactory.create(isActive: true);
  static FeatureEntity createInactiveFeature() => FeatureEntityFactory.create(isActive: false);
}
```

---

## Testing Each Layer

### 1. Entity Tests (`test/app/domain/.../entities/`)

Test serialization (`fromJson`/`toJson`), computed getters, equality, and `copyWith`:

```dart
void main() {
  group('FeatureEntity', () {
    test('should have correct initial values', () {
      final entity = FeatureEntity.initial();
      expect(entity.name, isEmpty);
      expect(entity.isActive, isFalse);
    });

    group('copyWith', () {
      test('should update name while preserving other fields', () {
        final entity = FeatureEntityFactory.create();
        final updated = entity.copyWith(name: 'New Name');
        expect(updated.name, 'New Name');
        expect(updated.isActive, entity.isActive);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = FeatureEntityFactory.create(name: 'X');
        final b = FeatureEntityFactory.create(name: 'X');
        expect(a, equals(b));
      });
    });

    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {'id': '1', 'name': 'Test', 'is_active': true};
        final entity = FeatureEntity.fromJson(json);
        expect(entity.id, '1');
        expect(entity.name, 'Test');
      });
    });
  });
}
```

### 2. Use-Case Tests (`test/app/domain/.../use_cases/`)

Mock the **repository**, inject it via the use-case factory, test success and error paths:

```dart
void main() {
  group('GetFeatureUseCase', () {
    test('should return feature when repository succeeds', () async {
      final feature = FeatureFixtures.createActiveFeature();
      final mockRepository = MockFeatureRepository();
      when(() => mockRepository.getFeature(id: '1'))
          .thenAnswer((_) async => Success(feature));
      final useCase = UseCaseFactories.createGetFeatureUseCase(
        featureRepository: mockRepository,
      );

      final result = await useCase(id: '1');

      expect(result.getSuccess(), feature);
      verify(() => mockRepository.getFeature(id: '1')).called(1);
    });

    test('should return error when repository fails', () async {
      final mockRepository = MockFeatureRepository();
      when(() => mockRepository.getFeature(id: '1'))
          .thenAnswer((_) async => Error(AppError(errorMessage: 'Not found')));
      final useCase = UseCaseFactories.createGetFeatureUseCase(
        featureRepository: mockRepository,
      );

      final result = await useCase(id: '1');

      expect(result.getError()?.errorMessage, 'Not found');
    });
  });
}
```

### 3. Repository Tests (`test/app/data/.../`)

Mock **datasources**, inject them via the repository factory:

```dart
void main() {
  group('FeatureRepository', () {
    group('getFeature', () {
      test('should return feature when remote datasource succeeds', () async {
        final feature = FeatureFixtures.createActiveFeature();
        final mockRemoteDatasource = MockFeatureRemoteDatasource();
        when(() => mockRemoteDatasource.getFeature(id: '1'))
            .thenAnswer((_) async => Success(feature));
        final repository = RepositoriesFactories.createFeatureRepository(
          featureRemoteDatasource: mockRemoteDatasource,
        );

        final result = await repository.getFeature(id: '1');

        expect(result.getSuccess(), feature);
      });

      test('should return error when remote datasource fails', () async {
        final mockRemoteDatasource = MockFeatureRemoteDatasource();
        when(() => mockRemoteDatasource.getFeature(id: '1'))
            .thenAnswer((_) async => Error(AppError(errorMessage: 'Error')));
        final repository = RepositoriesFactories.createFeatureRepository(
          featureRemoteDatasource: mockRemoteDatasource,
        );

        final result = await repository.getFeature(id: '1');

        expect(result.getError()?.errorMessage, 'Error');
      });
    });
  });
}
```

### 4. Remote Datasource Tests (`test/app/data/.../datasources/remote/`)

Mock the **HTTP client**, verify request execution and response deserialization. Test three paths: **success**, **HTTP error**, and **serialization error**.

```dart
void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetFeatureRequest());
  });

  group('FeatureRemoteDatasource', () {
    test('should return feature when request succeeds', () async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.request(any<GetFeatureRequest>()))
          .thenAnswer((_) async => Success(getFeatureSuccessResponse));
      final datasource = FeatureRemoteDatasource(client: mockHttpClient);

      final result = await datasource.getFeature(id: '1');

      expect(result.getSuccess(), isA<FeatureEntity>());
    });

    test('should return error when request fails', () async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.request(any<GetFeatureRequest>()))
          .thenAnswer((_) async => Error(AppError(errorMessage: 'Error')));
      final datasource = FeatureRemoteDatasource(client: mockHttpClient);

      final result = await datasource.getFeature(id: '1');

      expect(result.getError()?.errorMessage, 'Error');
    });

    test('should return serialization error when response is malformed', () async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.request(any<GetFeatureRequest>()))
          .thenAnswer((_) async => const Success({}));
      final datasource = FeatureRemoteDatasource(client: mockHttpClient);

      final result = await datasource.getFeature(id: '1');

      expect(result.getError(), isA<SerializationError>());
    });
  });
}
```

#### Response fixtures

Store raw JSON response maps in `test/app/data/.../datasources/remote/responses/`:

```dart
// get_feature_response.dart
const getFeatureSuccessResponse = {
  'data': {'id': '1', 'name': 'Test Feature', 'is_active': true},
};
```

### 5. Local Datasource Tests (`test/app/data/.../datasources/local/`)

Mock the **storage service**, verify reads/writes:

```dart
void main() {
  group('FeatureLocalDatasource', () {
    test('should return saved feature from storage', () {
      final feature = FeatureFixtures.createActiveFeature();
      final mockStorage = MockStorageService();
      when(() => mockStorage.readAndDecode<FeatureEntity>(any(), any()))
          .thenReturn(feature);
      final datasource = DatasourcesFactories.createFeatureLocalDatasource(
        storageService: mockStorage,
      );

      expect(datasource.getFeature(), feature);
    });

    test('should call storage service to save feature', () async {
      final feature = FeatureFixtures.createActiveFeature();
      final mockStorage = MockStorageService();
      when(() => mockStorage.writeJsonValue(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      final datasource = DatasourcesFactories.createFeatureLocalDatasource(
        storageService: mockStorage,
      );

      await datasource.saveFeature(feature);

      verify(() => mockStorage.writeJsonValue(
        key: FeatureLocalKey.feature.name,
        value: feature.toJson(),
      )).called(1);
    });
  });
}
```

### 6. Request Object Tests (`test/app/data/.../datasources/remote/requests/`)

Verify the HTTP method, path, headers, and body shape:

```dart
void main() {
  test('should have the correct path and HTTP method', () {
    final request = GetFeatureRequest(id: '1');

    expect(request.path, '/api/v1/features/1');
    expect(request.method, HttpMethod.get);
  });

  test('should include correct body for POST requests', () {
    final request = CreateFeatureRequest(name: 'New', isActive: true);

    expect(request.body, {'name': 'New', 'is_active': true});
  });
}
```

### 7. Cubit Tests — State (`test/app/presentation/.../cubit/`)

Use `blocTest` from `bloc_test` to verify state emissions. Use the cubit factory from `CubitsFactories`:

```dart
void main() {
  group('FeatureCubit', () {
    test('should have correct initial state', () {
      final cubit = CubitsFactories.createFeatureCubit();
      expect(cubit.state, FeatureState.initial());
    });

    blocTest<FeatureCubit, FeatureState>(
      'should emit state with updated name',
      build: CubitsFactories.createFeatureCubit,
      act: (cubit) => cubit.updateName('New Name'),
      expect: () => [FeatureState.initial().copyWith(name: 'New Name')],
    );

    blocTest<FeatureCubit, FeatureState>(
      'should emit loaded state when use case succeeds',
      build: () {
        final mockUseCase = MockGetFeatureUseCase();
        when(() => mockUseCase(id: '1'))
            .thenAnswer((_) async => Success(FeatureFixtures.createActiveFeature()));
        return CubitsFactories.createFeatureCubit(getFeatureUseCase: mockUseCase);
      },
      act: (cubit) => cubit.loadFeature('1'),
      expect: () => [
        FeatureState.initial().copyWith(feature: FeatureFixtures.createActiveFeature()),
      ],
    );

    blocTest<FeatureCubit, FeatureState>(
      'should toggle a boolean field',
      build: CubitsFactories.createFeatureCubit,
      act: (cubit) => cubit.toggleActive(),
      expect: () => [FeatureState.initial().copyWith(isActive: true)],
    );
  });
}
```

### 8. Cubit Tests — Presentation Events

Use `blocPresentationTest` from `bloc_presentation_test` to verify one-shot events (loading, errors, navigation triggers):

```dart
void main() {
  group('FeatureCubit presentation events', () {
    blocPresentationTest<FeatureCubit, FeatureState, FeaturePresentationEvent>(
      'should emit ShowLoading then HideLoading on success',
      build: () {
        final mockUseCase = MockGetFeatureUseCase();
        when(() => mockUseCase(id: '1'))
            .thenAnswer((_) async => Success(FeatureFixtures.createActiveFeature()));
        return CubitsFactories.createFeatureCubit(getFeatureUseCase: mockUseCase);
      },
      act: (cubit) => cubit.loadFeature('1'),
      expectPresentation: () => [
        ShowLoadingEvent(),
        HideLoadingEvent(),
      ],
    );

    blocPresentationTest<FeatureCubit, FeatureState, FeaturePresentationEvent>(
      'should emit ShowLoading, Error, then HideLoading on failure',
      build: () {
        final mockUseCase = MockGetFeatureUseCase();
        when(() => mockUseCase(id: '1'))
            .thenAnswer((_) async => Error(AppError(errorMessage: 'Oops')));
        return CubitsFactories.createFeatureCubit(getFeatureUseCase: mockUseCase);
      },
      act: (cubit) => cubit.loadFeature('1'),
      expectPresentation: () => [
        ShowLoadingEvent(),
        const ErrorEvent('Oops'),
        HideLoadingEvent(),
      ],
    );
  });
}
```

### 9. State Tests (`test/app/presentation/.../cubit/`)

Pure unit tests for `initial()`, `copyWith`, computed getters, and `Equatable` equality:

```dart
void main() {
  group('FeatureState', () {
    test('should have correct initial values', () {
      final state = FeatureState.initial();
      expect(state.name, isEmpty);
      expect(state.isActive, isFalse);
    });

    group('hasValidInput', () {
      test('should return false when name is empty', () {
        expect(FeatureState.initial().hasValidInput, isFalse);
      });

      test('should return true when name is non-empty', () {
        final state = FeatureState.initial().copyWith(name: 'Something');
        expect(state.hasValidInput, isTrue);
      });
    });

    group('copyWith', () {
      test('should update name while preserving other fields', () {
        final state = FeatureState.initial().copyWith(name: 'Updated');
        expect(state.name, 'Updated');
        expect(state.isActive, isFalse);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = FeatureState.initial().copyWith(name: 'X');
        final b = FeatureState.initial().copyWith(name: 'X');
        expect(a, equals(b));
      });

      test('should not be equal when a field differs', () {
        final a = FeatureState.initial().copyWith(name: 'X');
        final b = FeatureState.initial().copyWith(name: 'Y');
        expect(a, isNot(equals(b)));
      });
    });
  });
}
```

### 10. Page / Widget Tests (`test/app/presentation/.../`)

Use a **mock cubit** to control state and presentation events. Use the shared `pumpApp` helper.

#### Setup pattern

```dart
void main() {
  late MockFeatureCubit mockCubit;

  setUp(() {
    mockCubit = MockFeatureCubit();
    when(() => mockCubit.state).thenReturn(FeatureState.initial());
    whenListen(mockCubit, const Stream<FeatureState>.empty(), initialState: FeatureState.initial());
    whenListenPresentation(mockCubit);
  });

  // ...
}
```

#### Rendering tests

```dart
testWidgets('should render title and input fields', (tester) async {
  await pumpApp<FeatureCubit>(tester, const FeaturePage(), cubit: mockCubit);

  expect(find.text('Feature Title'), findsOneWidget);
  expect(find.byType(HublaTextInput), findsNWidgets(2));
});
```

#### Interaction tests

```dart
testWidgets('should call cubit method when button is tapped', (tester) async {
  final validState = FeatureState.initial().copyWith(name: 'Valid');
  when(() => mockCubit.state).thenReturn(validState);
  whenListen(mockCubit, const Stream<FeatureState>.empty(), initialState: validState);
  when(() => mockCubit.submit()).thenAnswer((_) async {});

  await pumpApp<FeatureCubit>(tester, const FeaturePage(), cubit: mockCubit);
  await tester.tap(find.byType(HublaPrimaryButton));
  await tester.pump();

  verify(() => mockCubit.submit()).called(1);
});
```

#### State-driven UI tests

```dart
testWidgets('should disable button when input is invalid', (tester) async {
  await pumpApp<FeatureCubit>(tester, const FeaturePage(), cubit: mockCubit);

  final button = tester.widget<HublaPrimaryButton>(find.byType(HublaPrimaryButton));
  expect(button.isEnabled, isFalse);
});
```

#### Presentation event tests (in widget context)

```dart
testWidgets('should show error dialog when ErrorEvent is emitted', (tester) async {
  // ignore: close_sinks
  final controller = whenListenPresentation(mockCubit);

  await pumpApp<FeatureCubit>(tester, const FeaturePage(), cubit: mockCubit);

  controller.add(const ErrorEvent('Something went wrong'));
  await tester.pumpAndSettle();

  expect(find.byType(HublaDialog), findsOneWidget);
  expect(find.text('Something went wrong'), findsOneWidget);
});
```

> **Tip:** If the presentation event triggers an overlay with a looping animation (e.g., loading), use `tester.pump()` instead of `pumpAndSettle()` to avoid timeouts.

---

## Pump Helper

A shared helper wraps the widget under test with the minimum app shell (theme, l10n, BlocProvider):

```dart
// test/helpers/pump_app.dart
Future<void> pumpApp<C extends StateStreamableSource<Object?>>(
  WidgetTester tester,
  Widget widget, {
  C? cubit,
}) async {
  var child = widget;
  if (cubit != null) {
    child = BlocProvider<C>.value(value: cubit, child: child);
  }
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}
```

---

## General Rules

1. **Every public method** in a cubit, use case, repository, or datasource must have at least one test.
2. **Test both success and error paths** — also test serialization errors for remote datasources.
3. **Descriptive test names**: `'should <expected behavior> when <condition>'`.
4. **Minimal `setUp` / `tearDown`** — prefer factory functions for test object creation. Keep `setUp` for mock initialization only.
5. **Factories default all dependencies to mocks** — tests override only the deps they need to control.
6. **Fixtures compose factories** — for common scenarios (e.g., "authenticated customer", "open store"), create a fixture that calls the factory with specific values.
7. **One mock file per layer** — don't scatter mock classes across test files.
8. **Register fallback values in `setUpAll`** — for any type used with `any()`.
9. **Prefer `find.byType` and `find.text`** over `find.byKey` unless keys are semantically meaningful.
10. **Use `const Stream.empty()`** when stubbing streams that shouldn't emit.
11. **Use tearoffs** (`FeatureCubit.new`) instead of lambdas (`() => FeatureCubit()`) when the linter requires it.
