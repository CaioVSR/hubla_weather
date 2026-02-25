import 'package:equatable/equatable.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';

/// State for the City List screen.
///
/// Holds the weather data for all cities, search query, loading, and
/// connectivity status. Filtering is done via the [filteredCities] getter.
class CitiesState extends Equatable {
  const CitiesState({
    required this.cities,
    required this.searchQuery,
    required this.isLoading,
    required this.isOffline,
    required this.hasError,
  });

  factory CitiesState.initial() => const CitiesState(
    cities: [],
    searchQuery: '',
    isLoading: true,
    isOffline: false,
    hasError: false,
  );

  /// Weather data for all fetched cities.
  final List<CityWeather> cities;

  /// Current search query entered by the user.
  final String searchQuery;

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

  /// Cities filtered by the current [searchQuery].
  ///
  /// Matching is case-insensitive and accent-insensitive. Uses the city name
  /// resolved from [predefinedCities] via slug.
  List<CityWeather> get filteredCities {
    if (searchQuery.isEmpty) {
      return cities;
    }

    final normalizedQuery = _removeDiacritics(searchQuery.toLowerCase());

    return cities.where((cityWeather) {
      final cityName = _cityNameFromSlug(cityWeather.citySlug);
      final normalizedName = _removeDiacritics(cityName.toLowerCase());
      return normalizedName.contains(normalizedQuery);
    }).toList();
  }

  CitiesState copyWith({
    List<CityWeather>? cities,
    String? searchQuery,
    bool? isLoading,
    bool? isOffline,
    bool? hasError,
  }) => CitiesState(
    cities: cities ?? this.cities,
    searchQuery: searchQuery ?? this.searchQuery,
    isLoading: isLoading ?? this.isLoading,
    isOffline: isOffline ?? this.isOffline,
    hasError: hasError ?? this.hasError,
  );

  @override
  List<Object?> get props => [cities, searchQuery, isLoading, isOffline, hasError];
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
