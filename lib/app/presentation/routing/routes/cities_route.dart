import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/di/service_locator.dart';
import 'package:hubla_weather/app/core/services/hubla_connectivity_service.dart';
import 'package:hubla_weather/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cities_page.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_base_route.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

/// Route for the City List screen.
///
/// Provides [CitiesCubit] via [BlocProvider] with its required dependencies
/// resolved from the service locator.
class CitiesRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.cities.name;

  @override
  String get path => HublaRoute.cities.path;

  @override
  GoRouterWidgetBuilder get builder =>
      (context, state) => BlocProvider(
        create: (_) => CitiesCubit(
          getAllCitiesWeatherUseCase: serviceLocator<GetAllCitiesWeatherUseCase>(),
          connectivityService: serviceLocator<HublaConnectivityService>(),
        ),
        child: const CitiesPage(),
      );
}
