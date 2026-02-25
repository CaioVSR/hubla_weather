import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';

void main() {
  group('SignInState', () {
    test('should have correct initial values', () {
      final state = SignInState.initial();

      expect(state.email, isEmpty);
      expect(state.password, isEmpty);
      expect(state.obscurePassword, isTrue);
    });

    group('hasValidInput', () {
      test('should return false when email is empty', () {
        final state = SignInState.initial().copyWith(password: '123456');

        expect(state.hasValidInput, isFalse);
      });

      test('should return false when password is empty', () {
        final state = SignInState.initial().copyWith(email: 'user@test.com');

        expect(state.hasValidInput, isFalse);
      });

      test('should return false when both email and password are empty', () {
        final state = SignInState.initial();

        expect(state.hasValidInput, isFalse);
      });

      test('should return true when both email and password are non-empty', () {
        final state = SignInState.initial().copyWith(
          email: 'user@test.com',
          password: '123456',
        );

        expect(state.hasValidInput, isTrue);
      });
    });

    group('copyWith', () {
      test('should update email while preserving other fields', () {
        final state = SignInState.initial().copyWith(email: 'new@test.com');

        expect(state.email, 'new@test.com');
        expect(state.password, isEmpty);
        expect(state.obscurePassword, isTrue);
      });

      test('should update password while preserving other fields', () {
        final state = SignInState.initial().copyWith(password: 'secret');

        expect(state.email, isEmpty);
        expect(state.password, 'secret');
        expect(state.obscurePassword, isTrue);
      });

      test('should update obscurePassword while preserving other fields', () {
        final state = SignInState.initial().copyWith(obscurePassword: false);

        expect(state.email, isEmpty);
        expect(state.password, isEmpty);
        expect(state.obscurePassword, isFalse);
      });

      test('should update multiple fields at once', () {
        final state = SignInState.initial().copyWith(
          email: 'user@test.com',
          password: 'secret',
          obscurePassword: false,
        );

        expect(state.email, 'user@test.com');
        expect(state.password, 'secret');
        expect(state.obscurePassword, isFalse);
      });

      test('should return a new instance with same values when no arguments are passed', () {
        final original = SignInState.initial().copyWith(
          email: 'user@test.com',
          password: 'secret',
        );
        final copied = original.copyWith();

        expect(copied, equals(original));
        expect(identical(copied, original), isFalse);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final stateA = SignInState.initial().copyWith(email: 'a@b.com', password: '123');
        final stateB = SignInState.initial().copyWith(email: 'a@b.com', password: '123');

        expect(stateA, equals(stateB));
      });

      test('should not be equal when email differs', () {
        final stateA = SignInState.initial().copyWith(email: 'a@b.com');
        final stateB = SignInState.initial().copyWith(email: 'x@y.com');

        expect(stateA, isNot(equals(stateB)));
      });

      test('should not be equal when password differs', () {
        final stateA = SignInState.initial().copyWith(password: 'abc');
        final stateB = SignInState.initial().copyWith(password: 'xyz');

        expect(stateA, isNot(equals(stateB)));
      });

      test('should not be equal when obscurePassword differs', () {
        final stateA = SignInState.initial();
        final stateB = SignInState.initial().copyWith(obscurePassword: false);

        expect(stateA, isNot(equals(stateB)));
      });
    });

    test('props should contain all fields', () {
      const state = SignInState(email: 'e', password: 'p', obscurePassword: true);

      expect(state.props, ['e', 'p', true]);
    });
  });
}
