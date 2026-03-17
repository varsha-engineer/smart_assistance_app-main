import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://dummyjson.com";

  /// GET /suggestions?current_page={page}&limit=10
  /// Response: { status, data: [...], pagination: { has_next, ... } }
  static Future<Map<String, dynamic>> getSuggestions(int page) async {
    final response = await http.get(
      Uri.parse("$baseUrl/suggestions?current_page=$page&limit=10"),
    );
    if (response.statusCode != 200) {
      throw Exception(
          "getSuggestions failed with status ${response.statusCode}");
    }
    return json.decode(response.body);
  }

  /// POST /chat  { "message": "..." }
  /// Response: { status, reply: "..." }
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": message}),
    );
    if (response.statusCode != 200) {
      throw Exception("sendMessage failed with status ${response.statusCode}");
    }
    return json.decode(response.body);
  }

  /// GET /chat/history
  /// Response: { status, data: [ { sender, message }, ... ] }
  static Future<Map<String, dynamic>> getChatHistory() async {
    final response = await http.get(
      Uri.parse("$baseUrl/chat/history"),
    );
    if (response.statusCode != 200) {
      throw Exception(
          "getChatHistory failed with status ${response.statusCode}");
    }
    return json.decode(response.body);
  }
}
