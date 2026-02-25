# Plan: Auth Feature Routing (v2 — Route-per-class pattern)

## Goal
Redo the routing system to follow the route-per-class pattern from route_example: enhanced enum, base route class, transition helper, and individual route files.

## Analysis
- The previous implementation used a simple `AppRoutes` class + inline `GoRoute` in the router. It needs to be replaced with:
  - `HublaRoute` enhanced enum (replaces `AppRoutes`)
  - `HublaBaseRoute` / `HublaGoRoute` abstract classes
  - `HublaRouteTransition` transition helper
  - `SignInRoute` class (individual route file)
  - Updated `hubla_app_router.dart` composing routes via `Route().toRoute`
- Files to **delete**: `app_routes.dart` (replaced by `hubla_route.dart`)
- Files to **rewrite**: `app_router.dart` → `hubla_app_router.dart`
- Files **unchanged**: `sign_in_page.dart`, `service_locator.dart`, `main.dart`

## Steps

- [x] Step 1: Create `HublaRoute` enum at `lib/app/presentation/routing/hubla_route.dart`
  - Creates: hubla_route.dart
- [x] Step 2: Create `HublaRouteTransition` at `lib/app/presentation/routing/hubla_route_transition.dart`
  - Creates: hubla_route_transition.dart
- [x] Step 3: Create `HublaBaseRoute` + `HublaGoRoute` at `lib/app/presentation/routing/hubla_base_route.dart`
  - Depends on: Step 2
  - Creates: hubla_base_route.dart
- [x] Step 4: Create `SignInRoute` at `lib/app/presentation/routing/routes/sign_in_route.dart`
  - Depends on: Step 1, Step 3, existing SignInPage
  - Creates: sign_in_route.dart
- [x] Step 5: Rewrite router as `hubla_app_router.dart` using `Route().toRoute` pattern
  - Depends on: Step 4
  - Replaces: app_router.dart
- [x] Step 6: Delete old `app_routes.dart`
- [x] Step 7: Update `service_locator.dart` import to point to new router file
- [x] Step 8: Verify with `flutter analyze` — passed with no issues

## Notes
- The SignInPage stays as-is (empty placeholder). No cubit yet, so the route builder just returns the page directly.
- `main.dart` needs no changes since the `serviceLocator<GoRouter>()` call is unchanged.
- Added `route_example/**` to `analysis_options.yaml` exclude list since those files reference `teachy_flutter` package.
