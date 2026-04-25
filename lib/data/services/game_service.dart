import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import 'auth_storage.dart';

class GameService {
  static Future<Map<String, dynamic>> getGames(int page) async {
    final response = await http.get(
      Uri.parse("${ApiConstants.games}?page=$page&per_page=10"),
      headers: AuthStorage.authHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load games");
  }

  static Future<void> generateGames(int total, {String? genre}) async {
    final response = await http.post(
      Uri.parse(ApiConstants.generateGame),
      headers: {
        "Content-Type": "application/json",
        ...AuthStorage.authHeaders(),
      },
      body: jsonEncode({
        "total": total,
        if (genre != null && genre.trim().isNotEmpty) "genre": genre.trim(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to generate games");
    }
  }
}
