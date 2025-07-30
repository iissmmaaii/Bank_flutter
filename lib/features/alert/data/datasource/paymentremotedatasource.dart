// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bankapp3/core/network/http_headers_provider.dart'; // لو هيدا ملفك لتعريف الهيدرز

class Paymetremotedatasource {
  final http.Client client;
  final HttpHeadersProvider headersProvider;
  Paymetremotedatasource({required this.client, required this.headersProvider});

  final String baseUrl = 'http://192.168.11.198:3001';

  Future<void> approve(String userId, double amount, String cardNumber) async {
    final headers = await headersProvider.getAuthHeaders();

    await client.post(
      Uri.parse('$baseUrl/approve-payment'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
        'amount': amount.toString(),
        'cardNumber': cardNumber,
      }),
    );
  }

  Future<void> reject(String userId, double amount, String cardNumber) async {
    final headers = await headersProvider.getAuthHeaders();

    await client.post(
      Uri.parse('$baseUrl/reject-payment'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
        'amount': amount.toString(),
        'cardNumber': cardNumber,
      }),
    );
  }
}
