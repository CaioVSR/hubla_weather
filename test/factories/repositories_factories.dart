import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';

import '../mocks/datasources_mocks.dart';

abstract class RepositoriesFactories {
  static AuthRepository createAuthRepository({
    AuthLocalDatasource? authLocalDatasource,
  }) => AuthRepository(
    authLocalDatasource: authLocalDatasource ?? MockAuthLocalDatasource(),
  );
}
