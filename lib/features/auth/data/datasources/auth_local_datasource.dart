import 'package:bankapp3/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmptyCacheException implements Exception {
  final String? message;
  EmptyCacheException({this.message});
}

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSource(this._storage);

  Future<Unit> cachePrivateKey(String privateKey, String userId) async {
    try {
      print('🔐 سيتم تخزين المفتاح للمستخدم $userId:\n$privateKey');
      await _storage.write(key: 'private_key_$userId', value: privateKey);

      return unit;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to cache private key: ${e.toString()}',
      );
    }
  }

  Future<String?> getPrivateKey(String userId) async {
    try {
      final privateKey = await _storage.read(key: 'private_key_$userId');
      print('📥 تم تحميل المفتاح للمستخدم $userId:\n$privateKey');

      if (privateKey == null) {
        throw EmptyCacheException(
          message: 'Private key not found for user $userId',
        );
      }
      return privateKey;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to retrieve private key: ${e.toString()}',
      );
    }
  }

  Future<Unit> cacheToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
      return unit;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to cache token: ${e.toString()}',
      );
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        throw EmptyCacheException(message: 'Token not found');
      }
      return token;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to retrieve token: ${e.toString()}',
      );
    }
  }

  Future<Unit> cacheUserInfo(User user) async {
    try {
      await _storage.write(key: 'email', value: user.email);
      await _storage.write(key: 'id', value: user.id);
      await _storage.write(key: 'username', value: user.username);
      return unit;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to cache user info: ${e.toString()}',
      );
    }
  }

  Future<User> getUserInfo() async {
    try {
      final email = await _storage.read(key: 'email');
      final id = await _storage.read(key: 'id');
      final username = await _storage.read(key: 'username');

      if (email == null || id == null || username == null) {
        throw EmptyCacheException(
          message: 'User info is incomplete or not found',
        );
      }

      return User(id: id, username: username, email: email);
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to retrieve user info: ${e.toString()}',
      );
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: 'id');
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to retrieve user ID: ${e.toString()}',
      );
    }
  }
}
