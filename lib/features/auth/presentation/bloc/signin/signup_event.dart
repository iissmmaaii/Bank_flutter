// lib/features/auth/presentation/bloc/signup_event.dart
part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignupWithPasskeySubmitted extends SignupEvent {
  final String username;
  final String email;
  final String phoneNumber;

  SignupWithPasskeySubmitted({
    required this.username,
    required this.email,
    required this.phoneNumber,
  });
}
