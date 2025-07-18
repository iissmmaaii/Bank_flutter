// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:dartz/dartz.dart';

class ChargeAnotherAcoount {
  final AccountRepositry accountRepositry;
  ChargeAnotherAcoount({required this.accountRepositry});
  Future<Either<String, String>> execute({
    required String accountNumer1,
    required String accountNumer2,
  }) async {
    return await accountRepositry.chargeAnotherAccount(
      accountNumer1: accountNumer1,
      accountNumer2: accountNumer2,
    );
  }
}
