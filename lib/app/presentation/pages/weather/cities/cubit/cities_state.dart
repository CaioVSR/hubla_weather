import 'package:equatable/equatable.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_sort_criteria.dart';

/// State for the City List screen.
///
/// Holds the weather data for all cities, search query, sort settings,
/// loading, and connectivity status. Filtering and sorting are done via
/// the [filteredCities] getter.
class CitiesState extends Equatable {
  const CitiesState({
    required this.cities,
    required this.searchQuery,
    required this.sortCriteria,
    required this.isAscending,
    required this.isLoading,
    required this.isOffline,
    required this.hasError,
  });

  factory CitiesState.initial() => const CitiesState(
    cities: [],
    searchQuery: '',
    sortCriteria: CitiesSortCriteria.name,
    isAscending: true,
    isLoading: true,
    isOffline: false,
    hasError: false,
  );

  /// Weather data for all fetched cities.
  final List<CityWeather> cities;

  /// Current search query entered by the user.
  final String searchQuery;

  /// Active sort criterion for the city list.
  final CitiesSortCriteria sortCriteria;

  /// Whether the sort direction is ascending.
  final bool isAscending;

  /// Whether the initial data load is in progress.
  final bool isLoading;

  /// Whether the device is currently offline.
  final bool isOffline;

  /// Whether a full error occurred (no data available).
  final bool hasError;

  /// Whether any city data has been loaded.
  bool get hasCities => cities.isNotEmpty;

  /// Whether to show the "no results" empty state from search.
  bool get showEmptySearch => searchQuery.isNotEmpty && filteredCities.isEmpty && hasCities;

  /// Cities filtered by the current [searchQuery] and sorted by [sortCriteria].
  ///
  /// Matching is case-insensitive and accent-insensitive. Uses the city name
  /// resolved from [predefinedCities] via slug. Results are then sorted by the
  /// active criterion and direction.
  List<CityWeather> get filteredCities {
    List<CityWeather> result;

    if (searchQuery.isEmpty) {
      result = List.of(cities);
    } else {
      final normalizedQuery = _removeDiacritics(searchQuery.toLowerCase());

      result = cities.where((cityWeather) {
        final cityName = _cityNameFromSlug(cityWeather.citySlug);
        final normalizedName = _removeDiacritics(cityName.toLowerCase());
        return normalizedName.contains(normalizedQuery);
      }).toList();
    }

    result.sort((a, b) {
      final comparison = switch (sortCriteria) {
        CitiesSortCriteria.name => _removeDiacritics(
          _cityNameFromSlug(a.citySlug).toLowerCase(),
        ).compareTo(_removeDiacritics(_cityNameFromSlug(b.citySlug).toLowerCase())),
        CitiesSortCriteria.temperature => a.temperature.compareTo(b.temperature),
        CitiesSortCriteria.wind => a.windSpeed.compareTo(b.windSpeed),
        CitiesSortCriteria.humidity => a.humidity.compareTo(b.humidity),
      };
      return isAscending ? comparison : -comparison;
    });

    return result;
  }

  CitiesState copyWith({
    List<CityWeather>? cities,
    String? searchQuery,
    CitiesSortCriteria? sortCriteria,
    bool? isAscending,
    bool? isLoading,
    bool? isOffline,
    bool? hasError,
  }) => CitiesState(
    cities: cities ?? this.cities,
    searchQuery: searchQuery ?? this.searchQuery,
    sortCriteria: sortCriteria ?? this.sortCriteria,
    isAscending: isAscending ?? this.isAscending,
    isLoading: isLoading ?? this.isLoading,
    isOffline: isOffline ?? this.isOffline,
    hasError: hasError ?? this.hasError,
  );

  @override
  List<Object?> get props => [cities, searchQuery, sortCriteria, isAscending, isLoading, isOffline, hasError];
}

/// Resolves a city display name from its slug using [predefinedCities].
String _cityNameFromSlug(String slug) {
  for (final city in predefinedCities) {
    if (city.slug == slug) {
      return city.name;
    }
  }
  return slug;
}

/// Removes common diacritics for accent-insensitive search.
String _removeDiacritics(String input) => input
    .replaceAll(RegExp('[àáâãäå]'), 'a')
    .replaceAll(RegExp('[èéêë]'), 'e')
    .replaceAll(RegExp('[ìíîï]'), 'i')
    .replaceAll(RegExp('[òóôõö]'), 'o')
    .replaceAll(RegExp('[ùúûü]'), 'u')
    .replaceAll(RegExp('[ýÿ]'), 'y')
    .replaceAll(RegExp('[ñ]'), 'n')
    .replaceAll(RegExp('[ç]'), 'c');
