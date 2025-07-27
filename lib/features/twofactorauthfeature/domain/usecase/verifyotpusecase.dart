import 'package:bankapp3/core/error/fallures.dart';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/repositres/authenticatorrepository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtpUsecase {
  final AuthenticatorRepository repository;

  VerifyOtpUsecase({required this.repository});

  Future<Either<Failure, User>> execute({
    required String otp,
    required String email,
    required String phoneNumber,
    required String publickey,
  }) async {
    return await repository.verifyOtp(
      otp: otp,
      email: email,
      phoneNumber: phoneNumber,
      publickey: publickey,
    );
  }
}
