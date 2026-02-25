# Plan: Domain Layer Entities

## Goal
Create all domain entities for the auth and weather features based on OpenWeatherMap API data and the app spec.

## Analysis
- **User entity** (auth feature): email + name. Auth state is managed separately (not on the entity).
- **Weather feature entities**: Based on OpenWeatherMap current weather (`/data/2.5/weather`) and forecast (`/data/2.5/forecast`) API responses.
- Entities use `@JsonSerializable()` + `Equatable` per project conventions (pragmatic approach — serialization on domain entities for cache).
- `fromJson`/`toJson` on entities are for **local cache** serialization (Hive). API-to-entity mapping will happen in the datasource/repository layer.
- `build.yaml` already configured: `generate_for: "**/entities/**.dart"` with `any_map: true` and `explicit_to_json: true`.
- `WeatherCondition` enum: maps the API's `weather[0].main` field (Clear, Clouds, Rain, etc.) to a Dart enum.

## Steps

- [x] Step 1: Create `WeatherCondition` enum
  - File: `lib/app/domain/weather/enums/weather_condition.dart`
  - Values: clear, clouds, rain, drizzle, thunderstorm, snow, mist, smoke, haze, dust, fog, sand, ash, squall, tornado, unknown
  - Use `@JsonValue()` for API mapping

- [x] Step 2: Create `WeatherInfo` entity
  - File: `lib/app/domain/weather/entities/weather_info.dart`
  - Fields: id (int), condition (WeatherCondition), description (String), icon (String)
  - `@JsonKey(name: 'main')` for condition mapping

- [x] Step 3: Create `City` entity
  - File: `lib/app/domain/weather/entities/city.dart`
  - Fields: name (String), slug (String), latitude (double), longitude (double)

- [x] Step 4: Create `CityWeather` entity
  - File: `lib/app/domain/weather/entities/city_weather.dart`
  - Fields: citySlug (String), temperature (double), temperatureMin (double), temperatureMax (double), humidity (int), windSpeed (double), weather (WeatherInfo), dateTime (DateTime)

- [x] Step 5: Create `ForecastEntry` entity
  - File: `lib/app/domain/weather/entities/forecast_entry.dart`
  - Fields: dateTime (DateTime), temperature (double), humidity (int), windSpeed (double), weather (WeatherInfo)

- [x] Step 6: Create `User` entity
  - File: `lib/app/domain/auth/entities/user.dart`
  - Fields: email (String), name (String)

- [x] Step 7: Run `dart run build_runner build` to generate `.g.dart` files
- [x] Step 8: Run `flutter analyze` — must pass with no errors/warnings

## Notes
- Cities are pre-configured (10 Brazilian cities) but modeled as a full entity for cache support.
- CityWeather stores a `citySlug` to link back to the City without embedding the full City object. This avoids cache duplication.
- ForecastEntry is one 3-hour forecast slot. The forecast screen shows the next 12 entries.
- WeatherInfo maps directly to the `weather[0]` JSON object from the API, making datasource mapping straightforward.
