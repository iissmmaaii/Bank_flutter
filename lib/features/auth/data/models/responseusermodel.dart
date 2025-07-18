import 'package:bankapp3/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.username, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email};
  }
}
