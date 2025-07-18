// lib/features/auth/presentation/bloc/signup_state.dart
part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupBiometricPrompt extends SignupState {}

class SignupSuccess extends SignupState {
  final User user;

  SignupSuccess(this.user);
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}
