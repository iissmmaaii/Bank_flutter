import 'package:bankapp3/features/auth/data/models/responseusermodel.dart';

import '../../domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    required super.success,
    required super.user,
    required super.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'],
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
