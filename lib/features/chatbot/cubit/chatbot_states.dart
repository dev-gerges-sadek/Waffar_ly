class ChatMessage {
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;
}

sealed class ChatbotState {}

class ChatbotInitial extends ChatbotState {}

class ChatbotReady extends ChatbotState {
  ChatbotReady(this.messages);
  final List<ChatMessage> messages;
}

class ChatbotTyping extends ChatbotState {
  ChatbotTyping(this.messages);
  final List<ChatMessage> messages;
}

class ChatbotError extends ChatbotState {
  ChatbotError(this.messages, this.error);
  final List<ChatMessage> messages;
  final String error;
}
