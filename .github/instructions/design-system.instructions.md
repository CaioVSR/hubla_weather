---
applyTo: "lib/app/core/design_system/**"
---

<!-- Version: 1.0.0 -->

# Design System (v1.0.0)

## Overview

The Hubla Weather design system uses `ThemeExtension` to provide a type-safe, themeable token layer on top of Material 3. It follows the **Tokens → Themes → Orchestrator → Extensions** architecture.

## Architecture

```
lib/app/core/design_system/
├── tokens/           # Abstract contracts (ThemeExtension classes)
├── themes/           # Concrete values + orchestrator (HublaThemes)
├── animation/        # Static duration/curve constants
└── design_system.dart  # Barrel file (single import)
```

## Token Categories

| Token | Class | Access | Changes per theme? |
|-------|-------|--------|-------------------|
| Colors | `HublaColorTokens` | `context.hublaColors` | Yes (light/dark) |
| Typography | `HublaTypographyTokens` | `context.hublaTextStyles` | No |
| Spacing | `HublaSpacingTokens` | `context.hublaSpacing` | No |
| Shape | `HublaShapeTokens` | `context.hublaShape` | No |
| Elevation | `HublaElevationTokens` | `context.hublaElevation` | No |
| Animation | `HublaAnimationTokens` | `HublaAnimationTokens.medium2` | No (static) |

## How to Use

### Accessing tokens in widgets

Always use context extensions — never hardcode values:

```dart
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_elevation_extension.dart';

Widget build(BuildContext context) {
  final colors = context.hublaColors;
  final spacing = context.hublaSpacing;
  final textStyles = context.hublaTextStyles;
  final shape = context.hublaShape;
  final elevation = context.hublaElevation;

  return Container(
    padding: EdgeInsets.all(spacing.md),
    decoration: BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(shape.medium),
    ),
    child: Text(
      'Hello',
      style: textStyles.bodyMedium.copyWith(color: colors.onSurface),
    ),
  );
}
```

### Using animation tokens

Animation tokens are static constants — import the class directly:

```dart
import 'package:hubla_weather/app/core/design_system/animation/hubla_animation_tokens.dart';

AnimatedContainer(
  duration: HublaAnimationTokens.medium2,
  curve: HublaAnimationTokens.standard,
  // ...
)
```

### Applying color to text styles

Text styles from `hublaTextStyles` don't include color. Always apply color via `.copyWith()`:

```dart
Text(
  'Title',
  style: context.hublaTextStyles.titleLarge.copyWith(
    color: context.hublaColors.onSurface,
  ),
)
```

### Using the orchestrator in MaterialApp

```dart
MaterialApp(
  theme: HublaThemes.lightTheme,
  darkTheme: HublaThemes.darkTheme,
  // ...
)
```

## Color Palette

The Hubla palette is organized into groups:

- **Primary (Sun)**: `sunDark`, `sun`, `sunLight` — warm sunshine yellows
- **Secondary (Sky)**: `skyDark`, `sky`, `skyLight` — clear sky blues
- **Tertiary (Core)**: `coreDark`, `core`, `coreLight` — vibrant purples
- **Accent (Coral)**: `coralDark`, `coral`, `coralLight` — warm sunset oranges
- **Accent (Mint)**: `mintDark`, `mint`, `mintLight` — fresh greens
- **Accent (Lavender)**: `lavenderDark`, `lavender`, `lavenderLight` — soft purples
- **Neutrals**: `gray90` (darkest) through `gray10` (lightest), `white`
- **Semantic**: `success`, `warning`, `danger`, `info` — each with dark/light variants
- **Surface**: `surface`, `surfaceVariant`, `onSurface`, `onSurfaceVariant`
- **Gradient**: `backgroundGradient` — joyful multi-color gradient

## Rules

### Do

- Use context extensions to access tokens
- Apply color to text styles via `.copyWith(color: ...)`
- Use `HublaAnimationTokens` constants for all durations and curves
- Use shape tokens for border radii: `BorderRadius.circular(context.hublaShape.medium)`
- Use elevation tokens for Material elevation: `elevation: context.hublaElevation.level2`
- Import the barrel file (`design_system.dart`) when you need multiple token types

### Don't

- **Don't** hardcode colors, font sizes, spacing, border radii, or elevation values
- **Don't** use `Theme.of(context).colorScheme` directly — prefer `context.hublaColors`
- **Don't** create new `TextStyle` with hardcoded `fontFamily` — use `context.hublaTextStyles`
- **Don't** use `Colors.red`, `Colors.blue`, etc. — use semantic colors (`danger`, `info`)
- **Don't** make `HublaTypographyTheme` const — `GoogleFonts` returns non-const TextStyle

## Adding New Tokens

1. Add the field to the token class (e.g., `HublaColorTokens`)
2. Add the concrete value to ALL theme implementations (light + dark)
3. If adding a new token category, create a new `ThemeExtension`, theme, extension, and register in `HublaThemes`
4. Update the barrel file (`design_system.dart`)
