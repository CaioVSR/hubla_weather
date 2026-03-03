import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/result.dart';

void main() {
  group('Success', () {
    test('should return the success value via getSuccess()', () {
      const result = Success<String, int>(42);

      expect(result.getSuccess(), 42);
    });

    test('should return null for getError()', () {
      const result = Success<String, int>(42);

      expect(result.getError(), isNull);
    });

    test('should report isSuccess as true', () {
      const result = Success<String, int>(42);

      expect(result.isSuccess, isTrue);
    });

    test('should report isError as false', () {
      const result = Success<String, int>(42);

      expect(result.isError, isFalse);
    });

    test('should invoke onSuccess callback in when()', () {
      const result = Success<String, int>(42);

      final value = result.when(
        (error) => 'error: $error',
        (success) => 'success: $success',
      );

      expect(value, 'success: 42');
    });

    test('should be equal to another Success with the same value', () {
      const a = Success<String, int>(42);
      const b = Success<String, int>(42);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('should not be equal to another Success with a different value', () {
      const a = Success<String, int>(42);
      const b = Success<String, int>(99);

      expect(a, isNot(b));
    });

    test('should have a descriptive toString', () {
      const result = Success<String, int>(42);

      expect(result.toString(), 'Success(42)');
    });

    test('should support null as a success value', () {
      const result = Success<String, int?>(null);

      expect(result.getSuccess(), isNull);
      expect(result.isSuccess, isTrue);
    });
  });

  group('Error', () {
    test('should return the error value via getError()', () {
      const result = Error<String, int>('something went wrong');

      expect(result.getError(), 'something went wrong');
    });

    test('should return null for getSuccess()', () {
      const result = Error<String, int>('something went wrong');

      expect(result.getSuccess(), isNull);
    });

    test('should report isError as true', () {
      const result = Error<String, int>('fail');

      expect(result.isError, isTrue);
    });

    test('should report isSuccess as false', () {
      const result = Error<String, int>('fail');

      expect(result.isSuccess, isFalse);
    });

    test('should invoke onError callback in when()', () {
      const result = Error<String, int>('fail');

      final value = result.when(
        (error) => 'error: $error',
        (success) => 'success: $success',
      );

      expect(value, 'error: fail');
    });

    test('should be equal to another Error with the same value', () {
      const a = Error<String, int>('fail');
      const b = Error<String, int>('fail');

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('should not be equal to another Error with a different value', () {
      const a = Error<String, int>('fail');
      const b = Error<String, int>('other');

      expect(a, isNot(b));
    });

    test('should not be equal to a Success', () {
      const error = Error<int, int>(42);
      const success = Success<int, int>(42);

      expect(error, isNot(success));
    });

    test('should have a descriptive toString', () {
      const result = Error<String, int>('fail');

      expect(result.toString(), 'Error(fail)');
    });
  });

  group('Result type checks', () {
    test('Success should be a Result', () {
      const Result<String, int> result = Success(1);

      expect(result, isA<Result<String, int>>());
      expect(result, isA<Success<String, int>>());
    });

    test('Error should be a Result', () {
      const Result<String, int> result = Error('fail');

      expect(result, isA<Result<String, int>>());
      expect(result, isA<Error<String, int>>());
    });

    test('should support exhaustive pattern matching via sealed class', () {
      const Result<String, int> success = Success(10);
      const Result<String, int> error = Error('fail');

      // Exhaustive switch — if a branch were missing, this wouldn't compile.
      final successLabel = switch (success) {
        Success(value: final v) => 'val=$v',
        Error(error: final e) => 'err=$e',
      };

      final errorLabel = switch (error) {
        Success(value: final v) => 'val=$v',
        Error(error: final e) => 'err=$e',
      };

      expect(successLabel, 'val=10');
      expect(errorLabel, 'err=fail');
    });
  });
}
