part of 'login_bloc.dart';

abstract class LoginEvent {}

class AutoLoginRequested extends LoginEvent {}

class LoginCompleted extends LoginEvent {
  final String userId;
  final String challenge;
  final String? deviceToken;

  LoginCompleted({
    required this.userId,
    required this.challenge,
    this.deviceToken,
  });
}
