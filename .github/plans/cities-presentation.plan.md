# Plan: Cities Presentation Layer

## Goal
Implement the presentation layer for the City List (Home) screen — cubit, state, presentation events, page, widgets, routing, and tests.

## Analysis

### Existing infrastructure
- `GetAllCitiesWeatherUseCase` returns `Result<WeatherError, List<CityWeather>>` — already wired in DI
- `CitiesRoute` exists as a placeholder scaffold — needs cubit provision
- `HublaRoute.cities` enum value exists (`/cities`)
- Design system tokens (colors, spacing, shape, typography) + widgets (HublaTextInput, HublaPrimaryButton, HublaLoading, HublaDialog)
- L10n strings for `searchCities`, `noResults`, `offlineBanner`, `noDataAvailable`, `retry`, `humidity`, `windSpeed`, `maxTemp`, `minTemp`, `temperatureCelsius`, `humidityPercent`, `windSpeedMs`
- `ConnectivityService.hasInternetConnection()` + `onStatusChanged` stream for reactive offline detection
- `predefinedCities` list for local search filtering

### Design decisions (confirmed with user)
1. **Loading**: Install `shimmer` package — skeleton card placeholders on first load
2. **Weather icons**: Map `WeatherCondition` enum to Material Icons (works offline)
3. **Connectivity**: Reactive stream — cubit subscribes to `ConnectivityService.onStatusChanged`, auto-refreshes on reconnect, auto-shows/hides offline banner
4. **Card style**: Medium card — city name + condition icon on top row, temp range / humidity / wind details on second row

### Key behaviors (from spec)
1. **Data loading**: Fetch all cities weather on init, show shimmer skeleton on first load
2. **Search**: Local filter by city name (case-insensitive, accent-insensitive)
3. **Pull-to-refresh**: Re-fetch all cities
4. **Offline indicator**: Banner when no connectivity (reactive)
5. **Stale indicator**: Visual hint when city data is from cache (isStale)
6. **Error states**: Full-screen error with retry when no data, snackbar for partial errors during refresh
7. **Navigation**: Tap card → push to forecast (future)

### Cubit design
- Dependencies: `GetAllCitiesWeatherUseCase`, `ConnectivityService`
- State fields: `cities` (List<CityWeather>), `searchQuery` (String), `isLoading` (bool), `isOffline` (bool), `hasError` (bool)
- Computed: `filteredCities` (search-filtered list), `hasCities`, `showEmptySearch`
- Methods: `loadCities()`, `refreshCities()`, `updateSearchQuery(String)`
- Connectivity: subscribe to stream in constructor, auto-refresh when coming back online
- Presentation events: RefreshErrorEvent (snackbar)
- close(): cancel stream subscription

## Steps

- [x] Step 1: Install `shimmer` package
- [x] Step 2: Add `WeatherCondition.icon` getter (Material Icons mapping)
- [x] Step 3: Create `CitiesState` with fields, copyWith, and filteredCities
- [x] Step 4: Create `CitiesPresentationEvent` sealed class
- [x] Step 5: Create `CitiesCubit` with load, refresh, search, reactive connectivity
- [x] Step 6: Create `CityWeatherCard` widget (medium card layout)
- [x] Step 7: Create `CityWeatherCardSkeleton` widget (shimmer placeholder)
- [x] Step 8: Create `CitiesPage` with search bar, list, pull-to-refresh, offline banner, error/empty states
- [x] Step 9: Wire `CitiesRoute` with cubit provision
- [x] Step 10: Add mock + factory for CitiesCubit
- [x] Step 11: Create cubit state tests
- [x] Step 12: Create cubit logic tests (blocTest + presentation events)
- [x] Step 13: Create page widget tests
- [x] Step 14: Verify — `flutter analyze` + `flutter test`

## Notes
- Cubits are NOT registered in service locator — instantiated in route's BlocProvider.create
- Search filtering happens in the state's computed getter (local, no API call)
- ConnectivityService injected via constructor, not service locator inside cubit
- Shimmer is used only for initial load skeleton — not for pull-to-refresh
