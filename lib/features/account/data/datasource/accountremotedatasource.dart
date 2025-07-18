// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bankapp3/features/account/data/models/useraccountmodel.dart';
import 'package:http/http.dart' as http;

class AccountRemoteDataSource {
  final String baseUrl = 'http://192.168.11.198:3001';
  final http.Client client;
  AccountRemoteDataSource({required this.client});
  Future<UserAccountModel> getinfo({required String id}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/getinfo'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await client.post(
      Uri.parse('$baseUrl/changename'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await client.post(
      Uri.parse('$baseUrl/changenunmber'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'nymber': number}),
    );
    if (response.statusCode == 201) {
      return 'true';
    } else {
      throw jsonDecode(response.body)['error'];
    }
  }

  Future<String> changeEmail({required int id, required String email}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/changeemail'),
      headers: {'Content-Type': 'application/json'},
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
    final response = await client.post(
      Uri.parse('$baseUrl/chargeanotheraccount'),
      headers: {'Content-Type': 'application/json'},
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
