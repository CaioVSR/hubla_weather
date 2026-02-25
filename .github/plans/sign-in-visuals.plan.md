# Plan: Sign In Page Visuals + Design System Widgets

## Goal
Build a polished sign-in page using the Hubla design system, extracting reusable widgets (`HublaPrimaryButton`, `HublaTextInput`) into the design system for global use.

## Analysis

### Design Concept
The sign-in page will feature:
- **Background gradient** using `backgroundGradient` from color tokens — a warm, joyful feel
- **Centered card** with the app logo/title, email field, password field (with visibility toggle), and sign-in button
- **Soft elevation** on the card using `HublaElevationTokens.level2`
- **All tokens from the design system** — no hardcoded values

### Existing Design System
- **Tokens**: Colors (light/dark), Typography (Rubik font), Spacing (xxxs–xxxl), Shape (none–full), Elevation (0–5), Animation
- **Extensions**: `context.hublaColors`, `context.hublaTextStyles`, `context.hublaSpacing`, `context.hublaShape`, `context.hublaElevation`
- **No reusable widgets exist yet** — design_system has tokens/themes only, no `widgets/` folder

### Reusable Widgets to Create
1. **`HublaTextInput`** — styled `TextFormField` wrapping design tokens (colors, shape, typography). Supports label, hint, prefix/suffix icons, obscure text, error text, keyboard type, enabled state.
2. **`HublaPrimaryButton`** — full-width button with gradient or solid sky-blue background, rounded corners, label text style, loading state, disabled state, `onPressed` callback.

### Files Affected
- New: `lib/app/core/design_system/widgets/hubla_text_input.dart`
- New: `lib/app/core/design_system/widgets/hubla_primary_button.dart`
- Modified: `lib/app/core/design_system/design_system.dart` (barrel exports)
- Modified: `lib/app/presentation/pages/auth/sign_in/sign_in_page.dart` (full redesign)
- Modified: `.github/instructions/design-system.instructions.md` (document new widgets, bump version)

### L10n Strings
Already present: `signIn`, `email`, `password` — sufficient for this page. No new strings needed since the sign-in page is visual-only (no cubit/logic yet).

## Steps

- [x] Step 1: Create `HublaTextInput` widget
  - Creates: `lib/app/core/design_system/widgets/hubla_text_input.dart`
  - Styled text field using all design tokens
  - Supports: label, hint, prefixIcon, suffixIcon, obscureText, errorText, keyboardType, onChanged, enabled, controller
- [x] Step 2: Create `HublaPrimaryButton` widget
  - Creates: `lib/app/core/design_system/widgets/hubla_primary_button.dart`
  - Full-width sky-blue button with loading spinner, disabled state, rounded shape
- [x] Step 3: Update barrel file (`design_system.dart`) with widget exports
- [x] Step 4: Redesign `SignInPage` with gradient background, card, logo, inputs, button
  - Modifies: `lib/app/presentation/pages/auth/sign_in/sign_in_page.dart`
- [x] Step 5: Add new l10n strings (`welcomeBack`, `signInSubtitle`), regenerate
- [x] Step 6: Update `design-system.instructions.md` — add Widgets section, bump to v1.1.0
- [x] Step 7: Verify with `flutter analyze` — passed with no issues

## Notes
- The sign-in page is presentation-only at this point (no cubit wired). TextField state will be managed locally with controllers. Logic/validation will come with the auth feature implementation.
