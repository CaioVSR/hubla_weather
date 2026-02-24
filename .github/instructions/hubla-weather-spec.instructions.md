---
applyTo: "lib/**,test/**"
---

<!-- Version: 1.1.0 -->

# Hubla Weather — Design Specification (v1.1.0)

## 1. Overview

A mobile weather forecast app that lets users view current and upcoming weather conditions for multiple Brazilian cities. The app follows an **offline-first** approach, caching all weather data locally so it remains usable without an internet connection.

**API Provider:** [OpenWeatherMap](https://openweathermap.org/)

---

## 2. Screens & User Flows

### 2.1 Login

| Aspect | Detail |
|--------|--------|
| **Route** | `/login` (initial route when unauthenticated) |
| **Purpose** | Gate access to the app with email + password |

**UI Elements:**

- App logo / title
- Email text field (keyboard type: email, autocorrect off)
- Password text field (obscured, with visibility toggle)
- "Sign In" button (disabled until both fields are non-empty)
- Inline validation error messages

**Behavior:**

- Validate email format (must be a valid email pattern)
- Validate password is not empty
- On submit, check credentials against hardcoded values:
  - Email: `weather@hub.la`
  - Password: `weatherhubla`
- On success → navigate to City List and persist auth session
- On failure → show error message (e.g., "Invalid email or password")
- On success, store authentication state so the user remains logged in across app restarts

---

### 2.2 City List (Home)

| Aspect | Detail |
|--------|--------|
| **Route** | `/cities` (initial route when authenticated) |
| **Purpose** | Display current weather for 10 pre-selected Brazilian cities |

**Cities (pre-configured):**

| City | ID (slug) | Latitude | Longitude |
|------|-----------|----------|----------|
| São Paulo | `sao-paulo` | -23.5505 | -46.6333 |
| Rio de Janeiro | `rio-de-janeiro` | -22.9068 | -43.1729 |
| Brasília | `brasilia` | -15.7975 | -47.8919 |
| Salvador | `salvador` | -12.9714 | -38.5124 |
| Fortaleza | `fortaleza` | -3.7172 | -38.5433 |
| Belo Horizonte | `belo-horizonte` | -19.9191 | -43.9386 |
| Manaus | `manaus` | -3.1190 | -60.0217 |
| Curitiba | `curitiba` | -25.4284 | -49.2733 |
| Recife | `recife` | -8.0476 | -34.8770 |
| Porto Alegre | `porto-alegre` | -30.0346 | -51.2177 |

> **City ID:** The `:cityId` route parameter uses the slug format (lowercase, hyphenated). The slug is derived from the city name (remove accents, lowercase, replace spaces with hyphens). This is stable, human-readable, and works as both a route param and a Hive cache key.

**UI Elements:**

- Search bar (top, always visible)
- Scrollable list of city weather cards
- Each card displays:
  - **City name**
  - **Weather condition** (e.g., "Cloudy", "Sunny", "Rainy") with icon
  - **Max temperature** (°C)
  - **Min temperature** (°C)
  - **Humidity** (%)
  - **Wind speed** (m/s or km/h)
- Pull-to-refresh to re-sync data
- Offline indicator banner (shown when no connectivity)

**Search Behavior:**

- Filters the city list by name as the user types (real-time, debounced)
- Case-insensitive, accent-insensitive matching
- Works fully offline (filters cached data)
- Shows "No results" empty state when no cities match

**Data Loading:**

- On first launch: fetch weather for all 10 cities from the API and cache locally
- On subsequent launches: show cached data immediately, then sync in background
- Show loading skeleton/shimmer on first load

---

### 2.3 City Forecast (Detail)

| Aspect | Detail |
|--------|--------|
| **Route** | `/cities/:cityId/forecast` |
| **Purpose** | Show upcoming weather forecast for a selected city |

**Navigation:** Tap a city card on the City List screen.

**UI Elements:**

- App bar with city name and back button
- City summary header (current temperature, condition, icon)
- List/timeline of the **next 12 forecast records** (3-hour intervals from OpenWeatherMap's 5-day/3-hour API)
- Each forecast item displays:
  - **Date & time**
  - **Weather condition** with icon
  - **Temperature** (°C)
  - **Humidity** (%)
  - **Wind speed**

**Data Loading:**

- Show cached forecast immediately if available
- Sync forecast from API in background
- Show loading state on first load

---

## 3. API Integration

### 3.1 Endpoints

| Endpoint | Usage | Docs |
|----------|-------|------|
| `GET /data/2.5/weather` | Current weather for a city (by lat/lon) | [Current Weather](https://openweathermap.org/current) |
| `GET /data/2.5/forecast` | 5-day / 3-hour forecast for a city | [5-Day Forecast](https://openweathermap.org/forecast5) |

### 3.2 Common Parameters

| Parameter | Value |
|-----------|-------|
| `lat` | City latitude |
| `lon` | City longitude |
| `appid` | Your OpenWeatherMap API key |
| `units` | `metric` (Celsius, m/s) |
| `lang` | `en` |

### 3.3 API Key Management

- API key is injected at build time via `--dart-define-from-file=config/dev.json`
- Accessed in Dart via `String.fromEnvironment('OPEN_WEATHER_API_KEY')`
- The `config/` directory is gitignored — each developer creates their own
- See `data-layer.instructions.md` for the full setup pattern

### 3.4 Weather Condition Icons

OpenWeatherMap provides weather condition icons via URL:

```
https://openweathermap.org/img/wn/{icon_code}@2x.png
```

The `icon` field in the API response (e.g., `"01d"`, `"10n"`) maps to these URLs. Use `Image.network()` with the constructed URL, or map condition codes to local asset icons for offline support.

**Offline icon strategy:**
- Bundle a set of weather icon assets (e.g., Material Icons or a weather icon pack)
- Map the OpenWeatherMap `main` field (e.g., `"Clear"`, `"Clouds"`, `"Rain"`) to local icons
- Fallback to a generic weather icon for unknown conditions

---

## 4. Offline-First Strategy

| Scenario | Behavior |
|----------|----------|
| **First launch (online)** | Fetch all data from API → cache locally → display |
| **Subsequent launch (online)** | Display cached data immediately → sync from API in background → update UI |
| **Launch (offline)** | Display cached data → show offline indicator |
| **No cached data + offline** | Show empty state with "No data available. Connect to the internet to load weather data." |
| **Search (offline)** | Filter cached city list locally |

**Cache invalidation:** Data is refreshed on every successful API call. No time-based expiration — the latest successful response always overwrites the cache.

---

## 5. Error Handling

| Error | User-Facing Behavior |
|-------|---------------------|
| Invalid credentials | Inline error: "Invalid email or password" |
| Network error (online → offline during sync) | Show cached data + offline banner |
| API error (4xx/5xx) | Show cached data if available; show snackbar with error message |
| No cached data + API error | Full-screen error state with retry button |
| Serialization error | Log internally; treat as API error for the user |

---

## 6. Non-Functional Requirements

| Requirement | Detail |
|-------------|--------|
| **Platform** | Flutter (iOS + Android) |
| **Min SDK** | Dart ^3.11.0 |
| **Architecture** | Clean Architecture (domain / data / presentation) |
| **State Management** | Cubit (`flutter_bloc`) + `bloc_presentation` |
| **HTTP Client** | `dio` |
| **Local Storage** | `hive_ce` (weather cache) + `flutter_secure_storage` (auth) |
| **Connectivity** | `connectivity_plus` + `internet_connection_checker_plus` |
| **Routing** | `go_router` |
| **DI** | `get_it` |
| **Serialization** | `json_serializable` + `equatable` |
| **API Key** | `--dart-define-from-file` (no extra package) |
| **Testing** | `bloc_test`, `bloc_presentation_test`, `mocktail` |
| **Code Style** | Package imports, const constructors, equatable models |
