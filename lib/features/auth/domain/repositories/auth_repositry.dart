import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<Either<String, User>> signup({
    required String username,
    required String email,
    required String phoneNumber,
    required String publicKey,
  });
  Future<Either<String, String>> loginStart({required String userId});
  Future<Either<String, AuthResponse>> loginFinish({
    required String userId,
    required String signature,
    required String deviceToken,
  });
}
