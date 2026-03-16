import 'package:flutter/material.dart';
import 'package:smart_assistance_app/core/api_service.dart';
import 'package:smart_assistance_app/models/chat_screen_model.dart';
import 'package:smart_assistance_app/providers/history_provider.dart';
import 'package:provider/provider.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> messages = [];
  bool isLoading = false;
  String? error;

  Future<void> sendMessage(String message, BuildContext context) async {
    if (message.isEmpty) return;

    messages.add(ChatMessage(sender: "user", message: message));
    notifyListeners();

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Simulate API call since dummy API endpoint may not exist
      await Future.delayed(const Duration(seconds: 1));
      String reply =
          "Flutter state management helps manage UI efficiently. This is a simulated response.";
      messages.add(ChatMessage(sender: "assistant", message: reply));

      // Save to history
      context
          .read<HistoryProvider>()
          .saveMessage({"sender": "user", "message": message});
      context
          .read<HistoryProvider>()
          .saveMessage({"sender": "assistant", "message": reply});
    } catch (e) {
      error = "Failed to send message";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
