// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_states.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatbotCubit(),
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
  final _ctrl       = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
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
    final l10n      = AppLocalizations.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = SHColors.background(context);
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);
    final surface   = isDark
        ? SHColors.darkSurfaceColor
        : SHColors.lightSurfaceColor;
    final cardColor = SHColors.card(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark
            ? SHColors.darkBackgroundColor
            : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.15),
              ),
              child: Icon(Icons.smart_toy_rounded,
                  color: primary, size: 20),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.waffarAI,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  l10n.smartAssist,
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: SHColors.hint(context)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textColor, size: 20),
            onPressed: () => context.read<ChatbotCubit>().clearChat(),
            tooltip: l10n.clearChat,
          ),
          SizedBox(width: 4.w),
        ],
      ),

      body: Column(
        children: [
          // ── Messages list ──────────────────────────────────────────────
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                final messages = switch (state) {
                  ChatbotReady(:final messages)  => messages,
                  ChatbotTyping(:final messages) => messages,
                  ChatbotError(:final messages)  => messages,
                  ChatbotInitial()               => <ChatMessage>[],
                };

                final isTyping = state is ChatbotTyping;

                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (isTyping && i == messages.length) {
                      return _TypingIndicator(cardColor: cardColor);
                    }
                    return _MessageBubble(
                      message:   messages[i],
                      primary:   primary,
                      cardColor: cardColor,
                      textColor: textColor,
                    );
                  },
                );
              },
            ),
          ),

          // ── Suggested prompts ────────────────────────────────────────
          _SuggestedPrompts(
            onTap: (p) {
              _ctrl.text = p;
              _send();
            },
          ),

          // ── Input bar ────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(
                  color: SHColors.hint(context).withOpacity(0.15),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _send(),
                    maxLines: 3,
                    minLines: 1,
                    style:
                        TextStyle(fontSize: 13.sp, color: textColor),
                    decoration: InputDecoration(
                      hintText: l10n.askHome,
                      hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: SHColors.hint(context)),
                      filled: true,
                      fillColor: surface,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message bubble ───────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.primary,
    required this.cardColor,
    required this.textColor,
  });

  final ChatMessage message;
  final Color primary, cardColor, textColor;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundColor: primary.withOpacity(0.15),
              child: Icon(Icons.smart_toy_rounded,
                  color: primary, size: 14),
            ),
            SizedBox(width: 6.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser ? primary : cardColor,
                borderRadius: BorderRadius.only(
                  topLeft:     Radius.circular(16.r),
                  topRight:    Radius.circular(16.r),
                  bottomLeft:  Radius.circular(isUser ? 16.r : 4.r),
                  bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isUser ? Colors.white : textColor,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 6.w),
        ],
      ),
    );
  }
}

// ─── Typing indicator ─────────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.cardColor});
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: primary.withOpacity(0.15),
            child:
                Icon(Icons.smart_toy_rounded, color: primary, size: 14),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _Dot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 7.w,
        height: 7.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SHColors.hint(context),
        ),
      ),
    );
  }
}

// ─── Suggested prompts ────────────────────────────────────────────────────────
class _SuggestedPrompts extends StatelessWidget {
  const _SuggestedPrompts({required this.onTap});
  final void Function(String) onTap;

  static const _prompts = [
    'Which devices are ON?',
    'Which room consumes the most power?',
    'Should I turn on the AC now?',
    'Why is my TV consuming more power?',
  ];

  @override
  Widget build(BuildContext context) {
    final primary = SHColors.primary(context);

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _prompts.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(_prompts[i]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border:
                  Border.all(color: primary.withOpacity(0.40)),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                _prompts[i],
                style: TextStyle(
                  fontSize: 11.sp,
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
