abstract class ChatbotRepository {
  Future<String> ask(String text);
  Future<void> clearSession();
  bool get hasApiKey;
}
