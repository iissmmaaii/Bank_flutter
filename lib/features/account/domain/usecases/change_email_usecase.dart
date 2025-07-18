// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:dartz/dartz.dart';

class ChangeEmail {
  final AccountRepositry accountRepositry;

  ChangeEmail({required this.accountRepositry});
  Future<Either<String, String>> execute({
    required int id,
    required String email,
  }) async {
    return await accountRepositry.changeEmail(id: id, email: email);
  }
}
