import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../incubator/data/models/university_idea_model.dart';

enum _SenderRole { investor, incubator, student }

class _ChatMessage {
  final _SenderRole role;
  final String senderName;
  final String message;
  final String time;

  const _ChatMessage({
    required this.role,
    required this.senderName,
    required this.message,
    required this.time,
  });
}

class UniversityIdeaChatPage extends StatelessWidget {
  final UniversityIdea? idea;

  const UniversityIdeaChatPage({super.key, this.idea});

  @override
  Widget build(BuildContext context) {
    final chatMessages = <_ChatMessage>[
      const _ChatMessage(
        role: _SenderRole.incubator,
        senderName: 'الحاضنة',
        message: 'مرحباً، تم قبول طلب الاطلاع بعد توقيع NDA.',
        time: '09:10',
      ),
      const _ChatMessage(
        role: _SenderRole.investor,
        senderName: 'المستثمر',
        message: 'شكراً لكم، أود معرفة تفاصيل النموذج الأولي وخطة التنفيذ.',
        time: '09:12',
      ),
      const _ChatMessage(
        role: _SenderRole.student,
        senderName: 'الطالب',
        message: 'أهلاً، النموذج الأولي جاهز بنسبة 70% ويمكن عرضه هذا الأسبوع.',
        time: '09:14',
      ),
      const _ChatMessage(
        role: _SenderRole.incubator,
        senderName: 'الحاضنة',
        message: 'ممتاز، سنشارك وثائق المشروع وجدول الاحتضان اليوم.',
        time: '09:16',
      ),
      const _ChatMessage(
        role: _SenderRole.investor,
        senderName: 'المستثمر',
        message: 'مناسب جداً، أنا مهتم بالدخول في مرحلة التقييم الاستثماري.',
        time: '09:18',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.chat.tr())),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: SherikiCard(
              margin: EdgeInsets.zero,
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea?.title ?? StringsConst.universityIdea.tr(),
                    style: AppTextStyles.labelLarge,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'دردشة ثلاثية: المستثمر + الحاضنة + الطالب',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final item = chatMessages[index];
                final isInvestor = item.role == _SenderRole.investor;
                final bubbleColor = switch (item.role) {
                  _SenderRole.investor => AppColors.primary,
                  _SenderRole.incubator => AppColors.accent,
                  _SenderRole.student => AppColors.secondary,
                };

                return Align(
                  alignment: isInvestor
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 0.82.sw),
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: bubbleColor.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.senderName,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: bubbleColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(item.message, style: AppTextStyles.bodySmall),
                        SizedBox(height: 4.h),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(item.time, style: AppTextStyles.caption),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
