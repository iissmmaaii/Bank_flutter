import 'package:bankapp3/features/auth/domain/repositories/auth_repositry.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<String, User>> execute({
    required String username,
    required String email,
    required String phoneNumber,
    required String publicKey,
  }) async {
    return await repository.signup(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      publicKey: publicKey,
    );
  }
}
