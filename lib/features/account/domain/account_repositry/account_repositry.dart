import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:dartz/dartz.dart';

abstract class AccountRepositry {
  Future<Either<String, UserAccount>> getinfo({required String id});

  Future<Either<String, String>> chargeAnotherAccount({
    required String cardNumber1,
    required String cardNumber2,
    required String amount,
  });

  Future<Either<String, String>> changeName({required String name});
  Future<Either<String, String>> changeNunmber({required String number});
  Future<Either<String, String>> changeEmail({required String email});
}
