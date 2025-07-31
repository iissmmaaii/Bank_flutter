import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:dartz/dartz.dart';

class ChargeAnotherAcoount {
  final AccountRepositry accountRepositry;
  ChargeAnotherAcoount({required this.accountRepositry});

  Future<Either<String, String>> execute({
    required String accountNumer1,
    required String accountNumer2,
    required String amount,
  }) async {
    return await accountRepositry.chargeAnotherAccount(
      cardNumber1: accountNumer1,
      cardNumber2: accountNumer2,
      amount: amount,
    );
  }
}
