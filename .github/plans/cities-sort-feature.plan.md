# Plan: Cities Sort Feature

## Goal
Add a sort feature next to the search bar on the Cities page, allowing users to sort by temperature, city name, wind speed, and humidity.

## Analysis
- Sort is a **presentation-only concern** — no domain/data changes needed. The list is sorted locally after filtering.
- The sort enum and direction live in the cubit layer alongside `CitiesState`.
- The `filteredCities` getter currently returns filtered results — we'll add a `sortedFilteredCities` getter that chains filter → sort.
- **Design**: A frosted glass sort button sits beside the search bar. Tapping it opens a **modal bottom sheet** with 4 sort options as interactive pills. Tapping the active option toggles direction (asc/desc). Each pill shows an icon, label, and direction arrow when active.
- The search bar + sort button form a **row** — the search bar takes `Expanded` space, sort button is a fixed-size circle.

## Steps

- [x] Step 1: Create `CitiesSortCriteria` enum
- [x] Step 2: Add `sortCriteria` and `isAscending` to `CitiesState`
- [x] Step 3: Add `updateSort(CitiesSortCriteria)` method to `CitiesCubit`
- [x] Step 4: Add l10n strings for sort UI
- [x] Step 5: Create `CitiesSortButton` widget
- [x] Step 6: Create `CitiesSortSheet` widget
- [x] Step 7: Update `CitiesPage` with Row layout
- [x] Step 8: Add cubit tests for sort functionality
- [x] Step 9: Add widget tests for sort button + bottom sheet
- [x] Step 10: Run flutter analyze + flutter test — all pass (334 tests, 0 issues)

## Notes
- Sort direction defaults to ascending for name, descending for temperature/wind/humidity (most useful defaults)
- Sort button shows a colored dot indicator when a non-default sort is active
- Bottom sheet styling matches the frosted glass aesthetic of the app
