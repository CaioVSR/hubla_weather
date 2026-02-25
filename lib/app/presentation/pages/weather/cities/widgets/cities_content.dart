import 'package:flutter/material.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_error_state.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_shimmer_list.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/city_list.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/empty_search_state.dart';

/// Renders the appropriate content based on the current [CitiesState]:
/// shimmer loading, error, empty search, or the city list.
class CitiesContent extends StatelessWidget {
  const CitiesContent({required this.state, required this.cubit, super.key});

  final CitiesState state;
  final CitiesCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const CitiesShimmerList();
    }

    if (state.hasError && !state.hasCities) {
      return CitiesErrorState(onRetry: cubit.loadCities);
    }

    if (state.showEmptySearch) {
      return const EmptySearchState();
    }

    return CityList(
      cities: state.filteredCities,
      onRefresh: cubit.refreshCities,
    );
  }
}
