import 'package:bankapp3/features/auth/data/models/auth_response_model.dart';
import 'package:bankapp3/features/auth/data/models/responseusermodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://192.168.11.198:3001';

  AuthRemoteDataSource(this.client);

  Future<UserModel> signup({
    required String username,
    required String email,
    required String phoneNumber,
    required String publicKey,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/signfirst'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'publicKey': publicKey, // Now sending PEM format
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<String> loginStart({required String userId}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/loginstart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final challenge = jsonDecode(response.body)['challenge'];
      return _normalizeBase64(challenge);
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<AuthResponseModel> loginFinish({
    required String userId,
    required String signature,
    String? deviceToken,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/loginfinish'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'signature': signature,
        'deviceToken': deviceToken,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  String _normalizeBase64(String input) {
    final padding = input.length % 4;
    if (padding != 0) {
      input += '=' * (4 - padding);
    }
    return input;
  }
}
