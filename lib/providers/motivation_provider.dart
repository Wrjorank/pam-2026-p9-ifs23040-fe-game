import 'package:flutter/material.dart';

import '../data/models/motivation_model.dart';
import '../data/services/motivation_service.dart';

class MotivationProvider extends ChangeNotifier {
  final List<Motivation> motivations = [];

  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isGenerating = false;
  String? errorMessage;

  Future<void> fetchMotivations() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await MotivationService.getMotivations(page);
      final data = result["data"] as List<dynamic>;

      if (data.isEmpty) {
        hasMore = false;
      } else {
        motivations.addAll(
          data.map((item) => Motivation.fromJson(item)).toList(),
        );
        page++;
      }
    } catch (_) {
      errorMessage = "Gagal memuat data motivation";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generate(String theme, int total) async {
    isGenerating = true;
    errorMessage = null;
    notifyListeners();

    try {
      await MotivationService.generateMotivation(theme, total);

      motivations.clear();
      page = 1;
      hasMore = true;

      await fetchMotivations();
    } catch (_) {
      errorMessage = "Gagal generate motivation";
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}
