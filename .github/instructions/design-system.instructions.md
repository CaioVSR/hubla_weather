---
applyTo: "lib/app/core/design_system/**"
---

<!-- Version: 1.2.0 -->

# Design System (v1.2.0)

## Overview

The Hubla Weather design system uses `ThemeExtension` to provide a type-safe, themeable token layer on top of Material 3. It follows the **Tokens → Themes → Orchestrator → Extensions** architecture.

## Architecture

```
lib/app/core/design_system/
├── tokens/           # Abstract contracts (ThemeExtension classes)
├── themes/           # Concrete values + orchestrator (HublaThemes)
├── animation/        # Static duration/curve constants
├── widgets/          # Reusable design system widgets
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

## Widgets

Reusable widgets that consume design tokens live in `lib/app/core/design_system/widgets/`. They are exported via the barrel file.

### Available Widgets

| Widget | File | Description |
|--------|------|-------------|
| `HublaTextInput` | `widgets/hubla_text_input.dart` | Themed `TextFormField` with label, hint, prefix/suffix icons, obscure text, error text, keyboard type, controller |
| `HublaPrimaryButton` | `widgets/hubla_primary_button.dart` | Full-width sky-blue button with loading spinner, disabled state, optional prefix icon |
| `HublaLoading` | `widgets/hubla_loading.dart` | Full-screen loading overlay with weather-icon drop animation. Static `show`/`hide` API. |
| `HublaDialog` | `widgets/hubla_dialog.dart` | Themed dialog with icon badge, title, message, and one or two action buttons. Supports error, warning, info, success, and confirm variants. |

### `HublaTextInput`

```dart
HublaTextInput(
  label: l10n.email,
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  autocorrect: false,
  textInputAction: TextInputAction.next,
  prefixIcon: Icon(Icons.email_outlined, color: colors.gray50),
  errorText: 'Invalid email', // pass null to hide
)
```

**Parameters:**
- `label` (required) — field label text
- `hint` — placeholder text
- `prefixIcon` / `suffixIcon` — leading/trailing icon widgets
- `obscureText` — hide text (for passwords)
- `errorText` — inline error; pass `null` to hide
- `keyboardType` — e.g., `TextInputType.emailAddress`
- `onChanged` — value change callback
- `controller` — `TextEditingController`
- `enabled` — whether the field is interactive
- `autocorrect` — enable/disable autocorrect
- `textInputAction` — keyboard action button

### `HublaPrimaryButton`

```dart
HublaPrimaryButton(
  label: l10n.signIn,
  onPressed: () => cubit.signIn(),
  isLoading: state.isLoading,
  isEnabled: state.hasValidInput,
  prefixIcon: Icon(Icons.login, color: colors.white),
)
```

**Parameters:**
- `label` (required) — button text
- `onPressed` (required) — tap callback; pass `null` to disable
- `isLoading` — shows a spinner and disables the button
- `isEnabled` — explicitly enable/disable
- `prefixIcon` — optional leading icon

### `HublaLoading`

Show/hide a full-screen loading overlay with animated weather icons. Uses a named-route guard to prevent duplicate dialogs.

```dart
// Show
HublaLoading.show(context);

// Hide
HublaLoading.hide(context);
```

**Static methods:**
- `show(BuildContext context)` — pushes the loading overlay as a dialog; no-op if already showing
- `hide(BuildContext context)` — pops the overlay; no-op if not showing

### `HublaDialog`

Themed alert dialog with an icon badge, title, message, and action buttons. Five convenience constructors cover common scenarios.

```dart
// Single-button variants
HublaDialog.showError(context, title: l10n.error, message: 'Something went wrong');
HublaDialog.showWarning(context, title: l10n.warning, message: 'Check your input');
HublaDialog.showInfo(context, title: l10n.info, message: 'FYI');
HublaDialog.showSuccess(context, title: l10n.success, message: 'Done!');

// Two-button confirm
HublaDialog.showConfirm(
  context,
  title: 'Delete?',
  message: 'This cannot be undone.',
  primaryLabel: l10n.confirm,
  secondaryLabel: l10n.cancel,
  onPrimary: () => cubit.delete(),
);
```

**Static methods (single-button):**
- `showError` / `showWarning` / `showInfo` / `showSuccess`
  - `context` (required)
  - `title` (required) — dialog title
  - `message` (required) — body text
  - `buttonLabel` — override the default "OK" label
  - `onPressed` — callback when the button is tapped (pops by default)

**Static method (two-button):**
- `showConfirm`
  - `context` (required)
  - `title` (required) — dialog title
  - `message` (required) — body text
  - `primaryLabel` — label for the primary (right) button
  - `secondaryLabel` — label for the secondary (left) button
  - `onPrimary` — callback for the primary button
  - `onSecondary` — callback for the secondary button (pops by default)

### Adding New Widgets

1. Create the widget file in `lib/app/core/design_system/widgets/`
2. Use **only** design tokens (colors, spacing, shape, typography, animation) — no hardcoded values
3. Export it in the barrel file (`design_system.dart`)
4. **Update this instruction file** — add it to the "Available Widgets" table and document its parameters
5. Bump the version of this file

## Adding New Tokens

1. Add the field to the token class (e.g., `HublaColorTokens`)
2. Add the concrete value to ALL theme implementations (light + dark)
3. If adding a new token category, create a new `ThemeExtension`, theme, extension, and register in `HublaThemes`
4. Update the barrel file (`design_system.dart`)
