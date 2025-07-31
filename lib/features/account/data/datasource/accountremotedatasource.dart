// lib/features/account/data/datasources/account_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bankapp3/features/account/data/models/useraccountmodel.dart';
import 'package:bankapp3/core/network/http_headers_provider.dart';

class AccountRemoteDataSource {
  final String baseUrl = 'http://192.168.11.198:3001';
  final http.Client client;
  final HttpHeadersProvider headersProvider;

  AccountRemoteDataSource({
    required this.client,
    required this.headersProvider,
  });

  Future<UserAccountModel> getinfo({required String id}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/getinfo'),
      headers: headers,
      body: jsonEncode({'userId': id}),
    );

    print('📥 الاستجابة - الحالة: ${response.statusCode}');
    print('📥 جسم الاستجابة: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final decodedBody = jsonDecode(response.body);
        print('🔍 الاستجابة بعد التحليل: $decodedBody');
        return UserAccountModel.fromJson(decodedBody);
      } catch (e) {
        print('❌ خطأ في تحليل الاستجابة: $e');
        rethrow;
      }
    } else {
      final error = jsonDecode(response.body)?['error'] ?? 'Unknown error';
      print('❌ خطأ من السيرفر: $error');
      throw error;
    }
  }

  // تغيير الاسم
  Future<String> changeName({required String name}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changename'),
      headers: headers,
      body: jsonEncode({'newName': name}), // ✅ مطابق للباك
    );

    if (response.statusCode == 200) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  // تغيير الإيميل
  Future<String> changeEmail({required String email}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changeemail'),
      headers: headers,
      body: jsonEncode({'newEmail': email}), // ✅ مطابق للباك
    );

    if (response.statusCode == 200) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  // تغيير الرقم
  Future<String> changePhoneNumber({required String number}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changephonenumber'),
      headers: headers,
      body: jsonEncode({'newPhoneNumber': number}), // ✅ مطابق للباك
    );

    if (response.statusCode == 200) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }

  // تحويل من حساب لحساب
  Future<String> chargeAnotherAccount({
    required String cardNumber1,
    required String cardNumber2,
    required String amount, // لأنه بيروح كـ string حسب الباك
  }) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/charge-account'),
      headers: headers,
      body: jsonEncode({
        'cardNumber1': cardNumber1,
        'cardNumber2': cardNumber2,
        'ammount': amount, // ✅ مطابق للباك
      }),
    );
    print('📥 الاستجابة - الحالة: ${response.statusCode}');
    print('📥 جسم الاستجابة: ${response.body}');

    if (response.statusCode == 200) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }
}
