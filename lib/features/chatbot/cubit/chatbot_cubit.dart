import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../data/chatbot_repository_impl.dart';
import '../domain/repositories/chatbot_repository.dart';
import 'chatbot_states.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit({
    required ChatbotRepository repository,
    required AppLocalizations l10n,
  })  : _repo = repository,
        _l10n = l10n,
        super(const ChatbotInitial());

  final ChatbotRepository _repo;
  final AppLocalizations  _l10n;
  final List<ChatMessage> _messages = [];

  // ── Session init ──────────────────────────────────────────────────────────
  // Called explicitly from the screen after the first build — never in the
  // constructor to avoid AppLocalizations resolution timing issues.

  void startSession() {
    if (_messages.isNotEmpty) return;
    _push(ChatMessage(
      text: _l10n.chatWelcome,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    emit(ChatbotReady(List.unmodifiable(_messages)));
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// [text] is the user's raw input.
  /// [_l10n.isArabic] is forwarded to the repository so the system prompt
  /// and context block are rendered in the correct language before being
  /// sent to the model — guaranteeing Arabic-first responses for Arabic users.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _push(ChatMessage(
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    emit(ChatbotTyping(List.unmodifiable(_messages)));

    try {
      final reply = await _repo.ask(
        trimmed,
        isArabic: _l10n.isArabic,
      );
      _replyWith(reply);
    } on ChatbotApiKeyMissingException {
      _replyWith(_l10n.chatbotApiKeyMissing, isError: true);
    } on ChatbotApiKeyInvalidException {
      _replyWith(_l10n.chatbotApiKeyInvalid, isError: true);
    } on ChatbotRateLimitException {
      _replyWith(_l10n.chatbotRateLimited, isError: true);
    } on ChatbotNetworkException {
      _replyWith(_l10n.chatbotNetworkError, isError: true);
    } on ChatbotEmptyResponseException {
      _replyWith(_l10n.chatbotEmptyResponse, isError: true);
    } on ChatbotApiException catch (e) {
      // Raw server message stays in logs — never surfaced to the user.
      debugPrint('[ChatbotCubit] API error detail: ${e.message}');
      _replyWith(_l10n.chatbotGenericError, isError: true);
    } catch (e) {
      debugPrint('[ChatbotCubit] Unexpected error: $e');
      _replyWith(_l10n.chatbotGenericError, isError: true);
    }
  }

  void clearChat() {
    _messages.clear();
    _repo.clearSession();
    startSession();
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _push(ChatMessage msg) => _messages.add(msg);

  void _replyWith(String text, {bool isError = false}) {
    _push(ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    emit(
      isError
          ? ChatbotError(List.unmodifiable(_messages), text)
          : ChatbotReady(List.unmodifiable(_messages)),
    );
  }
}
