# Plan: Add Internationalization (l10n)

## Goal
Set up Flutter's built-in localization system (`gen_l10n`) with English as the primary locale, wired into the app.

## Analysis
- `flutter_localizations` and `intl` are already dependencies in `pubspec.yaml`
- No `.arb` files, `l10n.yaml`, or `AppLocalizations` exist yet
- The architecture instructions place l10n under `lib/app/core/l10n/`
- The spec uses English (`lang: en`) — single locale for now
- `pubspec.yaml` needs `generate: true` under `flutter:` to enable code generation
- `MaterialApp.router` needs `localizationsDelegates` and `supportedLocales`

## Steps

- [x] Step 1: Create `l10n.yaml` config at project root
  - Sets ARB dir, template file, output localization file, and nullable-getter: false
- [x] Step 2: Create `lib/app/core/l10n/arb/app_en.arb` with initial strings
  - Includes strings from the spec: sign in labels, error messages, city list, offline banner, etc.
- [x] Step 3: Add `generate: true` to `pubspec.yaml` under `flutter:`
- [x] Step 4: Update `main.dart` to add `localizationsDelegates` and `supportedLocales`
- [x] Step 5: Run `flutter gen-l10n` to generate the localization files
- [x] Step 6: Verify with `flutter analyze` — passed with no issues

## Notes
- Removed deprecated `synthetic-package` option from `l10n.yaml` (no longer needed in current Flutter SDK)
