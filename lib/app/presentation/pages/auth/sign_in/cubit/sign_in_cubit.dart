import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> with BlocPresentationMixin<SignInState, SignInPresentationEvent> {
  SignInCubit() : super(SignInState.initial());

  void updateEmail(String value) => emit(state.copyWith(email: value));

  void updatePassword(String value) => emit(state.copyWith(password: value));

  void togglePasswordVisibility() => emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> signIn() async {
    emitPresentation(ShowLoadingEvent());
    await Future.delayed(const Duration(seconds: 2));
    emitPresentation(HideLoadingEvent());
  }
}
