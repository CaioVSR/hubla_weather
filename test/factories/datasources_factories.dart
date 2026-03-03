import 'package:hubla_weather/app/core/http/hubla_http_client.dart';
import 'package:hubla_weather/app/core/services/hubla_secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_storage_service.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';

import '../mocks/general_mocks.dart';
import '../mocks/services_mocks.dart';

abstract class DatasourcesFactories {
  static AuthLocalDatasource createAuthLocalDatasource({
    HublaSecureStorageService? secureStorageService,
  }) => AuthLocalDatasource(
    secureStorageService: secureStorageService ?? MockSecureStorageService(),
  );

  static WeatherLocalDatasource createWeatherLocalDatasource({
    HublaStorageService? storageService,
  }) => WeatherLocalDatasource(
    storageService: storageService ?? MockStorageService(),
  );

  static WeatherRemoteDatasource createWeatherRemoteDatasource({
    HublaHttpClient? client,
  }) => WeatherRemoteDatasource(
    client: client ?? MockHttpClient(),
  );
}
