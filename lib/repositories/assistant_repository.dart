import 'package:smart_assistance_app/core/api_service.dart';
import '../models/suggestion_model.dart';

class AssistantRepository {
  static final List<Map<String, dynamic>> _mockData = [
    {
      "id": 1,
      "title": "Summarize my notes",
      "description": "Get a concise summary of your text"
    },
    {
      "id": 2,
      "title": "Generate email reply",
      "description": "Create a professional email response"
    },
    {
      "id": 3,
      "title": "Translate text",
      "description": "Translate text to another language"
    },
    {
      "id": 4,
      "title": "Write a poem",
      "description": "Generate a creative poem"
    },
    {
      "id": 5,
      "title": "Explain concept",
      "description": "Get detailed explanation of a topic"
    },
    {
      "id": 6,
      "title": "Fix my code",
      "description": "Debug and improve your code snippet"
    },
    {
      "id": 7,
      "title": "Write a story",
      "description": "Generate a short creative story"
    },
    {
      "id": 8,
      "title": "Plan my week",
      "description": "Create a structured weekly schedule"
    },
    {
      "id": 9,
      "title": "Summarize article",
      "description": "Get key takeaways from any article"
    },
    {
      "id": 10,
      "title": "Draft a message",
      "description": "Write a professional message or note"
    },
  ];

  Future<(List<SuggestionModel>, bool)> fetchSuggestions(
    int page,
  ) async {
    try {
      final response = await ApiService.getSuggestions(page);

      final List<dynamic> rawData = response['data'] ?? [];
      final List<SuggestionModel> data = rawData
          .map<SuggestionModel>((e) => SuggestionModel.fromJson(e))
          .toList();

      final pagination = response['pagination'] as Map<String, dynamic>? ?? {};
      final bool hasNext = pagination['has_next'] as bool? ?? false;

      return (data, hasNext);
    } catch (_) {
      const int limit = 10;
      final int start = (page - 1) * limit;
      if (start >= _mockData.length) return (<SuggestionModel>[], false);

      final int end = (start + limit).clamp(0, _mockData.length);
      final List<SuggestionModel> data = _mockData
          .sublist(start, end)
          .map<SuggestionModel>((e) => SuggestionModel.fromJson(e))
          .toList();
      final bool hasNext = end < _mockData.length;

      return (data, hasNext);
    }
  }
}
