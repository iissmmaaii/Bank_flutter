import 'package:bankapp3/features/account/domain/entities/useraccount.dart';

class UserAccountModel extends UserAccount {
  UserAccountModel({
    required super.id,
    super.cardNumber, // nullable
    super.phoneNumber, // nullable
    required super.username,
    required super.money,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      id: json['id'] ?? 0,
      cardNumber: json['cardNumber'], // تطابق الحقل
      phoneNumber: json['phoneNumber'], // تطابق الحقل
      username: json['username'] ?? '',
      money: json['money'], // تطابق الحقل
    );
  }
}
