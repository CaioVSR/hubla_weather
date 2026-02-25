import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';

import '../mocks/services_mocks.dart';
import '../mocks/use_cases_mocks.dart';

abstract class CubitsFactories {
  static SignInCubit createSignInCubit({
    SignInUseCase? signInUseCase,
  }) => SignInCubit(
    signInUseCase: signInUseCase ?? MockSignInUseCase(),
  );

  static CitiesCubit createCitiesCubit({
    GetAllCitiesWeatherUseCase? getAllCitiesWeatherUseCase,
    ConnectivityService? connectivityService,
  }) => CitiesCubit(
    getAllCitiesWeatherUseCase: getAllCitiesWeatherUseCase ?? MockGetAllCitiesWeatherUseCase(),
    connectivityService: connectivityService ?? MockConnectivityService(),
  );
}
