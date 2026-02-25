# Plan: Add Design System

## Goal

Create a complete design system for Hubla Weather with a joyful color palette, following the **Tokens → Themes → Orchestrator → Extensions** pattern using `ThemeExtension`, aligned with Material 3 foundation principles.

## Analysis

### Architecture Pattern

The design system uses a layered architecture:

1. **Tokens** — Abstract `ThemeExtension` classes defining the contract (what colors, spacing, shapes exist)
2. **Themes** — Concrete implementations providing actual values (hex codes, dp values), context-dependent (light/dark)
3. **Orchestrator** — A single class that wires all theme extensions into `ThemeData` + maps tokens to Material's `ColorScheme`
4. **Extensions** — `BuildContext` extensions for ergonomic access (`context.hublaColors`, `context.hublaSpacing`, etc.)
5. **Barrel File** — Single import for consumers

This follows Material 3's three-tier token model:
- **Reference tokens** → our token classes (the full palette of available options)
- **System tokens** → our theme classes (decisions about which reference tokens to use per context)
- **Component tokens** → handled at the widget level using system tokens

### Token Categories (per M3 best practices)

| Category | M3 Foundation | Our Implementation |
|---|---|---|
| **Color** | Color roles, tonal palettes, dynamic color | `HublaColorTokens` — primary, accent, semantic, surface, gradient |
| **Typography** | 5 roles × 3 sizes = 15 styles + emphasized | `HublaTypographyTokens` — display, headline, title, body, label |
| **Spacing** | Layout grid, spacing scale | `HublaSpacingTokens` — 9-step scale (2–64dp) |
| **Shape** | 10-step corner radius scale | `HublaShapeTokens` — none through full (0–999dp) |
| **Elevation** | 6 levels (0–5), tonal + shadow | `HublaElevationTokens` — 6 levels with dp values |
| **Animation** | Easing + duration (physics system not yet available in Flutter) | `HublaAnimationTokens` — durations + curves (static constants) |

### Decisions

- Place everything in `lib/app/core/design_system/`
- Use **Rubik** font via `google_fonts` package — friendly rounded geometry, perfect for a weather app's joyful tone. No manual font bundling needed.
- **Joyful color palette** inspiration: sunshine yellows, sky blues, coral sunsets, fresh mint, soft lavender
- Map Hubla colors → Material `ColorScheme` in the orchestrator so native M3 widgets theme correctly
- Animation tokens are **static constants** (not `ThemeExtension`) since they don't change per theme
- NOT creating component widgets yet — those come with feature implementation
- Components will use tokens via context extensions, never hardcoded values

### Folder Structure

```
lib/app/core/design_system/
├── tokens/
│   ├── hubla_color_tokens.dart          # Abstract ThemeExtension
│   ├── hubla_spacing_tokens.dart        # ThemeExtension
│   ├── hubla_typography_tokens.dart     # ThemeExtension
│   ├── hubla_shape_tokens.dart          # ThemeExtension
│   └── hubla_elevation_tokens.dart      # ThemeExtension
├── themes/
│   ├── hubla_light_color_theme.dart     # Concrete light colors
│   ├── hubla_dark_color_theme.dart      # Concrete dark colors
│   ├── hubla_spacing_theme.dart         # Concrete spacing values
│   ├── hubla_typography_theme.dart      # Concrete text styles
│   ├── hubla_shape_theme.dart           # Concrete border radii
│   ├── hubla_elevation_theme.dart       # Concrete elevation values
│   └── hubla_themes.dart               # Orchestrator (ThemeData assembly)
├── animation/
│   └── hubla_animation_tokens.dart      # Static constants (durations + curves)
└── design_system.dart                   # Barrel file
```

---

## Reference Code Patterns

### Pattern: Token class (abstract ThemeExtension)

Tokens define the **contract** — what design properties exist. They are abstract so that different themes can provide different values.

```dart
import 'package:flutter/material.dart';

abstract class HublaColorTokens extends ThemeExtension<HublaColorTokens> {
  const HublaColorTokens({
    required this.primaryDark,
    required this.primary,
    required this.primaryLight,
    // ... all fields
  });

  final Color primaryDark;
  final Color primary;
  final Color primaryLight;
  // ... all fields

  @override
  ThemeExtension<HublaColorTokens> copyWith() => this;

  @override
  ThemeExtension<HublaColorTokens> lerp(
    covariant ThemeExtension<HublaColorTokens>? other,
    double t,
  ) => this;
}
```

### Pattern: Spacing token class (concrete ThemeExtension)

Non-context-dependent tokens (spacing doesn't change between light/dark) use a concrete class.

```dart
import 'package:flutter/material.dart';

class HublaSpacingTokens extends ThemeExtension<HublaSpacingTokens> {
  const HublaSpacingTokens({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  final double xxxs; // 2
  final double xxs;  // 4
  final double xs;   // 8
  final double sm;   // 12
  final double md;   // 16
  final double lg;   // 24
  final double xl;   // 32
  final double xxl;  // 48
  final double xxxl; // 64

  @override
  HublaSpacingTokens copyWith() => this;

  @override
  HublaSpacingTokens lerp(
    covariant ThemeExtension<HublaSpacingTokens>? other,
    double t,
  ) => this;
}
```

### Pattern: Theme class (concrete values extending token)

Theme classes provide actual values for a specific context (light/dark).

```dart
import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';

class HublaLightColorTheme extends HublaColorTokens {
  const HublaLightColorTheme()
    : super(
        primaryDark: const Color(0xFFXXXXXX),
        primary: const Color(0xFFXXXXXX),
        primaryLight: const Color(0xFFXXXXXX),
        // ... all values
      );
}
```

### Pattern: Spacing theme (concrete values)

```dart
import 'package:hubla_weather/app/core/design_system/tokens/hubla_spacing_tokens.dart';

class HublaSpacingTheme extends HublaSpacingTokens {
  const HublaSpacingTheme()
    : super(
        xxxs: 2,
        xxs: 4,
        xs: 8,
        sm: 12,
        md: 16,
        lg: 24,
        xl: 32,
        xxl: 48,
        xxxl: 64,
      );
}
```

### Pattern: Typography theme (concrete text styles)

Uses `google_fonts` package for Rubik font. Since `GoogleFonts.rubikTextTheme()` returns `TextStyle` objects at runtime (not `const`), the typography theme class cannot use `const` constructor — use a factory or static field instead.

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_typography_tokens.dart';

class HublaTypographyTheme extends HublaTypographyTokens {
  HublaTypographyTheme()
    : super(
        displayLarge: GoogleFonts.rubik(
          fontWeight: FontWeight.w700,
          fontSize: 56,
          height: 64 / 56,
        ),
        // ... all styles
        bodyMedium: GoogleFonts.rubik(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 20 / 14,
        ),
        // ...
      );
}
```

### Pattern: Orchestrator (ThemeData assembly + ColorScheme mapping)

Wires all theme extensions into `ThemeData` and maps tokens → Material `ColorScheme`.

```dart
import 'package:flutter/material.dart';

abstract class HublaThemes {
  static const _lightColors = HublaLightColorTheme();
  static const _darkColors = HublaDarkColorTheme();
  static final _typography = HublaTypographyTheme(); // non-const (GoogleFonts)
  static const _spacing = HublaSpacingTheme();
  static const _shape = HublaShapeTheme();
  static const _elevation = HublaElevationTheme();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _lightColors.primary,
      onPrimary: _lightColors.onPrimary,
      surface: _lightColors.surface,
      // ... map all relevant tokens
    ),
    scaffoldBackgroundColor: _lightColors.surface,
    extensions: [_lightColors, _typography, _spacing, _shape, _elevation],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _darkColors.primary,
      // ...
    ),
    extensions: [_darkColors, _typography, _spacing, _shape, _elevation],
  );
}
```

### Pattern: Context extensions

Ergonomic access to tokens from any widget's `BuildContext`.

```dart
import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';

extension HublaColorExtension on BuildContext {
  HublaColorTokens get hublaColors =>
      Theme.of(this).extension<HublaColorTokens>()!;
}
```

### Pattern: Component using tokens (for reference)

Components access tokens via context extensions — never hardcode colors/spacing/etc.

```dart
import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';

class ExampleCard extends StatelessWidget {
  const ExampleCard({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final textStyles = context.hublaTextStyles;
    final spacing = context.hublaSpacing;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyles.titleLarge.copyWith(color: colors.onSurface)),
          SizedBox(height: spacing.xs),
          Text(subtitle, style: textStyles.bodyMedium.copyWith(color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
```

---

## Steps

- [x] Step 0: Add `google_fonts` dependency
  - Modifies: `pubspec.yaml` — add `google_fonts: ^6.2.1`
  - Run `flutter pub get`

- [x] Step 1: Create color tokens (`hubla_color_tokens.dart`)
  - Creates: `lib/app/core/design_system/tokens/hubla_color_tokens.dart`
  - Abstract `ThemeExtension<HublaColorTokens>` with fields for: primary (sun), secondary (sky), tertiary (core), accent (coral, mint, lavender), neutrals (gray90–gray10, white), semantic (success, warning, danger, info), surface (surface, surfaceVariant, onSurface, onSurfaceVariant), gradient

- [x] Step 2: Create spacing tokens (`hubla_spacing_tokens.dart`)
  - Creates: `lib/app/core/design_system/tokens/hubla_spacing_tokens.dart`
  - Concrete `ThemeExtension<HublaSpacingTokens>` with 9-step scale

- [x] Step 3: Create typography tokens (`hubla_typography_tokens.dart`)
  - Creates: `lib/app/core/design_system/tokens/hubla_typography_tokens.dart`
  - Concrete `ThemeExtension<HublaTypographyTokens>` with M3-aligned roles: display (L/M/S), headline (L/M/S), title (L/M/S), body (L/M/S), label (L/M/S) = 15 styles

- [x] Step 4: Create shape tokens (`hubla_shape_tokens.dart`)
  - Creates: `lib/app/core/design_system/tokens/hubla_shape_tokens.dart`
  - Concrete `ThemeExtension<HublaShapeTokens>` with M3-aligned corner radius scale: none(0), extraSmall(4), small(8), medium(12), large(16), largeIncreased(20), extraLarge(28), extraLargeIncreased(32), extraExtraLarge(48), full(999)

- [x] Step 5: Create elevation tokens (`hubla_elevation_tokens.dart`)
  - Creates: `lib/app/core/design_system/tokens/hubla_elevation_tokens.dart`
  - Concrete `ThemeExtension<HublaElevationTokens>` with M3-aligned 6 levels: level0(0), level1(1), level2(3), level3(6), level4(8), level5(12) in dp

- [x] Step 6: Create animation tokens (`hubla_animation_tokens.dart`)
  - Creates: `lib/app/core/design_system/animation/hubla_animation_tokens.dart`
  - **Not** a ThemeExtension — static constants class
  - Durations: short1(50ms), short2(100ms), short3(150ms), short4(200ms), medium1(250ms), medium2(300ms), medium3(350ms), medium4(400ms), long1(450ms), long2(500ms), long3(550ms), long4(600ms), extraLong(800ms)
  - Curves: standard, standardAccelerate, standardDecelerate, emphasized, emphasizedAccelerate, emphasizedDecelerate (maps to Flutter's built-in curves)

- [x] Step 7: Create light color theme (`hubla_light_color_theme.dart`)
  - Creates: `lib/app/core/design_system/themes/hubla_light_color_theme.dart`
  - Concrete class extending `HublaColorTokens` with joyful light palette values
  - Depends on: Step 1

- [x] Step 8: Create dark color theme (`hubla_dark_color_theme.dart`)
  - Creates: `lib/app/core/design_system/themes/hubla_dark_color_theme.dart`
  - Concrete class extending `HublaColorTokens` with dark mode values
  - Depends on: Step 1

- [x] Step 9: Create spacing, shape, and elevation themes
  - Creates: `lib/app/core/design_system/themes/hubla_spacing_theme.dart`
  - Creates: `lib/app/core/design_system/themes/hubla_shape_theme.dart`
  - Creates: `lib/app/core/design_system/themes/hubla_elevation_theme.dart`
  - Depends on: Steps 2, 4, 5

- [x] Step 10: Create typography theme (`hubla_typography_theme.dart`)
  - Creates: `lib/app/core/design_system/themes/hubla_typography_theme.dart`
  - Uses `GoogleFonts.rubik()` for all roles — non-const (runtime TextStyle)
  - Depends on: Steps 0, 3

- [x] Step 11: Create themes orchestrator (`hubla_themes.dart`)
  - Creates: `lib/app/core/design_system/themes/hubla_themes.dart`
  - Wires all extensions into `ThemeData`
  - Maps Hubla color tokens → Material `ColorScheme` so native widgets theme correctly
  - Depends on: Steps 7–10

- [x] Step 12: Create context extensions
  - Creates: `lib/app/core/extensions/hubla_color_extension.dart`
  - Creates: `lib/app/core/extensions/hubla_spacing_extension.dart`
  - Creates: `lib/app/core/extensions/hubla_text_style_extension.dart`
  - Creates: `lib/app/core/extensions/hubla_shape_extension.dart`
  - Creates: `lib/app/core/extensions/hubla_elevation_extension.dart`
  - Depends on: Steps 1–5

- [x] Step 13: Create barrel file (`design_system.dart`)
  - Creates: `lib/app/core/design_system/design_system.dart`
  - Exports all tokens, themes, animation, and the orchestrator in a single import

- [x] Step 14: Create design system instruction file
  - Creates: `.github/instructions/design-system.instructions.md`
  - Documents: token categories, access patterns, do's/don'ts, component guidelines
  - Modifies: `.github/agents/hubly.agent.md` (add to instruction table)

- [x] Step 15: Update architecture instructions
  - Modifies: `.github/instructions/architecture.instructions.md` (add `design_system/` to core structure)

- [x] Step 16: Verify
  - Run `flutter analyze` — must pass with no errors/warnings
  - Run `flutter test` — all tests must pass
  - Check for compile errors

## Notes

- Joyful palette inspiration: sunshine, clear skies, warm sunsets, coral reefs, fresh mint, soft lavender
- Using Rubik font via `google_fonts` package — no need to bundle font files manually
- `GoogleFonts.rubik()` returns non-const `TextStyle`, so typography theme/orchestrator cannot be fully `const`
- Shape tokens follow M3's 10-step corner radius scale exactly
- Elevation tokens follow M3's 6-level system (0dp–12dp)
- Animation tokens use M3's easing+duration system (physics springs are NOT yet available for Flutter as of 2025)
- `ColorScheme` mapping in orchestrator ensures Material widgets (AppBar, FAB, Dialogs, etc.) theme correctly without manual overrides
- Components are NOT part of this task — they will be created alongside features
