part of 'accountuser_bloc.dart';

@immutable
sealed class AccountuserState {}

final class AccountuserInitial extends AccountuserState {}

class AccountLoading extends AccountuserState {}

class AccountLoaded extends AccountuserState {
  final UserAccount account;
  AccountLoaded(this.account);
}

class AccountUpdated extends AccountuserState {
  final String message; // مثلاً: "Email changed successfully"
  AccountUpdated(this.message);
}

class AccountError extends AccountuserState {
  final String message;
  AccountError(this.message);
}
