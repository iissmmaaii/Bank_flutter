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
  final String message; // مثل "تم التحديث بنجاح"
  AccountUpdated(this.message);
}

class AccountError extends AccountuserState {
  final String message;
  AccountError(this.message);
}

class ChargeSuccess extends AccountuserState {
  final String message;

  ChargeSuccess(this.message);
}
