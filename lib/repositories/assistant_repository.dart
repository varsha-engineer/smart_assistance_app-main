import 'package:smart_assistance_app/core/api_service.dart';

import '../models/suggestion_model.dart';

class AssistantRepository {

  Future<List<SuggestionModel>> fetchSuggestions(int page) async {
    // Simulate API response since dummy API may not exist
    await Future.delayed(const Duration(milliseconds: 500));
    List<Map<String, dynamic>> mockData = [
      {"id": 1, "title": "Summarize my notes", "description": "Get a concise summary of your text"},
      {"id": 2, "title": "Generate email reply", "description": "Create a professional email response"},
      {"id": 3, "title": "Translate text", "description": "Translate text to another language"},
      {"id": 4, "title": "Write a poem", "description": "Generate a creative poem"},
      {"id": 5, "title": "Explain concept", "description": "Get detailed explanation of a topic"},
    ];

    // Simulate pagination: return subset based on page
    int start = (page - 1) * 10;
    int end = start + 10;
    if (start >= mockData.length) return [];
    return mockData.sublist(start, end.clamp(0, mockData.length)).map((e) => SuggestionModel.fromJson(e)).toList();
  }
}