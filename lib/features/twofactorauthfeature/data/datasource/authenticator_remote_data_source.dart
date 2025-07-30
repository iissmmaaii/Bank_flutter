import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:bankapp3/features/twofactorauthfeature/domain/entities/authenticatorsecret.dart';
import 'package:bankapp3/core/network/http_headers_provider.dart'; // استيراد مزود الهيدرز

abstract class AuthenticatorRemoteDataSource {
  Future<AuthenticatorSecret> getSecret(String email);
  Future<User> verifyOtp({
    required String otp,
    required String email,
    required String phoneNumber,
    required String publickey,
  });
}

class AuthenticatorRemoteDataSourceImpl
    implements AuthenticatorRemoteDataSource {
  final http.Client client;
  final HttpHeadersProvider headersProvider; // أضفنا هنا
  final String baseUrl = 'http://192.168.11.198:3001';

  AuthenticatorRemoteDataSourceImpl({
    required this.client,
    required this.headersProvider, // استقبلناه في الكونستركتور
  });

  @override
  Future<AuthenticatorSecret> getSecret(String email) async {
    try {
      final headers = await headersProvider.getAuthHeaders(); // جلب الهيدرز
      final response = await client.post(
        Uri.parse('$baseUrl/2fa/secret'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      print('Get Secret Response Status: ${response.statusCode}');
      print('Get Secret Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('Get Secret Parsed JSON: $decoded');
        return AuthenticatorSecret(secret: decoded['secret'] ?? '');
      } else {
        throw Exception(
          'Failed to load secret: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get Secret Error: $e');
      rethrow;
    }
  }

  Future<User> verifyOtp({
    required String otp,
    required String email,
    required String phoneNumber,
    required String publickey,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/2fa/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otp': otp,
          'email': email,
          'phoneNumber': phoneNumber,
          'publicKey': publickey,
        }),
      );

      print('Verify OTP Response Status: ${response.statusCode}');
      print('Verify OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Verify OTP Parsed JSON: $json');
        if (json['success'] == true) {
          final userJson = json['user'];
          print('User JSON: $userJson');
          print('User JSON Keys: ${userJson.keys.toList()}');
          final emailValue = userJson['email']?.toString().toLowerCase() ?? '';
          print('Email Value: $emailValue');
          return User(
            id: userJson['id']?.toString() ?? '',
            username: userJson['username']?.toString() ?? '',
            email: emailValue,
          );
        } else {
          throw Exception(json['error'] ?? 'Invalid OTP');
        }
      } else {
        throw Exception(
          'Failed to verify OTP: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Verify OTP Error: $e');
      rethrow;
    }
  }
}
