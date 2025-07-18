part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginBiometricPrompt extends LoginState {
  final String challenge;
  final String userId;

  LoginBiometricPrompt({required this.challenge, required this.userId});
}

class LoginSuccess extends LoginState {
  final AuthResponse authResponse;

  LoginSuccess({required this.authResponse});
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
