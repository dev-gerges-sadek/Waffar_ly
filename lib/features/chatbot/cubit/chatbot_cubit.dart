import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import 'chatbot_states.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotInitial()) {
    _init();
  }

  final _dio                          = Dio();
  final List<ChatMessage>             _messages = [];
  final List<Map<String, String>>     _history  = [];

  static const _systemPrompt = '''
You are Waffar, a smart home assistant AI. You help users:
1. Control and understand their smart home devices (lights, AC, fans, TV, etc.)
2. Understand their energy consumption data (kWh, watts, volts, amps)
3. Get weather-based comfort recommendations
4. Troubleshoot device issues
5. Explain anomaly alerts

Tone: Friendly, concise, and helpful. Keep responses short (2–4 sentences max).
Always respond in the same language the user writes in (Arabic or English).
Context: The app connects to Firebase Firestore for real-time device data.
Devices include: Lamp_LR_01, Fan_LR_01, TV_LR_01, AC_BR_01, Lamp_BR_01, etc.
''';

  void _init() {
    _messages.clear();
    _history.clear();
    _messages.add(ChatMessage(
      text: 'Hello! I\'m Waffar AI 👋\nAsk me anything about your smart home — devices, energy, weather, or anything else.',
      isUser: false,
      timestamp: DateTime.now(),
    ));
    emit(ChatbotReady(List.unmodifiable(_messages)));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Validate API key before calling
    if (AppConstants.anthropicApiKey == 'YOUR_ANTHROPIC_API_KEY' ||
        AppConstants.anthropicApiKey.isEmpty) {
      _addBotMessage(
        '⚠️ Anthropic API key is not set.\n'
        'Please add your API key in:\nlib/core/constants/app_constants.dart',
      );
      return;
    }

    _messages.add(ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _history.add({'role': 'user', 'content': text.trim()});
    emit(ChatbotTyping(List.unmodifiable(_messages)));

    try {
      final response = await _dio.post(
        'https://api.anthropic.com/v1/messages',
        options: Options(
          headers: {
            'Content-Type':      'application/json',
            'x-api-key':         AppConstants.anthropicApiKey,
            'anthropic-version': '2023-06-01',
          },
          sendTimeout:    const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
        data: {
          'model':      AppConstants.anthropicModel,
          'max_tokens': 512,
          'system':     _systemPrompt,
          'messages':   List<Map<String, String>>.from(_history),
        },
      );

      final reply = response.data['content'][0]['text'] as String;
      _history.add({'role': 'assistant', 'content': reply});
      _addBotMessage(reply);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = status == 401
          ? '🔑 Invalid API key. Check AppConstants.anthropicApiKey.'
          : status == 429
              ? '⏳ Rate limit reached. Please wait a moment.'
              : '📵 Connection error. Check your internet and try again.';
      _addBotMessage(msg);
      emit(ChatbotError(List.unmodifiable(_messages), msg));
    } catch (_) {
      const msg = 'Something went wrong. Please try again.';
      _addBotMessage(msg);
      emit(ChatbotError(List.unmodifiable(_messages), msg));
    }
  }

  void _addBotMessage(String text) {
    _messages.add(ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    emit(ChatbotReady(List.unmodifiable(_messages)));
  }

  void clearChat() {
    _messages.clear();
    _history.clear();
    _init();
  }
}
