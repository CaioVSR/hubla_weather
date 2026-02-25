import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  const SignInState({
    required this.email,
    required this.password,
    required this.obscurePassword,
  });

  factory SignInState.initial() => const SignInState(
    email: '',
    password: '',
    obscurePassword: true,
  );

  final String email;
  final String password;
  final bool obscurePassword;

  bool get hasValidInput => email.isNotEmpty && password.isNotEmpty;

  SignInState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
  }) => SignInState(
    email: email ?? this.email,
    password: password ?? this.password,
    obscurePassword: obscurePassword ?? this.obscurePassword,
  );

  @override
  List<Object?> get props => [email, password, obscurePassword];
}
