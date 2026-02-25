# Plan: Fix API Calls + Add Geocoding Integration

## Goal
Fix the "No host specified in URI" error caused by empty Env values, and integrate the OpenWeatherMap Geocoding API with cached results.

## Analysis
- **Root cause**: `String.fromEnvironment` returns empty string when app isn't run with `--dart-define-from-file=.env.dev`. This leaves `Env.openWeatherBaseUrl` and `Env.openWeatherApiKey` empty, making Dio requests fail with "No host specified in URI".
- **Geocoding flow**: User wants geocode city name → cache lat/lon → use for weather API. Keep hardcoded lat/lon as offline fallback.
- **Affected layers**: core (Env), data (datasources, repository, requests), tests
- **No domain layer changes needed** — City entity keeps lat/lon as fallback.

## Steps

- [ ] Step 1: Fix Env defaults — add default values for base URL and API key
  - Modifies: `lib/app/core/env/env.dart`
  - The base URL has a sensible default (`https://api.openweathermap.org`)
  - The API key gets a dev default so the app works out of the box

- [ ] Step 2: Create `GetGeocodingRequest` HTTP request
  - Creates: `lib/app/data/weather/datasources/remote/requests/get_geocoding_request.dart`
  - Endpoint: `/geo/1.0/direct?q={city},{country}&limit=1`
  - Not cacheable (we'll manage our own cache)

- [ ] Step 3: Add `geocodeCity` method to `WeatherRemoteDatasource`
  - Modifies: `lib/app/data/weather/datasources/remote/weather_remote_datasource.dart`
  - Returns `Result<AppError, ({double lat, double lon})>`

- [ ] Step 4: Add geocoding cache to `WeatherLocalDatasource`
  - Modifies: `lib/app/data/weather/datasources/local/weather_local_datasource.dart`
  - Methods: `saveGeocodingResult(citySlug, lat, lon)`, `getGeocodingResult(citySlug)`
  - Stored permanently (coordinates don't change)

- [ ] Step 5: Update `WeatherRepository` to geocode first
  - Modifies: `lib/app/data/weather/weather_repository.dart`
  - Flow: try geocoded coords → fallback to cached geocoding → fallback to hardcoded coords
  - Then fetch weather with resolved coords

- [ ] Step 6: Write/update tests
  - Create: `test/app/data/weather/datasources/remote/requests/get_geocoding_request_test.dart`
  - Modify: Remote datasource tests, repository tests
  - Verify geocoding + cache + fallback behavior

- [ ] Step 7: Run `flutter analyze` + `flutter test` — must pass

## Notes
- Geocoding API endpoint: `http://api.openweathermap.org/geo/1.0/direct`
- Same base URL works for both geocoding and weather endpoints
- The geocoding response is an array — we take the first result
