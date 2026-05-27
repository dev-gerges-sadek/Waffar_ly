import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/constants/app_constants.dart';
import 'chatbot_context_source.dart';
import '../../domain/repositories/chatbot_repository.dart';

class ChatbotApiKeyMissingException implements Exception {
  @override
  String toString() => 'Gemini API key not configured.';
}

class ChatbotRepositoryImpl implements ChatbotRepository {
  ChatbotRepositoryImpl({ChatbotContextSource? contextSource})
      : _contextSource = contextSource ?? ChatbotContextSource() {
    _initializeModel();
  }

  final ChatbotContextSource _contextSource;
  late final ChatSession _chat;

  static const _systemInstruction = '''
You are Waffar AI — a compact smart home energy assistant for Waffar Smart Home.
Use only the Firebase context provided, answer in the user's language, and keep responses short.
Focus on:
- device status and recommended actions
- energy consumption, bills, and anomalies
- hardware vs simulation sources
- Egyptian electricity costs in EGP
Only reply to the user's question; do not invent unrelated data.
''';

  @override
  bool get hasApiKey => AppConstants.geminiApiKey != 'YOUR_GEMINI_API_KEY';

  void _initializeModel() {
    final model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: AppConstants.geminiApiKey,
      systemInstruction: Content.system(_systemInstruction),
      generationConfig: const GenerationConfig(
        maxOutputTokens: 250,
        temperature: 0.28,
        topK: 40,
      ),
    );
    _chat = model.startChat(history: []);
  }

  @override
  Future<String> ask(String text) async {
    if (!hasApiKey) {
      throw ChatbotApiKeyMissingException();
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';

    final context = await _contextSource.buildContext();
    final prompt = '''
=== SMART HOME CONTEXT ===
$context

=== USER MESSAGE ===
$trimmed
''';

    final response = await _chat.sendMessage(Content.text(prompt));
    return response.text?.trim() ?? 'No answer from AI.';
  }

  @override
  Future<void> clearSession() async {
    _initializeModel();
  }
}
