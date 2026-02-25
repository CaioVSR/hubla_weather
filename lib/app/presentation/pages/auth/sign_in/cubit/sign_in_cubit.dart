import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> with BlocPresentationMixin<SignInState, SignInPresentationEvent> {
  SignInCubit({required SignInUseCase signInUseCase}) : _signInUseCase = signInUseCase, super(SignInState.initial());

  final SignInUseCase _signInUseCase;

  void updateEmail(String value) => emit(state.copyWith(email: value));

  void updatePassword(String value) => emit(state.copyWith(password: value));

  void togglePasswordVisibility() => emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> signIn() async {
    emitPresentation(ShowLoadingEvent());
    final result = await _signInUseCase(
      email: state.email,
      password: state.password,
    );
    emitPresentation(HideLoadingEvent());
    result.when(
      (error) => emitPresentation(ErrorEvent(error.errorMessage)),
      (_) => emitPresentation(SuccessEvent()),
    );
  }
}
