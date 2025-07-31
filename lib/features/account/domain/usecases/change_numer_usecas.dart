// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:dartz/dartz.dart';

class ChangeNumber {
  final AccountRepositry accountRepositry;

  ChangeNumber({required this.accountRepositry});
  Future<Either<String, String>> execute({required String number}) async {
    return await accountRepositry.changeNunmber(number: number);
  }
}
