// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/twofactorauthfeature/domain/entities/authenticatorsecret.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/repositres/authenticatorrepository.dart';

class Getsecretusecase {
  final AuthenticatorRepository repository;
  Getsecretusecase({required this.repository});

  Future<AuthenticatorSecret> excute(email) async {
    return await repository.getSecret(email);
  }
}
