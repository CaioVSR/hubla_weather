# Plan: Disable Sort + Better Asc/Desc UX

## Goal
Add a way to clear/disable the active sort and improve the asc/desc toggle UX in the sort bottom sheet.

## Analysis
- `clearSort()` already exists on `CitiesCubit` — resets to name ascending.
- l10n strings (`clearSort`, `ascending`, `descending`) are already added and generated.
- The sort sheet currently auto-dismisses on tap and only shows a tiny direction arrow on the active pill — poor discoverability.
- Key change: Redesign the sort sheet so each pill shows an explicit asc/desc direction label beneath it when active. Add a "Clear" text button in the header row. Remove auto-dismiss — let users pick criterion + toggle direction, then dismiss manually.
- The sort button should accept `onClearSort` callback and display a clear action (long-press or dedicated clear tap on active state).
- Alternative approach for sort button: keep it simple — just add `onClear` and show a small ✕ next to the dot badge when active sort is on. Tapping ✕ clears, tapping button opens sheet.

## Steps

- [x] Step 1: Add `clearSort()` to cubit + l10n strings (DONE)
- [x] Step 2: Regenerate l10n (DONE)
- [ ] Step 3: Redesign `CitiesSortSheet`
  - Add `onClearSort` callback parameter
  - Add "Clear" text button in header row (right-aligned)
  - Each pill: when active, show asc/desc segmented toggle below the pill (two mini buttons: "↑ ASC" / "↓ DESC")
  - Don't auto-dismiss — user dismisses by tapping outside or drag
  - `onSort` still called on criterion tap; need `onDirectionToggle` or reuse `onSort` (re-tap same toggles direction)
  - Modifies: `cities_sort_sheet.dart`
- [ ] Step 4: Update `CitiesSortButton`
  - Add `onClearSort` VoidCallback parameter
  - When `_hasActiveSort`, show a small ✕ clear icon button overlaying the badge area
  - Modifies: `cities_sort_button.dart`
- [ ] Step 5: Update `CitiesPage`
  - Pass `cubit.clearSort` to `CitiesSortButton.onClearSort`
  - Pass `cubit.clearSort` to `CitiesSortSheet.onClearSort`
  - Modifies: `cities_page.dart`
- [ ] Step 6: Update tests
  - Add `clearSort` blocTest in `cities_cubit_test.dart`
  - Update page tests: test clear button in sheet, test clear on sort button
  - Modifies: `cities_cubit_test.dart`, `cities_page_test.dart`
- [ ] Step 7: Verify
  - Run `flutter analyze` — must pass
  - Run `flutter test` — all tests must pass

## Notes
- Decision: Keep the sheet as a StatefulWidget internally so it can react to taps without dismissing.
- The sheet receives `onSort`, `onClearSort` callbacks. Tapping a criterion calls `onSort(criteria)`. Tapping the active criterion again calls `onSort(criteria)` which toggles direction in the cubit. The sheet rebuilds via `BlocBuilder` wrapping or by making it stateful with local state mirroring.
- Actually, since the sheet is shown via `showModalBottomSheet`, it won't rebuild when the cubit state changes. Better approach: make the sheet a `StatefulWidget` that tracks local state for immediate visual feedback, and calls the callbacks.
