import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:dartz/dartz.dart';

abstract class AccountRepositry {
  Future<Either<String, UserAccount>> getinfo({required String id});
  Future<Either<String, String>> chargeAnotherAccount({
    required String accountNumer1,
    required String accountNumer2,
  });
  Future<Either<String, String>> changeName({
    required int id,
    required String name,
  });
  Future<Either<String, String>> changeNunmber({
    required int id,
    required String number,
  });
  Future<Either<String, String>> changeEmail({
    required int id,
    required String email,
  });
}
