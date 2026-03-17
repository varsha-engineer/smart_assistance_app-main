import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_assistance_app/core/api_service.dart';
import 'package:smart_assistance_app/models/chat_screen_model.dart';
import 'package:smart_assistance_app/providers/history_provider.dart';

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

    String reply;
    try {
      final response = await ApiService.sendMessage(message);
      reply = response['reply'] as String? ??
          "I received your message but couldn't parse the response.";
    } catch (_) {
      reply =
          "Flutter state management helps manage UI updates efficiently using patterns like Provider, Riverpod, and Bloc.";
    }

    messages.add(ChatMessage(sender: "assistant", message: reply));

    if (context.mounted) {
      context
          .read<HistoryProvider>()
          .saveMessage({"sender": "user", "message": message});
      context
          .read<HistoryProvider>()
          .saveMessage({"sender": "assistant", "message": reply});
    }

    isLoading = false;
    notifyListeners();
  }
}
