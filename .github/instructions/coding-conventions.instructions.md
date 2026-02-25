---
applyTo: "lib/**,test/**"
---

<!-- Version: 1.3.0 -->

# Coding Conventions (v1.3.0)

## General

- **Imports**: Always use absolute package imports (`package:<app_name>/...`), never relative imports
- **Line width**: Follow the project's configured formatter width (check `analysis_options.yaml`). This project uses **140**.
- **Trailing commas**: Always use trailing commas for multi-line argument lists, parameter lists, collections, and widget trees. The formatter is set to `preserve`, so commas must be added manually.
- **Single quotes** for strings
- **Final locals** everywhere (`prefer_final_locals`, `prefer_final_in_for_each`)
- **Const constructors** when possible
- **No `this.`** prefix unless necessary for disambiguation
- **Expression function bodies** when the body is a single expression
- **Named parameters** with `required` keyword — avoid positional booleans
- **Enhanced enums** with constructors and fields
- **Sealed classes** for sum types (e.g., errors, presentation events, polymorphic models)
- **Dart records** `(Type1, Type2)` for multi-value returns
- **Naming**: `PascalCase` for classes/enums/typedefs, `camelCase` for members/functions/variables, `snake_case` for files and directories

## Classes

- All fields are `final`
- Constructors are `const` when possible, use `required` named parameters
- Sort constructors first
- Sort `child`/`children` properties last in widget constructors
- Use `super.key` (not `Key? key` in constructor)
- Annotate `@override`s

## Error Handling

- Never throw exceptions for expected error flows — use a `Result`/`Either` type
- Never use `print()` — use a proper logger or `debugPrint()`

## Dependencies

- When adding a new package, always use the **latest stable version** available on pub.dev
- Use Context7 MCP or check pub.dev to confirm the current latest version before adding a dependency
- Never pin to an old version unless there is a known incompatibility

## Extension Methods

- File naming: `<type>_extensions.dart` (e.g., `string_extensions.dart`, `context_extensions.dart`)
- Location: `lib/app/core/extensions/`
- One extension per file, or group closely related extensions on the same type
- Use descriptive extension names: `extension StringX on String`
- Prefer extension methods over global utility functions when the operation conceptually belongs to a type

## `late` Keyword

- Use `late` for private fields that are initialized before first access (e.g., in `initState`) — the linter enforces `use_late_for_private_fields_and_variables`
- Prefer nullable (`Type?`) over `late` for fields that may or may not be initialized
- Never use `late` on public fields — use nullable + null check instead

## Widgets

- **Never return widgets from functions/methods** — extract them into proper `StatelessWidget` or `StatefulWidget` classes instead
  - Widget-returning functions bypass the framework's element tree diffing, break `const` optimizations, and make code harder to test
  - Use widget classes even for small UI fragments (e.g., list item builders, form field groups)
  - The only exception is `builder` callbacks required by framework widgets (e.g., `ListView.builder`, `BlocBuilder`)

## Generated Files

- Never edit generated files (`*.g.dart`, `*.freezed.dart`, `*.gen.dart`)
