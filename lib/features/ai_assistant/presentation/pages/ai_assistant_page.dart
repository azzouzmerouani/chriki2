import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/assistant_message.dart';
import '../../logic/cubit/ai_assistant_cubit.dart';
import '../../logic/cubit/ai_assistant_state.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  /// Whether the chat is currently on screen, wherever it was opened from.
  /// The floating assistant button listens to this to hide itself.
  static final ValueNotifier<bool> isOpen = ValueNotifier(false);

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  static const List<String> _suggestionKeys = [
    StringsConst.aiAssistantSuggestion1,
    StringsConst.aiAssistantSuggestion2,
    StringsConst.aiAssistantSuggestion3,
    StringsConst.aiAssistantSuggestion4,
  ];

  @override
  void initState() {
    super.initState();
    AiAssistantPage.isOpen.value = true;
    _scrollToBottom();
  }

  @override
  void dispose() {
    AiAssistantPage.isOpen.value = false;
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final message = text ?? _messageController.text;
    if (message.trim().isEmpty) return;
    context.read<AiAssistantCubit>().sendMessage(
      message,
      languageCode: context.locale.languageCode,
    );
    _messageController.clear();
  }

  void _toggleLanguage() {
    final isArabic = context.locale == const Locale('ar');
    context.setLocale(isArabic ? const Locale('fr') : const Locale('ar'));
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const _AssistantAvatar(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringsConst.aiAssistantTitle.tr(),
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    StringsConst.aiAssistantSubtitle.tr(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: StringsConst.language.tr(),
            onPressed: _toggleLanguage,
            icon: Icon(Iconsax.language_circle, size: 22.sp),
          ),
          IconButton(
            tooltip: StringsConst.aiAssistantNewChat.tr(),
            onPressed: () =>
                context.read<AiAssistantCubit>().clearConversation(),
            icon: Icon(Iconsax.refresh, size: 22.sp),
          ),
        ],
      ),
      body: BlocConsumer<AiAssistantCubit, AiAssistantState>(
        listenWhen: (previous, current) =>
            previous.messages.length != current.messages.length ||
            previous.isLoading != current.isLoading,
        listener: (context, state) => _scrollToBottom(),
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? _buildWelcome()
                    : _buildMessages(state),
              ),
              if (state.errorKey != null) _buildError(state.errorKey!),
              _buildInputArea(state.isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcome() {
    return ListView(
      padding: EdgeInsets.all(24.w),
      children: [
        SizedBox(height: 24.h),
        Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.message_programming,
              color: AppColors.textOnPrimary,
              size: 38.sp,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          StringsConst.aiAssistantWelcomeTitle.tr(),
          style: AppTextStyles.h3,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          StringsConst.aiAssistantWelcomeMessage.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        Text(
          StringsConst.aiAssistantSuggestions.tr(),
          style: AppTextStyles.labelMedium,
        ),
        SizedBox(height: 12.h),
        ..._suggestionKeys.map(
          (key) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _SuggestionTile(
              text: key.tr(),
              onTap: () => _send(key.tr()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessages(AiAssistantState state) {
    final itemCount = state.messages.length + (state.isLoading ? 1 : 0);
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == state.messages.length) return const _TypingBubble();
        return _MessageBubble(message: state.messages[index]);
      },
    );
  }

  Widget _buildError(String errorKey) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: AppColors.error, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              errorKey.tr(),
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => context.read<AiAssistantCubit>().retry(
              languageCode: context.locale.languageCode,
            ),
            child: Text(StringsConst.retry.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringsConst.aiAssistantDisclaimer.tr(),
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: StringsConst.aiAssistantInputHint.tr(),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: isLoading ? null : _send,
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: isLoading ? AppColors.textHint : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.send_2,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Iconsax.message_programming,
        color: AppColors.textOnPrimary,
        size: 18.sp,
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionTile({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.message_question,
                color: AppColors.accent,
                size: 18.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AssistantMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[const _AssistantAvatar(), SizedBox(width: 8.w)],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(StringsConst.aiAssistantCopied.tr())),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(16),
                    topEnd: const Radius.circular(16),
                    bottomStart: Radius.circular(isMe ? 16 : 4),
                    bottomEnd: Radius.circular(isMe ? 4 : 16),
                  ),
                  boxShadow: isMe
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  message.text,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isMe
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AssistantAvatar(),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      // Each dot pulses with a small phase offset.
                      final t = (_controller.value - i * 0.2) % 1.0;
                      final opacity = t < 0.5 ? 0.3 + t * 1.4 : 1.7 - t * 1.4;
                      return Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: child,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
                SizedBox(width: 8.w),
                Text(
                  StringsConst.aiAssistantThinking.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
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
