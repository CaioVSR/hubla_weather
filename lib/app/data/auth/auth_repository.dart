import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';

/// Repository that handles authentication logic.
///
/// Validates credentials against hardcoded values and manages
/// the authenticated session via [AuthLocalDatasource].
class AuthRepository {
  AuthRepository({required AuthLocalDatasource authLocalDatasource}) : _authLocalDatasource = authLocalDatasource;

  final AuthLocalDatasource _authLocalDatasource;

  static const String _validEmail = 'weather@hub.la';
  static const String _validPassword = 'weatherhubla';

  /// Attempts to sign in with the given [email] and [password].
  ///
  /// Returns a [Success] with the authenticated [User] if credentials match,
  /// or an [Error] with [InvalidCredentialsError] otherwise.
  Future<Result<AuthError, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (email != _validEmail || password != _validPassword) {
      return const Error(InvalidCredentialsError());
    }

    const user = User(email: _validEmail, name: 'Weather User');
    await _authLocalDatasource.saveSession(user);
    return const Success(user);
  }

  /// Returns the currently persisted [User], or `null` if no session exists.
  Future<User?> getSession() => _authLocalDatasource.getSession();

  /// Clears the persisted authentication session.
  Future<void> signOut() => _authLocalDatasource.clearSession();
}
