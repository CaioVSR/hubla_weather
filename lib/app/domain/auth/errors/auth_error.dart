import 'package:hubla_weather/app/core/errors/app_error.dart';

/// Base class for authentication-related errors.
sealed class AuthError extends AppError {
  const AuthError({required super.errorMessage});
}

/// The provided email or password does not match the expected credentials.
final class InvalidCredentialsError extends AuthError {
  const InvalidCredentialsError({super.errorMessage = 'Invalid email or password'});

  @override
  String get label => 'InvalidCredentialsError';
}
