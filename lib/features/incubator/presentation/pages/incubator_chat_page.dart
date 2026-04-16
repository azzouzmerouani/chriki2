import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/incubator_dummy_data.dart';

class IncubatorChatPage extends StatefulWidget {
  final String projectId;

  const IncubatorChatPage({super.key, required this.projectId});

  @override
  State<IncubatorChatPage> createState() => _IncubatorChatPageState();
}

class _IncubatorChatPageState extends State<IncubatorChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      senderId: 'student1',
      senderName: StringsConst.students.tr(),
      senderType: _SenderType.student,
      text: StringsConst.chatDemoStudent.tr(),
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _ChatMessage(
      senderId: 'investor1',
      senderName: StringsConst.investor.tr(),
      senderType: _SenderType.investor,
      text: StringsConst.chatDemoInvestor.tr(),
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    _ChatMessage(
      senderId: 'incubator',
      senderName: StringsConst.incubator.tr(),
      senderType: _SenderType.incubator,
      text: StringsConst.chatDemoIncubator.tr(),
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          senderId: 'incubator',
          senderName: 'Incubator',
          senderType: _SenderType.incubator,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
    });
    _messageController.clear();
    _scrollToBottom();
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
    final project = IncubatorDummyData.projectById(widget.projectId);
    final students = IncubatorDummyData.students
        .where((s) => s.projectId == widget.projectId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.titleKey.tr(),
              style: AppTextStyles.labelMedium.copyWith(fontSize: 14.sp),
            ),
            Text(
              '${students.length} ${StringsConst.students.tr()} • ${StringsConst.investor.tr()} • ${StringsConst.incubator.tr()}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderType == _SenderType.incubator;
                final showAvatar =
                    index == 0 ||
                    _messages[index - 1].senderType != message.senderType;

                return _MessageBubble(
                  message: message,
                  isMe: isMe,
                  showAvatar: showAvatar,
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
      padding: EdgeInsets.all(16.w),
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
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: StringsConst.typeMessage.tr(),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
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
    );
  }
}

enum _SenderType { incubator, investor, student }

class _ChatMessage {
  final String senderId;
  final String senderName;
  final _SenderType senderType;
  final String text;
  final DateTime timestamp;

  _ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.text,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isMe;
  final bool showAvatar;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe && showAvatar) ...[
            _Avatar(senderType: message.senderType),
            SizedBox(width: 8.w),
          ],
          if (!isMe && !showAvatar) SizedBox(width: 44.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showAvatar)
                  Text(
                    message.senderName,
                    style: AppTextStyles.caption.copyWith(
                      color: _getSenderColor(message.senderType),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primary
                        : _getSenderColor(
                            message.senderType,
                          ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isMe
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8.w),
            const Icon(Iconsax.check, size: 16, color: AppColors.success),
          ],
        ],
      ),
    );
  }

  Color _getSenderColor(_SenderType type) {
    switch (type) {
      case _SenderType.incubator:
        return AppColors.primary;
      case _SenderType.investor:
        return AppColors.accent;
      case _SenderType.student:
        return AppColors.secondary;
    }
  }
}

class _Avatar extends StatelessWidget {
  final _SenderType senderType;

  const _Avatar({required this.senderType});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: _getSenderColor(senderType),
      child: Icon(
        _getIcon(senderType),
        size: 20.sp,
        color: AppColors.textOnPrimary,
      ),
    );
  }

  IconData _getIcon(_SenderType type) {
    switch (type) {
      case _SenderType.incubator:
        return Iconsax.building_3;
      case _SenderType.investor:
        return Iconsax.money_2;
      case _SenderType.student:
        return Iconsax.user;
    }
  }

  Color _getSenderColor(_SenderType type) {
    switch (type) {
      case _SenderType.incubator:
        return AppColors.primary;
      case _SenderType.investor:
        return AppColors.accent;
      case _SenderType.student:
        return AppColors.secondary;
    }
  }
}

String _formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return 'now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
