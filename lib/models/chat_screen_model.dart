class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      message: json['message'],
    );
  }
}
