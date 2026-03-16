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
    // Combine API and local history
    return [
      ..._apiHistory,
      ...box.values.map((e) => Map<String, String>.from(json.decode(e)))
    ];
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _apiHistory = [
        {"sender": "user", "message": "What is Flutter?"},
        {"sender": "assistant", "message": "Flutter is an open-source UI toolkit by Google."},
      ];
    } catch (e) {
      error = "Failed to load history";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void saveMessage(Map<String, String> message) {
    box.add(json.encode(message));
    notifyListeners();
  }
}
