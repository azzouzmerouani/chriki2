import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/investor_model.dart';
import '../../logic/cubit/investor_cubit.dart';
import '../../logic/cubit/investor_state.dart';

/// Mock one-to-one discussion between the user and an investor.
///
/// Starts with a pre-filled conversation and answers each message the
/// user sends with a canned investor reply after a short typing delay.
class InvestorChatPage extends StatefulWidget {
  final String investorId;

  const InvestorChatPage({super.key, required this.investorId});

  @override
  State<InvestorChatPage> createState() => _InvestorChatPageState();
}

class _InvestorChatPageState extends State<InvestorChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  static const List<String> _autoReplyKeys = [
    StringsConst.investorChatAuto1,
    StringsConst.investorChatAuto2,
    StringsConst.investorChatAuto3,
  ];

  Investor? _investor;
  bool _isTyping = false;
  int _autoReplyIndex = 0;
  Timer? _replyTimer;

  @override
  void initState() {
    super.initState();
    final cubit = InvestorCubit()..loadInvestors();
    final state = cubit.state;
    if (state is InvestorLoaded) {
      final matches = state.investors.where((i) => i.id == widget.investorId);
      _investor = matches.isEmpty ? null : matches.first;
    }
    cubit.close();
    if (_investor != null) _messages.addAll(_mockConversation(_investor!));
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<_ChatMessage> _mockConversation(Investor investor) {
    final now = DateTime.now();
    final sector = investor.interests.isNotEmpty
        ? investor.interests.first
        : '';
    final script = [
      (false, StringsConst.investorChatMsg1, [investor.name]),
      (true, StringsConst.investorChatMsg2, [sector]),
      (false, StringsConst.investorChatMsg3, <String>[]),
      (true, StringsConst.investorChatMsg4, <String>[]),
      (false, StringsConst.investorChatMsg5, <String>[]),
    ];
    return [
      for (var i = 0; i < script.length; i++)
        _ChatMessage(
          isMe: script[i].$1,
          textKey: script[i].$2,
          args: script[i].$3,
          timestamp: now.subtract(Duration(minutes: (script.length - i) * 4)),
        ),
    ];
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(isMe: true, text: text, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            isMe: false,
            textKey: _autoReplyKeys[_autoReplyIndex % _autoReplyKeys.length],
            timestamp: DateTime.now(),
          ),
        );
        _autoReplyIndex++;
        _isTyping = false;
      });
      _scrollToBottom();
    });
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
    final investor = _investor;
    if (investor == null) {
      return Scaffold(
        appBar: AppBar(title: Text(StringsConst.chat.tr())),
        body: SherikiEmptyState(
          message: StringsConst.noData.tr(),
          icon: Iconsax.user_search,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            _InvestorAvatar(name: investor.name),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investor.name,
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _isTyping
                        ? StringsConst.investorChatTyping.tr()
                        : StringsConst.investorChatOnline.tr(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length + 1 + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) return const _DayDivider();
                final messageIndex = index - 1;
                if (messageIndex == _messages.length) {
                  return _TypingBubble(name: investor.name);
                }
                return _MessageBubble(
                  message: _messages[messageIndex],
                  investorName: investor.name,
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
        child: Row(
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
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: StringsConst.typeMessage.tr(),
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
              onTap: _sendMessage,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
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
      ),
    );
  }
}

/// A chat message; mock messages store a translation key so they follow
/// the current language, typed messages store raw [text].
class _ChatMessage {
  final bool isMe;
  final String? text;
  final String? textKey;
  final List<String> args;
  final DateTime timestamp;

  const _ChatMessage({
    required this.isMe,
    this.text,
    this.textKey,
    this.args = const [],
    required this.timestamp,
  });

  String get displayText => text ?? textKey!.tr(args: args);
}

class _InvestorAvatar extends StatelessWidget {
  final String name;
  final double? radius;

  const _InvestorAvatar({required this.name, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 18.r,
      backgroundColor: AppColors.accent.withValues(alpha: 0.15),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.divider.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            StringsConst.investorChatToday.tr(),
            style: AppTextStyles.caption,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final String investorName;

  const _MessageBubble({required this.message, required this.investorName});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _InvestorAvatar(name: investorName, radius: 14.r),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: const Radius.circular(16),
                      topEnd: const Radius.circular(16),
                      bottomStart: Radius.circular(isMe ? 16 : 4),
                      bottomEnd: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.displayText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isMe
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.Hm().format(message.timestamp),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Iconsax.tick_circle,
                        size: 12.sp,
                        color: AppColors.success,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  final String name;

  const _TypingBubble({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          _InvestorAvatar(name: name, radius: 14.r),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '• • •',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
