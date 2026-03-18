import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_assistance_app/core/api_service.dart';

class HistoryProvider extends ChangeNotifier {
  final box = Hive.box("chat_history");

  List<Map<String, String>> _apiHistory = [];
  bool isLoading = false;
  String? error;

  List<Map<String, String>> get history {
    final local = box.values
        .map((e) => Map<String, String>.from(json.decode(e)))
        .toList();
    return [..._apiHistory, ...local];
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.getChatHistory();
      final List<dynamic> rawData = response['data'] ?? [];

      _apiHistory = rawData
          .map<Map<String, String>>((e) => {
                'sender': e['sender']?.toString() ?? '',
                'message': e['message']?.toString() ?? '',
              })
          .toList();
    } catch (_) {
      _apiHistory = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    await box.clear(); // clear local storage
    _apiHistory.clear(); // clear API data
    notifyListeners();
  }

  void saveMessage(Map<String, String> message) {
    box.add(json.encode(message));
    notifyListeners();
  }
}
