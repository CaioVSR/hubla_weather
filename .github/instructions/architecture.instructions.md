---
applyTo: "lib/**"
---

<!-- Version: 1.1.0 -->

# Architecture (v1.1.0)

## Clean Architecture with Feature-Based Organization

Adopt a layered Clean Architecture with feature-based grouping. The canonical structure is:

```
lib/app/
├── core/              # Infrastructure: HTTP, DI, error handling, services, utils
├── data/              # Data layer: repositories, datasources, requests
├── domain/            # Entities, use cases, enums, errors
├── presentation/      # Pages, routing, widgets, cubits
└── main.dart          # Entry point
```

## Core Folder Structure

```
lib/app/core/
├── di/                       # GetIt service locator setup
│   └── service_locator.dart
├── env/                      # Environment configuration
│   └── env.dart              # --dart-define-from-file values
├── errors/                   # Base error types and Result
│   ├── app_error.dart
│   └── result.dart
├── extensions/               # Dart/Flutter extension methods
├── http/                     # Dio client wrapper, interceptors
│   ├── app_dio.dart
│   └── interceptors/
├── services/                 # Cross-cutting services
│   ├── connectivity_service.dart
│   └── storage_service.dart
├── theme/                    # AppTheme, colors, text styles
└── l10n/                     # Localization setup
```

## Feature Organization (domain + data + presentation)

Each feature should exist across 3 parallel directories:

```
lib/app/domain/<feature>/
    entities/         # Domain models
    enums/            # Feature enums
    errors/           # Domain-specific errors
    use_cases/        # Business logic

lib/app/data/<feature>/
    <feature>_repository.dart
    datasources/
        local/
            <feature>_local_datasource.dart
        remote/
            <feature>_remote_datasource.dart
            requests/
                <specific>_request.dart

lib/app/presentation/pages/<feature>/
    <sub_feature>/
        cubit/
            <feature>_cubit.dart
            <feature>_state.dart
            <feature>_presentation_event.dart
        <feature>_page.dart
        widgets/
```

> **Important:** Always check the actual project structure before creating files. If the project uses a different organization, follow its existing pattern.

## Dependency Direction

- **Presentation** depends on **Domain** (use cases, entities)
- **Data** depends on **Domain** (entities, errors)
- **Domain** depends on **nothing** — it is the innermost layer
- **Core** provides shared infrastructure used by all layers

## Result Type & Error Hierarchy Location

The `Result` type and base `AppError` live in `core/` since they are cross-cutting infrastructure used by all layers:

- `lib/app/core/errors/result.dart` — `Result<E, S>`, `Success`, `Error`
- `lib/app/core/errors/app_error.dart` — `AppError` base class

Feature-specific errors extend `AppError` and live in each feature's domain folder:

- `lib/app/domain/<feature>/errors/` — sealed `FeatureError extends AppError` + concrete variants
