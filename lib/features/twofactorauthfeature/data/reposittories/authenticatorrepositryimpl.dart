import 'package:bankapp3/core/error/fallures.dart';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/twofactorauthfeature/data/datasource/authenticator_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/authenticatorsecret.dart';
import '../../domain/repositres/authenticatorrepository.dart';

class AuthenticatorRepositoryImpl implements AuthenticatorRepository {
  final AuthenticatorRemoteDataSource remoteDataSource;

  AuthenticatorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthenticatorSecret> getSecret(String email) async {
    return await remoteDataSource.getSecret(email);
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String otp,
    required String email,
    required String phoneNumber,
    required String publickey,
  }) async {
    try {
      final user = await remoteDataSource.verifyOtp(
        otp: otp,
        email: email,
        phoneNumber: phoneNumber,
        publickey: publickey,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
