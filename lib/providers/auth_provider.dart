import 'package:flutter/material.dart';

import '../data/services/auth_service.dart';
import '../data/services/auth_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool isInitializing = true;
  bool isLoggingIn = false;
  String? errorMessage;
  String? username;

  bool get isAuthenticated =>
      AuthStorage.token != null && AuthStorage.token!.isNotEmpty;

  Future<void> initialize() async {
    await AuthStorage.load();
    username = AuthStorage.username;
    isInitializing = false;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    isLoggingIn = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(
        username: username,
        password: password,
      );

      final token =
          result["token"] ??
          result["access_token"] ??
          result["data"]?["token"] ??
          result["data"]?["access_token"];

      final resolvedUsername =
          result["username"] ??
          result["user"]?["username"] ??
          result["data"]?["username"] ??
          username;

      if (token is! String || token.isEmpty) {
        throw Exception("Token tidak ditemukan");
      }

      await AuthStorage.saveSession(
        token: token,
        username: resolvedUsername.toString(),
      );

      this.username = resolvedUsername.toString();
      return true;
    } catch (_) {
      errorMessage = "Login gagal. Periksa akun backend.";
      return false;
    } finally {
      isLoggingIn = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    username = null;
    errorMessage = null;
    notifyListeners();
  }
}
