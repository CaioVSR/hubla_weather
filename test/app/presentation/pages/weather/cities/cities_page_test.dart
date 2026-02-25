import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_themes.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cities_page.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/city_weather_card.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/city_weather_card_skeleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../factories/entities/city_weather_factory.dart';
import '../../../../../helpers/google_fonts_mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../mocks/cubits_mocks.dart';

void main() {
  late MockCitiesCubit mockCubit;

  setUp(() {
    setUpGoogleFontsMocks();
    mockCubit = MockCitiesCubit();
    // Default to loaded state to avoid shimmer animation timeouts with pumpAndSettle
    final defaultState = CitiesState.initial().copyWith(
      cities: [CityWeatherFactory.create(citySlug: 'sao-paulo')],
      isLoading: false,
    );
    when(() => mockCubit.state).thenReturn(defaultState);
    whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: defaultState);
    whenListenPresentation(mockCubit);
  });

  tearDown(tearDownGoogleFontsMocks);

  group('CitiesPage', () {
    testWidgets('should render app bar with My Cities title', (tester) async {
      await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

      expect(find.text('My Cities'), findsOneWidget);
    });

    testWidgets('should render search bar', (tester) async {
      await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search cities'), findsOneWidget);
    });

    group('loading state', () {
      testWidgets('should render shimmer skeletons when loading', (tester) async {
        final loadingState = CitiesState.initial();
        when(() => mockCubit.state).thenReturn(loadingState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: loadingState);

        await tester.pumpWidget(
          MaterialApp(
            theme: HublaThemes.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<CitiesCubit>.value(
              value: mockCubit,
              child: const CitiesPage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CityWeatherCardSkeleton), findsWidgets);
      });
    });

    group('loaded state', () {
      testWidgets('should render city weather cards when data is loaded', (tester) async {
        final cities = [
          CityWeatherFactory.create(citySlug: 'sao-paulo'),
          CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
        ];
        final loadedState = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(loadedState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: loadedState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.byType(CityWeatherCard), findsNWidgets(2));
      });

      testWidgets('should display city name on card', (tester) async {
        final cities = [CityWeatherFactory.create(citySlug: 'sao-paulo')];
        final loadedState = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(loadedState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: loadedState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.text('São Paulo'), findsOneWidget);
      });
    });

    group('offline banner', () {
      testWidgets('should show offline banner when isOffline is true', (tester) async {
        final offlineState = CitiesState.initial().copyWith(isOffline: true, isLoading: false);
        when(() => mockCubit.state).thenReturn(offlineState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: offlineState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.text('You are offline'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      });

      testWidgets('should not show offline banner when online', (tester) async {
        final onlineState = CitiesState.initial().copyWith(isOffline: false, isLoading: false);
        when(() => mockCubit.state).thenReturn(onlineState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: onlineState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.text('You are offline'), findsNothing);
      });
    });

    group('error state', () {
      testWidgets('should show error state with retry when hasError and no data', (tester) async {
        final errorState = CitiesState.initial().copyWith(hasError: true, isLoading: false);
        when(() => mockCubit.state).thenReturn(errorState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: errorState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should call loadCities when retry button is tapped', (tester) async {
        final errorState = CitiesState.initial().copyWith(hasError: true, isLoading: false);
        when(() => mockCubit.state).thenReturn(errorState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: errorState);
        when(() => mockCubit.loadCities()).thenAnswer((_) async {});

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);
        await tester.tap(find.text('Retry'));
        await tester.pump();

        verify(() => mockCubit.loadCities()).called(1);
      });
    });

    group('empty search', () {
      testWidgets('should show no results state when search matches nothing', (tester) async {
        final emptySearchState = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create(citySlug: 'sao-paulo')],
          searchQuery: 'xyz',
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(emptySearchState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: emptySearchState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.text('No results'), findsOneWidget);
        expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('should call updateSearchQuery when search text changes', (tester) async {
        final loadedState = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create()],
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(loadedState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: loadedState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);
        await tester.enterText(find.byType(TextField), 'São');

        verify(() => mockCubit.updateSearchQuery('São')).called(1);
      });
    });

    group('stale data', () {
      testWidgets('should show stale data indicator when city weather is stale', (tester) async {
        final cities = [CityWeatherFactory.create(citySlug: 'sao-paulo', isStale: true)];
        final staleState = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(staleState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: staleState);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        expect(find.text('Cached'), findsOneWidget);
        expect(find.text('— Data may be outdated'), findsOneWidget);
      });
    });

    group('presentation events', () {
      testWidgets('should show snackbar when RefreshErrorEvent is emitted', (tester) async {
        final loadedState = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create()],
          isLoading: false,
        );
        when(() => mockCubit.state).thenReturn(loadedState);
        whenListen(mockCubit, const Stream<CitiesState>.empty(), initialState: loadedState);
        // ignore: close_sinks
        final presentationController = whenListenPresentation(mockCubit);

        await pumpApp<CitiesCubit>(tester, const CitiesPage(), cubit: mockCubit);

        presentationController.add(const RefreshErrorEvent('Network error'));
        await tester.pumpAndSettle();

        expect(find.text('Network error'), findsOneWidget);
      });
    });
  });
}
