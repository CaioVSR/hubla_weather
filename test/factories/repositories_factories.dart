import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';
import 'package:hubla_weather/app/data/weather/weather_repository.dart';

import '../mocks/datasources_mocks.dart';

abstract class RepositoriesFactories {
  static AuthRepository createAuthRepository({
    AuthLocalDatasource? authLocalDatasource,
  }) => AuthRepository(
    authLocalDatasource: authLocalDatasource ?? MockAuthLocalDatasource(),
  );

  static WeatherRepository createWeatherRepository({
    WeatherRemoteDatasource? weatherRemoteDatasource,
    WeatherLocalDatasource? weatherLocalDatasource,
  }) => WeatherRepository(
    weatherRemoteDatasource: weatherRemoteDatasource ?? MockWeatherRemoteDatasource(),
    weatherLocalDatasource: weatherLocalDatasource ?? MockWeatherLocalDatasource(),
  );
}
