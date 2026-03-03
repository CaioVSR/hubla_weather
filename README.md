# Hubla Weather

A mobile weather forecast app built with Flutter that lets users view current and upcoming weather conditions for multiple Brazilian cities. The app follows an **offline-first** approach, caching all weather data locally so it remains usable without an internet connection.

**API Provider:** [OpenWeatherMap](https://openweathermap.org/)

---

## AI-First Development

This project is developed with an **AI-first** methodology — AI is not just a code-completion helper here, it is a core part of the engineering workflow. The codebase is structured so that an AI agent can understand, navigate, plan, and implement features with full architectural context. Here's how:

### Hubly — The Project's AI Agent

[`.github/agents/hubly.agent.md`](.github/agents/hubly.agent.md) defines **Hubly**, a specialized Flutter expert agent with deep knowledge of this project's architecture, conventions, and constraints. When activated, Hubly:

- Reads the project's `pubspec.yaml`, lint rules, and folder structure before making any code decision
- Follows Clean Architecture boundaries strictly
- Knows which patterns are established and adapts to them
- Asks clarifying questions instead of guessing on ambiguous design decisions
- Self-modifies its own instructions when the project evolves

### Instruction Files — Codified Architecture Knowledge

The `.github/instructions/` directory contains **9 versioned instruction files** that encode every layer of the project's architecture as machine-readable rules. These files are automatically injected by Copilot based on which files are being edited:

| File | Scope | What it defines |
|------|-------|-----------------|
| `architecture.instructions.md` | `lib/**` | Clean Architecture structure, folder layout, feature organization |
| `coding-conventions.instructions.md` | `lib/**`, `test/**` | Code style, naming, imports, class conventions |
| `domain-layer.instructions.md` | `lib/app/domain/**` | Entities, use cases, Result type, domain errors, enums |
| `data-layer.instructions.md` | `lib/app/data/**` | Repositories, datasources, HTTP request objects |
| `presentation-layer.instructions.md` | `lib/app/presentation/**` | Cubits, states, presentation events, pages, routing |
| `dependency-injection.instructions.md` | `lib/app/core/**` | GetIt registration patterns and rules |
| `testing.instructions.md` | `test/**` | Mocking strategy, cubit/widget/repo test patterns |
| `hubla-weather-spec.instructions.md` | `lib/**`, `test/**` | Full product design spec (screens, API, offline strategy) |
| `design-system.instructions.md` | `lib/app/core/design_system/**` | Design tokens, themes, component conventions |

This means the AI always has **architectural guardrails** — it can't accidentally break layer boundaries, use wrong imports, or introduce patterns that conflict with the project.

### Plan Files — Structured Task Execution

Every non-trivial feature is implemented through a **plan file** in `.github/plans/`. Before writing any code, the AI (or developer) creates a structured plan with:

- **Goal** — one-sentence summary
- **Analysis** — cross-dependency thinking, edge cases, conflict assessment
- **Steps** — ordered, independently verifiable implementation steps with dependency tracking
- **Progress** — a checklist updated in real-time as work progresses

This approach produces a traceable history of every architectural decision made during development. The project currently has **17 plan files** documenting features from domain entities to sign-in flows to caching strategies.

### MCP Integration — Live Documentation Access

The project connects to the **Context7 MCP server** (`.vscode/mcp.json`), giving the AI agent real-time access to up-to-date documentation for Dart, Flutter, and every third-party package used. This eliminates hallucinated APIs and outdated patterns.

### Why This Matters

Traditional development treats AI as a passive autocomplete tool. This project treats AI as an **active collaborator** that:

1. **Understands the architecture** through instruction files — not just syntax, but *why* things are structured the way they are
2. **Plans before coding** through plan files — reducing errors, half-implementations, and architectural drift
3. **Stays consistent** through codified conventions — every file it touches follows the same rules
4. **Learns the project** through the agent definition — it knows what to do, what NOT to do, and when to ask
5. **Accesses live docs** through MCP — always using current APIs, never guessing

---

## Architecture

The project follows **Clean Architecture** with three main layers:

```
lib/app/
├── core/               # Shared infrastructure
│   ├── design_system/  # Tokens, themes, components
│   ├── di/             # Dependency injection (GetIt)
│   ├── env/            # Environment config (compile-time)
│   ├── errors/         # AppError hierarchy
│   ├── extensions/     # Dart/Flutter extensions
│   ├── http/           # Dio-based HTTP client + interceptors
│   ├── l10n/           # Localization (ARB files)
│   └── services/       # Storage, logging, connectivity
├── domain/             # Business logic (pure Dart)
│   ├── auth/           # Auth entities, use cases, errors
│   └── weather/        # Weather entities, use cases, enums
├── data/               # Data access
│   ├── auth/           # Auth repository + datasources
│   └── weather/        # Weather repository + datasources + requests
└── presentation/       # UI
    ├── pages/          # Feature pages (login, cities, detail)
    └── routing/        # go_router configuration + route classes
```

### Key Technical Decisions

- **State management:** Cubit (flutter_bloc) + BlocPresentationMixin for one-shot events
- **Routing:** go_router with dedicated route classes per screen
- **HTTP:** Dio with 5 custom interceptors (auth, logging, retry, cache, connectivity)
- **Local storage:** Hive CE (general data/cache) + FlutterSecureStorage (auth tokens)
- **DI:** GetIt service locator — cubits are NOT registered in DI, they're created at the route level
- **Error handling:** `Result<AppError, T>` type — no thrown exceptions for expected flows
- **Serialization:** json_serializable with code generation

---

## Library Choices

Every dependency was chosen deliberately. Here's the rationale for each and what alternatives were considered.

### State Management — `flutter_bloc` (Cubit)

**Why:** flutter_bloc is the most mature, testable state management solution in the Flutter ecosystem. The Cubit variant provides a simpler API than full Bloc when the event audit trail isn't needed — which is the case for this app. It enforces a clear separation between UI and business logic and comes with first-class testing support (`bloc_test`).

### One-Shot Presentation Events — `bloc_presentation`

**Why:** Vanilla Cubit/Bloc conflates persistent state with transient events (snackbars, navigation, toasts). `bloc_presentation` adds a dedicated channel for one-shot events that are consumed exactly once, avoiding the anti-pattern of encoding navigation or error dialogs in state objects.

### Routing — `go_router`

**Why:** Official Flutter team package. Supports declarative routing, deep linking, redirect guards (used for auth flow), and nested navigation. Being an official package means long-term maintenance and compatibility with Flutter updates.

### Dependency Injection — `get_it`

**Why:** Simple, fast service locator with zero code generation. Supports lazy/eager/factory registration patterns. Doesn't pollute the widget tree like InheritedWidget-based alternatives, keeping DI decoupled from the UI layer — which aligns with Clean Architecture.

### HTTP Client — `dio`

**Why:** Feature-rich HTTP client with a powerful interceptor pipeline. This project needs 5 interceptors (auth, logging, retry, cache, connectivity) — Dio's `InterceptorsWrapper` makes this composable and testable. It also provides typed exception handling (`DioException`) with granular error categorization (timeout, connection error, bad response).

### Local Storage — `hive_ce`

**Why:** Hive Community Edition is the actively maintained fork of Hive after the original package was abandoned. It's a fast, lightweight NoSQL store with no native dependencies, making it ideal for caching weather data. Supports typed adapters via code generation (`hive_ce_generator`) and box-level isolation for separating different data domains.

### Secure Storage — `flutter_secure_storage`

**Why:** Uses platform-native secure storage (iOS Keychain, Android EncryptedSharedPreferences) for auth tokens. This is the right tool for credentials — general-purpose storage like Hive doesn't provide encryption at rest.

### Network Detection — `connectivity_plus` + `internet_connection_checker_plus`

**Why:** Two packages are needed because they solve different problems. `connectivity_plus` detects _network interface state_ (WiFi on/off), while `internet_connection_checker_plus` verifies _actual internet reachability_ by pinging DNS servers. For an offline-first app, knowing that WiFi is connected but the internet is unreachable is critical for correct UX.

### Serialization — `json_serializable`

**Why:** Official Dart team package. Generates `fromJson`/`toJson` code at compile time, avoiding runtime reflection (which Dart doesn't support in AOT mode anyway). Type-safe, widely adopted, zero runtime cost.

### Value Equality — `equatable`

**Why:** Eliminates manual `==` / `hashCode` boilerplate on entities and Cubit states. Essential for Cubit to detect state changes correctly via equality comparison.

### Typography — `google_fonts`

**Why:** Official Google package for runtime font loading. Provides access to the full Google Fonts catalog without bundling font files in the app binary.

### Logging — `logger`

**Why:** Pretty-printed, leveled logging with configurable output. Replaces `print()` (which is banned by lint rules) with structured, filterable log output.

### Loading Animations — `shimmer`

**Why:** Lightweight package for skeleton loading animations. Provides a polished loading UX with minimal code — a few lines wraps any widget in a shimmer effect.

### Dev: Mocking — `mocktail`

**Why:** Code-generation-free mocking library. Unlike `mockito`, it doesn't require `build_runner` to generate mock classes — you just extend `Mock`. This reduces the dev feedback loop and keeps test files self-contained.

### Dev: Linting — `dart_code_linter`

**Why:** Adds lint rules beyond the standard set, enforcing stricter code quality. Combined with a comprehensive `analysis_options.yaml` (266 lines of explicit rule configuration), this ensures consistent code style across human and AI contributions.

---

## Getting Started

### Prerequisites

- **Flutter SDK** `>=3.11.0`
- **Dart SDK** `>=3.11.0`
- An **OpenWeatherMap API key** ([get one here](https://openweathermap.org/appid))

### Environment Setup

The app uses `--dart-define-from-file` for environment configuration. Create a `.env.dev` file in the project root:

```env
ENVIRONMENT=dev
OPEN_WEATHER_BASE_URL=https://api.openweathermap.org
OPEN_WEATHER_API_KEY=your_api_key_here
```

For production, create `.env.prod` with `ENVIRONMENT=prod`.

### Install Dependencies

```bash
flutter pub get
```

### Code Generation

The project uses `json_serializable` and `hive_ce_generator`. Run the build runner after cloning or when models change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Localization

Localization files are in `lib/app/core/l10n/arb/`. Flutter generates the localization classes automatically when `generate: true` is set in `pubspec.yaml`. To regenerate manually:

```bash
flutter gen-l10n
```

### Run the App

```bash
# Development
flutter run --dart-define-from-file=.env.dev

# Production
flutter run --dart-define-from-file=.env.prod
```

Or use the pre-configured **VS Code launch configurations** (`Dev` / `Prod`) in `.vscode/launch.json`.

### Login Credentials

The app uses hardcoded credentials for authentication:

| Field | Value |
|-------|-------|
| Email | `weather@hub.la` |
| Password | `weatherhubla` |

---

## Testing

The project uses `flutter_test`, `bloc_test`, `mocktail`, and `bloc_presentation_test`.

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── factories/          # Object creation helpers for tests
├── helpers/            # Test utilities (pumpApp, font mocks)
├── mocks/              # Shared mock classes (mocktail)
└── app/
    ├── core/           # Service, HTTP, interceptor tests
    ├── data/           # Repository + datasource tests
    ├── domain/         # Use case tests
    └── presentation/   # Cubit + widget tests
```

---

## Static Analysis

```bash
flutter analyze
```

The project uses a comprehensive `analysis_options.yaml` with strict lint rules and `dart_code_linter` for additional checks.
