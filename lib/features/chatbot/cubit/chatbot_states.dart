class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String   text;
  final bool     isUser;
  final DateTime timestamp;
}

sealed class ChatbotState {
  const ChatbotState(this.messages);
  final List<ChatMessage> messages;
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial() : super(const []);
}

/// Messages visible + AI is typing.
class ChatbotTyping extends ChatbotState {
  const ChatbotTyping(super.messages);
}

/// Stable state — normal conversation.
class ChatbotReady extends ChatbotState {
  const ChatbotReady(super.messages);
}

/// Last bot reply errored; previous messages still shown.
class ChatbotError extends ChatbotState {
  const ChatbotError(super.messages, this.error);
  final String error;
}
