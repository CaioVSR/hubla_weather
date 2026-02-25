import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../factories/cubits_factories.dart';
import '../../../../../../factories/entities/user_factory.dart';
import '../../../../../../mocks/use_cases_mocks.dart';

void main() {
  late MockSignInUseCase mockSignInUseCase;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
  });

  SignInCubit buildCubit() => CubitsFactories.createSignInCubit(signInUseCase: mockSignInUseCase);

  group('SignInCubit', () {
    test('should have correct initial state', () {
      final cubit = buildCubit();

      expect(cubit.state, SignInState.initial());

      cubit.close();
    });

    group('updateEmail', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with updated email',
        build: buildCubit,
        act: (cubit) => cubit.updateEmail('user@test.com'),
        expect: () => [SignInState.initial().copyWith(email: 'user@test.com')],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with empty email when cleared',
        build: buildCubit,
        seed: () => SignInState.initial().copyWith(email: 'old@test.com'),
        act: (cubit) => cubit.updateEmail(''),
        expect: () => [SignInState.initial()],
      );
    });

    group('updatePassword', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with updated password',
        build: buildCubit,
        act: (cubit) => cubit.updatePassword('secret123'),
        expect: () => [SignInState.initial().copyWith(password: 'secret123')],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with empty password when cleared',
        build: buildCubit,
        seed: () => SignInState.initial().copyWith(password: 'oldpass'),
        act: (cubit) => cubit.updatePassword(''),
        expect: () => [SignInState.initial()],
      );
    });

    group('togglePasswordVisibility', () {
      blocTest<SignInCubit, SignInState>(
        'should emit state with obscurePassword false when initially true',
        build: buildCubit,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [SignInState.initial().copyWith(obscurePassword: false)],
      );

      blocTest<SignInCubit, SignInState>(
        'should emit state with obscurePassword true when currently false',
        build: buildCubit,
        seed: () => SignInState.initial().copyWith(obscurePassword: false),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [SignInState.initial().copyWith(obscurePassword: true)],
      );
    });

    group('signIn', () {
      blocPresentationTest<SignInCubit, SignInState, SignInPresentationEvent>(
        'should emit ShowLoading, HideLoading, and SuccessEvent on valid credentials',
        build: buildCubit,
        setUp: () {
          when(
            () => mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => Success(UserFactory.create()));
        },
        seed: () => SignInState.initial().copyWith(email: 'weather@hub.la', password: 'weatherhubla'),
        act: (cubit) => cubit.signIn(),
        expectPresentation: () => [
          ShowLoadingEvent(),
          HideLoadingEvent(),
          SuccessEvent(),
        ],
      );

      blocPresentationTest<SignInCubit, SignInState, SignInPresentationEvent>(
        'should emit ShowLoading, HideLoading, and ErrorEvent on invalid credentials',
        build: buildCubit,
        setUp: () {
          when(
            () => mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Error(InvalidCredentialsError()));
        },
        seed: () => SignInState.initial().copyWith(email: 'wrong@email.com', password: 'wrong'),
        act: (cubit) => cubit.signIn(),
        expectPresentation: () => [
          ShowLoadingEvent(),
          HideLoadingEvent(),
          const ErrorEvent('Invalid email or password'),
        ],
      );

      blocPresentationTest<SignInCubit, SignInState, SignInPresentationEvent>(
        'should call signInUseCase with current email and password from state',
        build: buildCubit,
        setUp: () {
          when(
            () => mockSignInUseCase(email: 'test@hub.la', password: 'testpass'),
          ).thenAnswer((_) async => Success(UserFactory.create()));
        },
        seed: () => SignInState.initial().copyWith(email: 'test@hub.la', password: 'testpass'),
        act: (cubit) => cubit.signIn(),
        verify: (_) {
          verify(() => mockSignInUseCase(email: 'test@hub.la', password: 'testpass')).called(1);
        },
        expectPresentation: () => [
          ShowLoadingEvent(),
          HideLoadingEvent(),
          SuccessEvent(),
        ],
      );
    });
  });
}
