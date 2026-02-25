import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';

void main() {
  group('AuthError', () {
    group('InvalidCredentialsError', () {
      test('should have correct default error message', () {
        const error = InvalidCredentialsError();

        expect(error.errorMessage, 'Invalid email or password');
      });

      test('should have correct label', () {
        const error = InvalidCredentialsError();

        expect(error.label, 'InvalidCredentialsError');
      });

      test('should allow custom error message', () {
        const error = InvalidCredentialsError(errorMessage: 'Custom message');

        expect(error.errorMessage, 'Custom message');
      });

      test('should be a subtype of AuthError', () {
        const error = InvalidCredentialsError();

        expect(error, isA<AuthError>());
      });

      test('should have null statusCode by default', () {
        const error = InvalidCredentialsError();

        expect(error.statusCode, isNull);
      });

      test('should format toString correctly', () {
        const error = InvalidCredentialsError();

        expect(error.toString(), 'InvalidCredentialsError(errorMessage: Invalid email or password, statusCode: null)');
      });
    });
  });
}
