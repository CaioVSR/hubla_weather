import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Cubit that manages the City List screen.
///
/// Responsibilities:
/// - Fetch weather for all predefined cities on init
/// - React to connectivity changes (auto-refresh on reconnect, offline banner)
/// - Handle pull-to-refresh
/// - Update search query for local filtering (done in state getter)
class CitiesCubit extends Cubit<CitiesState> with BlocPresentationMixin<CitiesState, CitiesPresentationEvent> {
  CitiesCubit({
    required GetAllCitiesWeatherUseCase getAllCitiesWeatherUseCase,
    required ConnectivityService connectivityService,
  }) : _getAllCitiesWeatherUseCase = getAllCitiesWeatherUseCase,
       _connectivityService = connectivityService,
       super(CitiesState.initial()) {
    _connectivitySubscription = _connectivityService.onStatusChanged.listen(_onConnectivityChanged);
    loadCities();
  }

  final GetAllCitiesWeatherUseCase _getAllCitiesWeatherUseCase;
  final ConnectivityService _connectivityService;
  StreamSubscription<InternetStatus>? _connectivitySubscription;

  /// Fetches weather for all cities. Used for initial load.
  ///
  /// On success: updates cities and clears error/loading.
  /// On error with no existing data: shows full-screen error state.
  /// On error with existing data: keeps current data and emits [RefreshErrorEvent].
  Future<void> loadCities() async {
    emit(state.copyWith(isLoading: !state.hasCities, hasError: false));

    final result = await _getAllCitiesWeatherUseCase();

    result.when(
      (error) {
        if (state.hasCities) {
          emitPresentation(RefreshErrorEvent(error.errorMessage));
          emit(state.copyWith(isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false, hasError: true));
        }
      },
      (cities) {
        emit(state.copyWith(cities: cities, isLoading: false, hasError: false));
      },
    );
  }

  /// Refreshes weather data. Used for pull-to-refresh.
  ///
  /// Does not show shimmer skeleton — keeps existing data visible.
  /// On error: keeps current data and emits [RefreshErrorEvent].
  Future<void> refreshCities() async {
    final result = await _getAllCitiesWeatherUseCase();

    result.when(
      (error) => emitPresentation(RefreshErrorEvent(error.errorMessage)),
      (cities) => emit(state.copyWith(cities: cities, hasError: false)),
    );
  }

  /// Updates the search query for local city name filtering.
  void updateSearchQuery(String query) => emit(state.copyWith(searchQuery: query));

  void _onConnectivityChanged(InternetStatus status) {
    final isOffline = status == InternetStatus.disconnected;
    emit(state.copyWith(isOffline: isOffline));

    if (!isOffline && !state.isLoading) {
      loadCities();
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
