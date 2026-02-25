import 'package:equatable/equatable.dart';

sealed class SignInPresentationEvent {}

class ShowLoadingEvent extends Equatable implements SignInPresentationEvent {
  @override
  List<Object?> get props => [];
}

class HideLoadingEvent extends Equatable implements SignInPresentationEvent {
  @override
  List<Object?> get props => [];
}

class ErrorEvent extends Equatable implements SignInPresentationEvent {
  const ErrorEvent(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class SuccessEvent extends Equatable implements SignInPresentationEvent {
  @override
  List<Object?> get props => [];
}
