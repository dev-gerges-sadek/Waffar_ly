import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/features/chatbot/widgets/chat_input_bar.dart';
import 'package:waffar_ly_app/features/chatbot/widgets/suggested_prompts_bar.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/shared/presentation/widgets/sh_app_bar.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_states.dart';
import '../domain/repositories/chatbot_repository.dart';
import 'widgets/chat_app_bar_title.dart';
import 'widgets/chat_message_list.dart';


class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => ChatbotCubit(
        repository: di<ChatbotRepository>(),
        l10n: l10n,
      ),
      child: const _ChatbotView(),
    );
  }
}

class _ChatbotView extends StatefulWidget {
  const _ChatbotView();

  @override
  State<_ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<_ChatbotView> {
  final _textCtrl   = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    _textCtrl.clear();
    context.read<ChatbotCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: SHColors.background(context),
      appBar: ShBackAppBar(
        title: '',
        trailing: ChatAppBarTitle(
          onClear: () => context.read<ChatbotCubit>().clearChat(),
          clearTooltip: l10n.clearChat,
        ),
      ),
      body: Column(
        children: [
          // ── Message list ───────────────────────────────────────────
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (_, _) => _scrollToBottom(),
              builder: (_, state) => ChatMessageList(
                state: state,
                scrollCtrl: _scrollCtrl,
              ),
            ),
          ),

          // ── Suggested prompts ──────────────────────────────────────
          SuggestedPromptsBar(
            onTap: (p) {
              _textCtrl.text = p;
              _send();
            },
          ),

          SizedBox(height: 6.h),

          // ── Input bar ──────────────────────────────────────────────
          ChatInputBar(
            controller: _textCtrl,
            hintText: l10n.askHome,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}
