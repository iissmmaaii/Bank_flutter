part of 'accountuser_bloc.dart';

@immutable
abstract class AccountuserEvent {}

class GetAccountInfoEvent extends AccountuserEvent {}

class ChangeEmailEvent extends AccountuserEvent {
  final int userId;
  final String newEmail;
  ChangeEmailEvent({required this.userId, required this.newEmail});
}

class ChangeNameEvent extends AccountuserEvent {
  final int userId;
  final String newName;
  ChangeNameEvent({required this.userId, required this.newName});
}

class ChangeNumberEvent extends AccountuserEvent {
  final int userId;
  final String newNumber;
  ChangeNumberEvent({required this.userId, required this.newNumber});
}

class ChargeAnotherAccountEvent extends AccountuserEvent {
  final String fromAccount;
  final String toAccount;
  ChargeAnotherAccountEvent({
    required this.fromAccount,
    required this.toAccount,
  });
}
