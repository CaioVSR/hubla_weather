---
applyTo: "lib/app/presentation/**"
---

<!-- Version: 1.0.0 -->

# Presentation Layer (v1.0.0)

## State Management: Cubit + BlocPresentationMixin

> **Adaptability:** If the project uses a different state management solution (Riverpod, Provider, MobX, etc.), follow that instead.

```dart
class FeatureCubit extends Cubit<FeatureState>
    with BlocPresentationMixin<FeatureState, FeaturePresentationEvent> {
  FeatureCubit({
    required SomeUseCase someUseCase,
  }) : _someUseCase = someUseCase,
       super(FeatureState.initial());

  final SomeUseCase _someUseCase;

  Future<void> doSomething() async {
    emitPresentation(ShowLoadingEvent());
    final result = await _someUseCase(id: state.id);
    result.when(
      (error) => emitPresentation(ErrorEvent(error.errorMessage)),
      (data) {
        emit(state.copyWith(data: data));
        emitPresentation(SuccessEvent());
      },
    );
    emitPresentation(HideLoadingEvent());
  }

  void updateField(String value) => emit(state.copyWith(field: value));
}
```

**Rules:**
- Extend `Cubit<State>` with `BlocPresentationMixin<State, PresentationEvent>` (if `bloc_presentation` is available)
- Constructor injection of use cases and services
- Store dependencies as `_private final` fields
- Use `emit()` for state changes, `emitPresentation()` for one-shot side effects
- Loading via presentation events, NOT state booleans (when using `bloc_presentation`)
- Never access service locator (e.g., `GetIt`) inside cubits — all dependencies via constructor

## States

```dart
class FeatureState extends Equatable {
  const FeatureState({required this.data, required this.isLoading});

  factory FeatureState.initial() => const FeatureState(data: null, isLoading: false);

  final SomeEntity? data;
  final bool isLoading;

  bool get hasData => data != null;

  FeatureState copyWith({SomeEntity? data, bool? isLoading}) => FeatureState(
    data: data ?? this.data,
    isLoading: isLoading ?? this.isLoading,
  );

  @override
  List<Object?> get props => [data, isLoading];
}
```

**Rules:**
- Extend `Equatable` with `props`, factory `.initial()`, manual `copyWith()`
- NO sealed classes for state — use a single flat state object
- Use `copyWithoutXxx()` when you need to explicitly set a field to `null`

## Presentation Events

```dart
sealed class FeaturePresentationEvent {}

class ShowLoadingEvent extends Equatable implements FeaturePresentationEvent {
  @override
  List<Object?> get props => [];
}

class ErrorEvent extends Equatable implements FeaturePresentationEvent {
  const ErrorEvent(this.errorMessage);
  final String errorMessage;
  @override
  List<Object?> get props => [errorMessage];
}
```

**Rules:** `sealed class` base, each event `implements` it AND `extends Equatable`

## Pages

- Cubits are **NEVER** provided inside page widgets — always in the Route/Router configuration
- Use `BlocProvider` at the route level, not inside the page `build` method
- Keep pages as thin UI shells: delegate logic to cubits, delegate reusable UI to widget files

## Routing (go_router)

This project uses `go_router` for declarative, URL-based routing.

### Router Configuration

```dart
final goRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isLoggedIn = /* check auth state */;
    final isGoingToLogin = state.uri.path == '/login';

    if (!isLoggedIn && !isGoingToLogin) return '/login';
    if (isLoggedIn && isGoingToLogin) return '/cities';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<LoginCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/cities',
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<CitiesCubit>(),
        child: const CitiesPage(),
      ),
      routes: [
        GoRoute(
          path: ':cityId/forecast',
          builder: (context, state) {
            final cityId = state.pathParameters['cityId']!;
            return BlocProvider(
              create: (_) => serviceLocator<ForecastCubit>()..loadForecast(cityId),
              child: const ForecastPage(),
            );
          },
        ),
      ],
    ),
  ],
);
```

**Rules:**
- Provide cubits via `BlocProvider` in the route `builder` — never inside page widgets
- Use `context.go()` for full replacement navigation (e.g., login → home)
- Use `context.push()` for stack-based navigation (e.g., cities → forecast)
- Use top-level `redirect` for auth guards
- Extract path constants (e.g., `class AppRoutes { static const login = '/login'; ... }`)
- Pass route parameters via `state.pathParameters` or `state.uri.queryParameters`
- Register `GoRouter` in `GetIt` as a lazy singleton
