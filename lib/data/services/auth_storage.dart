import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = "auth_token";
  static const _usernameKey = "auth_username";

  static String? _token;
  static String? _username;

  static String? get token => _token;
  static String? get username => _username;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _username = prefs.getString(_usernameKey);
  }

  static Future<void> saveSession({
    required String token,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    _token = token;
    _username = username;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    _token = null;
    _username = null;
  }

  static Map<String, String> authHeaders() {
    if (_token == null || _token!.isEmpty) {
      return {};
    }

    return {"Authorization": "Bearer $_token"};
  }
}
