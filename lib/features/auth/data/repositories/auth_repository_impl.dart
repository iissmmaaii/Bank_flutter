import 'package:bankapp3/core/error/exception.dart';
import 'package:bankapp3/features/auth/domain/entities/auth_response.dart';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/auth/domain/repositories/auth_repositry.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:bankapp3/core/error/network/network_info.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<String, User>> signup({
    required String username,
    required String email,
    required String phoneNumber,
    required String publicKey,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signup(
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          publicKey: publicKey,
        );
        localDataSource.cacheUserInfo(user);
        return Right(user);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, String>> loginStart({required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final challenge = await remoteDataSource.loginStart(userId: userId);
        return Right(challenge);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, AuthResponse>> loginFinish({
    required String userId,
    required String signature,
    String? deviceToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.loginFinish(
          userId: userId,
          signature: signature,
          deviceToken: deviceToken,
        );
        await localDataSource.cacheToken(authResponse.token);
        return Right(authResponse);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }
}
