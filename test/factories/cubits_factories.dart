import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';

import '../mocks/use_cases_mocks.dart';

abstract class CubitsFactories {
  static SignInCubit createSignInCubit({
    SignInUseCase? signInUseCase,
  }) => SignInCubit(
    signInUseCase: signInUseCase ?? MockSignInUseCase(),
  );
}
