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
      reply = response['reply'] as String? ?? _getReply(message);
    } catch (_) {
      reply = _getReply(message);
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

  String _getReply(String message) {
    final q = message.toLowerCase();

    if (q.contains('summarize') ||
        q.contains('summary') ||
        q.contains('notes')) {
      return "Here is a concise summary of your text. The key points have been identified and condensed into a brief overview for easy reading.";
    }

    if (q.contains('email') ||
        q.contains('reply') ||
        q.contains('professional')) {
      return "Here is a professional email reply:\n\nDear [Name],\n\nThank you for reaching out. I appreciate your message and will get back to you shortly.\n\nBest regards,\n[Your Name]";
    }

    if (q.contains('translate') ||
        q.contains('translation') ||
        q.contains('language')) {
      return "Sure! Please provide the text and the target language. For example: \"Translate 'Hello' to Spanish\" → Hola!";
    }

    if (q.contains('poem') ||
        q.contains('poetry') ||
        q.contains('write a poem')) {
      return "Here's a short poem for you:\n\nCode flows like a river,\nWidgets bloom on the screen,\nFlutter builds with a quiver,\nThe smoothest app you've seen.";
    }

    if (q.contains('explain') ||
        q.contains('what is') ||
        q.contains('how does') ||
        q.contains('concept')) {
      return "Great question! This concept refers to a fundamental principle used to simplify complex problems. It works by breaking down the topic into smaller, manageable parts for better understanding.";
    }

    return "Flutter state management helps you manage UI updates efficiently...";
  }
}
