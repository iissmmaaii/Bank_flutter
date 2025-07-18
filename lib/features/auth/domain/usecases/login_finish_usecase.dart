import 'package:bankapp3/features/auth/domain/repositories/auth_repositry.dart';
import 'package:dartz/dartz.dart';
import '../entities/auth_response.dart';

class LoginFinishUseCase {
  final AuthRepository repository;

  LoginFinishUseCase(this.repository);

  Future<Either<String, AuthResponse>> execute({
    required String userId,
    required String signature,
    required String deviceToken,
  }) async {
    return await repository.loginFinish(
      userId: userId,
      signature: signature,
      deviceToken: deviceToken,
    );
  }
}
