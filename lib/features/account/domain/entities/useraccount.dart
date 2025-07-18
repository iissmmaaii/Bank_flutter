class UserAccount {
  final int id;
  final String? cardNumber; // تطابق الاستجابة
  final String? phoneNumber; // تطابق الاستجابة
  final String username; // تطابق الاستجابة

  UserAccount({
    required this.id,
    this.cardNumber,
    this.phoneNumber,
    required this.username,
  });
}
