abstract class ChatbotRepository {
  /// [isArabic] drives the system prompt language-detection instruction,
  /// ensuring Arabic users always receive Arabic-first responses regardless
  /// of how the model interprets the message language.
  Future<String> ask(String text, {required bool isArabic});
  Future<void> clearSession();
  bool get hasApiKey;
}
