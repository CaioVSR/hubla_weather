import 'dart:async';

import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_sort_criteria.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../factories/cubits_factories.dart';
import '../../../../../../factories/entities/city_weather_factory.dart';
import '../../../../../../mocks/services_mocks.dart';
import '../../../../../../mocks/use_cases_mocks.dart';

void main() {
  late MockGetAllCitiesWeatherUseCase mockUseCase;
  late MockConnectivityService mockConnectivityService;
  late StreamController<InternetStatus> connectivityController;

  setUp(() {
    mockUseCase = MockGetAllCitiesWeatherUseCase();
    mockConnectivityService = MockConnectivityService();
    connectivityController = StreamController<InternetStatus>.broadcast();

    when(() => mockConnectivityService.onStatusChanged).thenAnswer((_) => connectivityController.stream);
  });

  tearDown(() {
    connectivityController.close();
  });

  CitiesCubit buildCubit() => CubitsFactories.createCitiesCubit(
    getAllCitiesWeatherUseCase: mockUseCase,
    connectivityService: mockConnectivityService,
  );

  group('CitiesCubit', () {
    test('should have correct initial state', () {
      when(() => mockUseCase()).thenAnswer((_) async => const Success([]));

      final cubit = buildCubit();

      expect(cubit.state, CitiesState.initial());
      addTearDown(cubit.close);
    });

    group('loadCities', () {
      blocTest<CitiesCubit, CitiesState>(
        'should emit loaded state when use case succeeds',
        setUp: () {
          final cities = [
            CityWeatherFactory.create(citySlug: 'sao-paulo'),
            CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
          ];
          when(() => mockUseCase()).thenAnswer((_) async => Success(cities));
        },
        build: buildCubit,
        expect: () => [
          CitiesState.initial().copyWith(
            cities: [
              CityWeatherFactory.create(citySlug: 'sao-paulo'),
              CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
            ],
            isLoading: false,
            hasError: false,
          ),
        ],
      );

      blocTest<CitiesCubit, CitiesState>(
        'should emit error state when use case fails with no existing data',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Error(FetchWeatherError()));
        },
        build: buildCubit,
        expect: () => [
          CitiesState.initial().copyWith(isLoading: false, hasError: true),
        ],
      );

      blocPresentationTest<CitiesCubit, CitiesState, CitiesPresentationEvent>(
        'should emit RefreshErrorEvent when use case fails but data exists',
        setUp: () {
          final cities = [CityWeatherFactory.create()];
          var callCount = 0;
          when(() => mockUseCase()).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              return Success(cities);
            }
            return const Error(FetchWeatherError());
          });
        },
        build: buildCubit,
        act: (cubit) => cubit.loadCities(),
        expectPresentation: () => [
          const RefreshErrorEvent('Failed to fetch weather data'),
        ],
      );
    });

    group('refreshCities', () {
      blocTest<CitiesCubit, CitiesState>(
        'should update cities when refresh succeeds',
        setUp: () {
          final initialCities = [CityWeatherFactory.create(citySlug: 'sao-paulo')];
          final refreshedCities = [
            CityWeatherFactory.create(citySlug: 'sao-paulo'),
            CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
          ];
          var callCount = 0;
          when(() => mockUseCase()).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              return Success(initialCities);
            }
            return Success(refreshedCities);
          });
        },
        build: buildCubit,
        act: (cubit) => cubit.refreshCities(),
        skip: 1, // Skip the initial loadCities result
        expect: () => [
          CitiesState.initial().copyWith(
            cities: [
              CityWeatherFactory.create(citySlug: 'sao-paulo'),
              CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
            ],
            isLoading: false,
            hasError: false,
          ),
        ],
      );

      blocPresentationTest<CitiesCubit, CitiesState, CitiesPresentationEvent>(
        'should emit RefreshErrorEvent when refresh fails',
        setUp: () {
          final cities = [CityWeatherFactory.create()];
          var callCount = 0;
          when(() => mockUseCase()).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              return Success(cities);
            }
            return const Error(FetchWeatherError());
          });
        },
        build: buildCubit,
        act: (cubit) => cubit.refreshCities(),
        expectPresentation: () => [
          const RefreshErrorEvent('Failed to fetch weather data'),
        ],
      );
    });

    group('updateSearchQuery', () {
      blocTest<CitiesCubit, CitiesState>(
        'should emit state with updated search query',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) => cubit.updateSearchQuery('São'),
        skip: 1, // Skip initial load
        expect: () => [
          CitiesState.initial().copyWith(isLoading: false, searchQuery: 'São'),
        ],
      );
    });

    group('connectivity changes', () {
      blocTest<CitiesCubit, CitiesState>(
        'should emit isOffline true when connectivity is lost',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) => connectivityController.add(InternetStatus.disconnected),
        skip: 1, // Skip initial load
        expect: () => [
          CitiesState.initial().copyWith(isLoading: false, isOffline: true),
        ],
      );

      blocTest<CitiesCubit, CitiesState>(
        'should reload cities when connectivity is restored',
        setUp: () {
          final cities = [CityWeatherFactory.create()];
          when(() => mockUseCase()).thenAnswer((_) async => Success(cities));
        },
        build: buildCubit,
        act: (cubit) async {
          // Wait for initial load to complete
          await Future<void>.delayed(Duration.zero);
          connectivityController.add(InternetStatus.connected);
          // Wait for the reconnect load to complete
          await Future<void>.delayed(Duration.zero);
        },
        verify: (_) {
          // Initial loadCities() + reconnect loadCities() = 2 calls
          verify(() => mockUseCase()).called(2);
        },
      );
    });

    group('updateSort', () {
      blocTest<CitiesCubit, CitiesState>(
        'should set new criteria with its default ascending direction',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) => cubit.updateSort(CitiesSortCriteria.temperature),
        skip: 1, // Skip initial load
        expect: () => [
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.temperature,
            isAscending: false, // temperature defaults descending
          ),
        ],
      );

      blocTest<CitiesCubit, CitiesState>(
        'should toggle direction when same criteria is selected',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) {
          // Default is name ascending. Tap name again → descending.
          cubit.updateSort(CitiesSortCriteria.name);
        },
        skip: 1, // Skip initial load
        expect: () => [
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.name,
            isAscending: false,
          ),
        ],
      );

      blocTest<CitiesCubit, CitiesState>(
        'should toggle back to ascending on third tap of same criteria',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero); // Wait for initial load
          cubit.updateSort(CitiesSortCriteria.name); // asc → desc
          cubit.updateSort(CitiesSortCriteria.name); // desc → asc
        },
        skip: 1, // Skip the initial loadCities result
        expect: () => [
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.name,
            isAscending: false,
          ),
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.name,
            isAscending: true,
          ),
        ],
      );
    });

    group('clearSort', () {
      blocTest<CitiesCubit, CitiesState>(
        'should reset to name ascending when sort is active',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero); // Wait for initial load
          cubit.updateSort(CitiesSortCriteria.temperature); // Switch to temperature desc
          cubit.clearSort(); // Reset to name asc
        },
        skip: 1, // Skip the initial loadCities result
        expect: () => [
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.temperature,
            isAscending: false,
          ),
          CitiesState.initial().copyWith(
            isLoading: false,
            sortCriteria: CitiesSortCriteria.name,
            isAscending: true,
          ),
        ],
      );

      blocTest<CitiesCubit, CitiesState>(
        'should not emit new state when already at default sort',
        setUp: () {
          when(() => mockUseCase()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) async {
          await Future<void>.delayed(Duration.zero); // Wait for initial load
          cubit.clearSort(); // Already at default — emits same state (deduplicated by Cubit)
        },
        skip: 1, // Skip the initial loadCities result
        expect: () => <CitiesState>[],
      );
    });
  });
}
