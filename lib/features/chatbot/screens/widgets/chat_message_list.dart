import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/sh_colors.dart';
import '../../cubit/chatbot_states.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

/// Resolves [ChatbotState] and renders the message list.
/// Typing indicator is appended as the last item when [ChatbotTyping].
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.state,
    required this.scrollCtrl,
  });

  final ChatbotState state;
  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context) {
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final cardColor = SHColors.card(context);

    final messages = state.messages;
    final isTyping = state is ChatbotTyping;
    final itemCount = messages.length + (isTyping ? 1 : 0);

    return ListView.builder(
      controller: scrollCtrl,
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 8.h),
      itemCount: itemCount,
      itemBuilder: (_, i) {
        if (isTyping && i == messages.length) {
          return TypingIndicator(cardColor: cardColor);
        }
        return MessageBubble(
          message: messages[i],
          primaryColor: primary,
          cardColor: cardColor,
          textColor: textColor,
        );
      },
    );
  }
}
