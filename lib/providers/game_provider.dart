import 'package:flutter/material.dart';

import '../data/models/game_model.dart';
import '../data/services/game_service.dart';

class GameProvider extends ChangeNotifier {
  final List<Game> games = [];

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;
  String? errorMessage;

  Future<void> fetchGames() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await GameService.getGames(page);
      final data = result["data"] as List<dynamic>;

      if (data.isEmpty) {
        hasMore = false;
      } else {
        games.addAll(data.map((item) => Game.fromJson(item)).toList());
        page++;
      }
    } catch (_) {
      errorMessage = "Gagal memuat data game";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generate(int total, {String? genre}) async {
    isGenerating = true;
    errorMessage = null;
    notifyListeners();

    try {
      await GameService.generateGames(total, genre: genre);

      games.clear();
      page = 1;
      hasMore = true;

      await fetchGames();
    } catch (_) {
      errorMessage = "Gagal generate game";
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}
