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

  Future<String> changeName({required int id, required String name}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changename'),
      headers: headers,
      body: jsonEncode({'id': id, 'name': name}),
    );

    if (response.statusCode == 201) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<String> changeNunmber({
    required int id,
    required String number,
  }) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changenunmber'),
      headers: headers,
      body: jsonEncode({'id': id, 'nymber': number}),
    );

    if (response.statusCode == 201) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<String> changeEmail({required int id, required String email}) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/changeemail'),
      headers: headers,
      body: jsonEncode({'id': id, 'email': email}),
    );

    if (response.statusCode == 201) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<String> chargeAnotherAccount({
    required String accountNumber1,
    required String accountNumer2,
  }) async {
    final headers = await headersProvider.getAuthHeaders();

    final response = await client.post(
      Uri.parse('$baseUrl/chargeanotheraccount'),
      headers: headers,
      body: jsonEncode({
        'accountnumber1': accountNumber1,
        'accountnumber2': accountNumer2,
      }),
    );

    if (response.statusCode == 201) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }
}
