import 'package:flutter/material.dart';
import 'package:smart_assistance_app/models/suggestion_model.dart';
import 'package:smart_assistance_app/repositories/assistant_repository.dart';

class SuggestionProvider extends ChangeNotifier {
  final repository = AssistantRepository();

  List<SuggestionModel> suggestions = [];
  bool isLoading = false;
  String? error;
  int page = 1;
  bool hasMore = true;

  Future<void> fetchSuggestions() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final (data, hasNext) = await repository.fetchSuggestions(page);

      suggestions.addAll(data);
      hasMore = hasNext;
      if (data.isNotEmpty) page++;
    } catch (e) {
      error = "Failed to load suggestions";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
