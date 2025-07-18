// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/account/domain/account_repositry/account_repositry.dart';
import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:dartz/dartz.dart';

class GetInfo {
  final AccountRepositry accountRepositry;
  GetInfo({required this.accountRepositry});
  Future<Either<String, UserAccount>> execute({required String id}) async {
    return await accountRepositry.getinfo(id: id);
  }
}
