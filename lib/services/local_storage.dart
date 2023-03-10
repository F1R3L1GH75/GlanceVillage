import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyAuthToken = 'authToken';
  static const _keyRefreshToken = 'refreshToken';

  static Future setAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  static Future setRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  static Future deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  static Future deleteAll() async {
    await _storage.deleteAll();
  }
}