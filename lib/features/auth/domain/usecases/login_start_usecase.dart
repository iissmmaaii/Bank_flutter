import 'package:bankapp3/features/auth/domain/repositories/auth_repositry.dart';
import 'package:dartz/dartz.dart';

class LoginStartUseCase {
  final AuthRepository repository;

  LoginStartUseCase(this.repository);

  Future<Either<String, String>> execute({required String userId}) async {
    return await repository.loginStart(userId: userId);
  }
}
