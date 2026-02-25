---
applyTo: "lib/app/presentation/**"
---

<!-- Version: 1.1.0 -->

# Presentation Layer (v1.1.0)

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

This project uses `go_router` with a **route-per-class** pattern. Each screen gets its own route class that extends a shared base, and routes are composed in the app router via `Route().toRoute`.

### Folder Structure

```
lib/app/presentation/routing/
├── hubla_route.dart              # Enhanced enum: path + screenName for every route
├── hubla_base_route.dart         # Abstract base class all routes extend
├── hubla_route_transition.dart   # Page transition builders (MaterialPage, custom)
├── hubla_app_router.dart         # GoRouter configuration (createRouter)
└── routes/                       # One file per route
    ├── sign_in_route.dart
    ├── cities_route.dart
    └── forecast_route.dart
```

### Route Enum (`HublaRoute`)

Define **all** route paths and screen names in a single enhanced enum:

```dart
enum HublaRoute {
  login('/login', 'Login'),
  cities('/cities', 'Cities'),
  forecast('/cities/:cityId/forecast', 'Forecast'),
  ;

  const HublaRoute(this.path, this.screenName);

  final String path;
  final String screenName;

  static HublaRoute fromRouteName(String name) =>
      HublaRoute.values.firstWhere((route) => route.name.toLowerCase() == name.toLowerCase());
}
```

### Route Transition Helper (`HublaRouteTransition`)

Centralizes page transition animations so every route uses `pageBuilder` instead of `builder`:

```dart
enum RouteTransition { rightToLeft, bottomToTop }

abstract class HublaRouteTransition {
  static MaterialPage buildPageRightToLeftTransition<T>({
    required GoRouterState state,
    required Widget child,
  }) => MaterialPage(child: child, name: state.name, arguments: state.extra ?? state.pathParameters);

  static CustomTransitionPage buildPageBottomToTopTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) => CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    name: state.name,
    arguments: state.extra ?? state.pathParameters,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = animation.drive(Tween(begin: const Offset(0, 1), end: Offset.zero));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
```

### Base Route Class (`HublaBaseRoute`)

Every route extends this. It converts the route class into a `GoRoute` with transition support:

```dart
abstract class HublaBaseRoute extends HublaGoRoute {
  @override
  GoRoute get toRoute => GoRoute(
    path: path,
    name: name,
    redirect: redirect,
    pageBuilder: (context, state) => switch (transition) {
      RouteTransition.rightToLeft =>
        HublaRouteTransition.buildPageRightToLeftTransition(state: state, child: builder(context, state)),
      RouteTransition.bottomToTop =>
        HublaRouteTransition.buildPageBottomToTopTransition(context: context, state: state, child: builder(context, state)),
    },
    routes: routes,
  );
}

abstract class HublaGoRoute {
  String get name;
  String get path;
  GoRouterWidgetBuilder get builder;
  GoRouterRedirect? get redirect => null;
  GoRoute get toRoute;
  List<GoRoute> get routes => [];
  RouteTransition get transition => RouteTransition.rightToLeft;
}
```

### Individual Route Classes

Each route is its own class. This keeps route config (path, cubit provision, transitions) co-located:

**Simple route (no cubit):**

```dart
class CitiesRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.cities.name;

  @override
  String get path => HublaRoute.cities.path;

  @override
  GoRouterWidgetBuilder get builder => (context, state) => const CitiesPage();
}
```

**Route with cubit provision:**

```dart
class SignInRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.login.name;

  @override
  String get path => HublaRoute.login.path;

  @override
  GoRouterWidgetBuilder get builder =>
      (context, state) => BlocProvider(
        create: (_) => serviceLocator<SignInCubit>(),
        child: const SignInPage(),
      );
}
```

**Route with path parameters:**

```dart
class ForecastRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.forecast.name;

  @override
  String get path => HublaRoute.forecast.path;

  @override
  GoRouterWidgetBuilder get builder => (context, state) {
    final cityId = state.pathParameters['cityId']!;
    return BlocProvider(
      create: (_) => serviceLocator<ForecastCubit>()..loadForecast(cityId),
      child: const ForecastPage(),
    );
  };
}
```

**Route with extra data:**

```dart
class SomeRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.someRoute.name;

  @override
  String get path => HublaRoute.someRoute.path;

  @override
  GoRouterWidgetBuilder get builder => (context, state) {
    final data = state.extra as SomeType?;
    return BlocProvider(
      create: (_) => SomeCubit(data: data),
      child: const SomePage(),
    );
  };
}
```

**Route with custom transition:**

```dart
class ModalRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.modal.name;

  @override
  String get path => HublaRoute.modal.path;

  @override
  RouteTransition get transition => RouteTransition.bottomToTop;

  @override
  GoRouterWidgetBuilder get builder => (context, state) => const ModalPage();
}
```

### App Router Configuration (`hublaAppRouter`)

Compose all routes via `Route().toRoute`:

```dart
GoRouter createRouter() => GoRouter(
  initialLocation: HublaRoute.login.path,
  routes: [
    SignInRoute().toRoute,
    CitiesRoute().toRoute,
  ],
);
```

### Rules

- **One route class per screen** — each in its own file under `routing/routes/`
- **All paths live in `HublaRoute` enum** — never hardcode path strings outside the enum
- Provide cubits via `BlocProvider` in the route `builder` — **never** inside page widgets
- Use `context.go()` for full replacement navigation (e.g., login → cities)
- Use `context.push()` for stack-based navigation (e.g., cities → forecast)
- Use top-level `redirect` for auth guards
- Pass route parameters via `state.pathParameters` or `state.uri.queryParameters`
- Pass complex objects via `state.extra` with a type cast
- Register `GoRouter` in `GetIt` as a lazy singleton
- Default transition is `rightToLeft` (`MaterialPage`); override `transition` getter for others
