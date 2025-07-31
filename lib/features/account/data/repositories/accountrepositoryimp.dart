import 'package:dartz/dartz.dart';
import 'package:bankapp3/core/error/exception.dart';
import 'package:bankapp3/core/error/network/network_info.dart';
import 'package:bankapp3/features/account/data/datasource/accountlocaldatasource.dart';
import 'package:bankapp3/features/account/data/datasource/accountremotedatasource.dart';
import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:bankapp3/features/account/domain/entities/useraccount.dart';

class Accountrepositoryimp implements AccountRepositry {
  final AccountRemoteDataSource remoteDataSource;
  final Accountlocaldatasource localDataSource;
  final NetworkInfo networkInfo;

  Accountrepositoryimp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<String, String>> changeEmail({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changeEmail(email: email);
        return Right(result);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, String>> changeName({required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changeName(name: name);
        return Right(result);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, String>> changeNunmber({required String number}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changePhoneNumber(number: number);
        return Right(result);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, String>> chargeAnotherAccount({
    required String cardNumber1,
    required String cardNumber2,
    required String amount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.chargeAnotherAccount(
          cardNumber1: cardNumber1,
          cardNumber2: cardNumber2,
          amount: amount,
        );
        return Right(result);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }

  @override
  Future<Either<String, UserAccount>> getinfo({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getinfo(id: id);
        await localDataSource.cacheuserinfo(result);
        return Right(result);
      } on ServerEcception {
        return Left('Server error occurred');
      }
    } else {
      return Left('No internet connection');
    }
  }
}
