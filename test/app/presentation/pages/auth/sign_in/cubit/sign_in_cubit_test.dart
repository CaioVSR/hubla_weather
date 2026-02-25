import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';

void main() {
  group('SignInCubit', () {
    late SignInCubit cubit;

    setUp(() {
      cubit = SignInCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('should have correct initial state', () {
      expect(cubit.state, SignInState.initial());
    });

    group('updateEmail', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with updated email',
        build: SignInCubit.new,
        act: (cubit) => cubit.updateEmail('user@test.com'),
        expect: () => [SignInState.initial().copyWith(email: 'user@test.com')],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with empty email when cleared',
        build: SignInCubit.new,
        seed: () => SignInState.initial().copyWith(email: 'old@test.com'),
        act: (cubit) => cubit.updateEmail(''),
        expect: () => [SignInState.initial()],
      );
    });

    group('updatePassword', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with updated password',
        build: SignInCubit.new,
        act: (cubit) => cubit.updatePassword('secret123'),
        expect: () => [SignInState.initial().copyWith(password: 'secret123')],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with empty password when cleared',
        build: SignInCubit.new,
        seed: () => SignInState.initial().copyWith(password: 'oldpass'),
        act: (cubit) => cubit.updatePassword(''),
        expect: () => [SignInState.initial()],
      );
    });

    group('togglePasswordVisibility', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with obscurePassword false when initially true',
        build: SignInCubit.new,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [SignInState.initial().copyWith(obscurePassword: false)],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with obscurePassword true when currently false',
        build: SignInCubit.new,
        seed: () => SignInState.initial().copyWith(obscurePassword: false),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [SignInState.initial().copyWith(obscurePassword: true)],
      );
    });

    group('signIn', () {
      blocPresentationTest<SignInCubit, SignInState, SignInPresentationEvent>(
        'should emit ShowLoadingEvent and HideLoadingEvent',
        build: SignInCubit.new,
        act: (cubit) => cubit.signIn(),
        wait: const Duration(seconds: 3),
        expectPresentation: () => [
          ShowLoadingEvent(),
          HideLoadingEvent(),
        ],
      );
    });
  });
}
