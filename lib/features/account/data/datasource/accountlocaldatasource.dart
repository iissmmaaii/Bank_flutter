// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bankapp3/features/account/data/models/useraccountmodel.dart';
import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmptyCacheException implements Exception {
  final String? message;
  EmptyCacheException({this.message});
}

class Accountlocaldatasource {
  final FlutterSecureStorage _storage;

  Accountlocaldatasource({required FlutterSecureStorage storage})
    : _storage = storage;

  /// تخزن بيانات المستخدم في التخزين المحلي الآمن
  Future<Unit> cacheuserinfo(UserAccount info) async {
    try {
      await _storage.write(key: 'user_id', value: info.id.toString());
      await _storage.write(key: 'card_number', value: info.cardNumber ?? '');
      await _storage.write(
        key: 'phone_number',
        value: info.phoneNumber?.toString() ?? '',
      );
      await _storage.write(key: 'user_name', value: info.username);
      return unit;
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to cache user info: ${e.toString()}',
      );
    }
  }

  /// يستخرج بيانات المستخدم المخزنة محليًا
  Future<UserAccount> getCachedUserInfo() async {
    try {
      final id = int.parse(await _storage.read(key: 'user_id') ?? '0');
      final card = await _storage.read(key: 'card_number') ?? '';
      final phone = await _storage.read(key: 'phone_number') ?? '';
      final name = await _storage.read(key: 'user_name') ?? '';

      print('🔍 القيم المستخرجة: id=$id, card=$card, phone=$phone, name=$name');

      if (name.isEmpty) {
        throw EmptyCacheException(message: 'No user name found in cache');
      }

      return UserAccountModel(
        id: id,
        cardNumber: card.isEmpty ? null : card, // تحويل إلى null إذا كان فارغ
        phoneNumber:
            phone.isEmpty ? null : phone, // تحويل إلى null إذا كان فارغ
        username: name,
      );
    } catch (e) {
      throw EmptyCacheException(
        message: 'Failed to get cached user info: ${e.toString()}',
      );
    }
  }
}
