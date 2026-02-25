import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';

class SignInUseCase {
  SignInUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Result<AuthError, User>> call({
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.signIn(email: email, password: password);
    return result.when(
      Error.new,
      Success.new,
    );
  }
}
