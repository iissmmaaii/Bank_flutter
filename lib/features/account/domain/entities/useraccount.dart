// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserAccount {
  final int id;
  final String? cardNumber; // تطابق الاستجابة
  final String? phoneNumber; // تطابق الاستجابة
  final String username; // تطابق الاستجابة
  final String money;

  UserAccount({
    required this.id,
    this.cardNumber,
    this.phoneNumber,
    required this.username,
    required this.money,
  });
}
