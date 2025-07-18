import 'package:bankapp3/features/auth/domain/entities/user.dart';

class AuthResponse {
  final bool success;
  final User user;
  final String token;

  AuthResponse({
    required this.success,
    required this.user,
    required this.token,
  });
}
