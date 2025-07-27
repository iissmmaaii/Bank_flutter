part of 'twofactorauthfeature_bloc.dart';

abstract class TwofactorauthfeatureState extends Equatable {
  const TwofactorauthfeatureState();

  @override
  List<Object> get props => [];
}

class TwofactorauthfeatureInitial extends TwofactorauthfeatureState {}

class TwofactorLoading extends TwofactorauthfeatureState {}

class TwofactorSecretLoaded extends TwofactorauthfeatureState {
  final AuthenticatorSecret secret;

  const TwofactorSecretLoaded({required this.secret});

  @override
  List<Object> get props => [secret];
}

class TwofactorVerified extends TwofactorauthfeatureState {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;

  const TwofactorVerified({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [id, username, email, phoneNumber];
}

class TwofactorError extends TwofactorauthfeatureState {
  final String message;

  const TwofactorError({required this.message});

  @override
  List<Object> get props => [message];
}
