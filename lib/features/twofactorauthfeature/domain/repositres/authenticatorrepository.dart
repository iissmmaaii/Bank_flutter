import 'package:bankapp3/core/error/fallures.dart';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/entities/authenticatorsecret.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticatorRepository {
  Future<AuthenticatorSecret> getSecret(String email);
  Future<Either<Failure, User>> verifyOtp({
    required String otp,
    required String email,
    required String phoneNumber,
    required String publickey,
  });
}
