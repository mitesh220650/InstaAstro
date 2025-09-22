import 'package:hive_flutter/hive_flutter.dart';

class TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _boxName = 'appBox';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final box = Hive.box(_boxName);
    await box.put(_accessTokenKey, token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final box = Hive.box(_boxName);
    return box.get(_accessTokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final box = Hive.box(_boxName);
    await box.put(_refreshTokenKey, token);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final box = Hive.box(_boxName);
    return box.get(_refreshTokenKey);
  }

  // Clear all tokens (for logout)
  static Future<void> clearTokens() async {
    final box = Hive.box(_boxName);
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
