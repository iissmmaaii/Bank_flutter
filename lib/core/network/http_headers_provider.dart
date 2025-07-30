import 'package:bankapp3/features/auth/data/datasources/auth_local_datasource.dart';

class HttpHeadersProvider {
  final AuthLocalDataSource authLocalDataSource;

  HttpHeadersProvider({required this.authLocalDataSource});

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await authLocalDataSource.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
