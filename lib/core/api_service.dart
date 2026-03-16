import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://dummyjson.com";

  static Future<Map<String, dynamic>> getSuggestions(int page) async {
    final response = await http.get(
      Uri.parse("$baseUrl/suggestions?page=$page&limit=10"),
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": message}),
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getChatHistory() async {
    final response = await http.get(
      Uri.parse("$baseUrl/chat/history"),
    );

    return json.decode(response.body);
  }
}
