// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

class Paymetremotedatasource {
  final http.Client client;
  Paymetremotedatasource({required this.client});
  final String baseUrl = 'http://192.168.11.198:3001';
  Future<void> approve(String userId, double amount, String cardNumber) async {
    await client.post(
      Uri.parse('$baseUrl/approve-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'amount': amount.toString(),
        'cardNumber': cardNumber,
      }),
    );
  }

  Future<void> reject(String userId, double amount, String cardNumber) async {
    await client.post(
      Uri.parse('$baseUrl/reject-payment'),
      body: jsonEncode({
        'userId': userId,
        'amount': amount.toString(),
        'cardNumber': cardNumber,
      }),
    );
  }
}
