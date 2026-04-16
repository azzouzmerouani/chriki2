import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/incubator_dummy_data.dart';

class IncubatorChatsPage extends StatelessWidget {
  const IncubatorChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = IncubatorDummyData.projects;

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.projectChats.tr())),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          final students = IncubatorDummyData.students
              .where((s) => s.projectId == project.id)
              .toList();
          final hasActiveChat = index % 2 == 0;

          return SherikiCard(
            onTap: () => context.pushNamed(
              AppRoutes.incubatorChatName,
              pathParameters: {'projectId': project.id},
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.titleKey.tr(),
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    if (hasActiveChat)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              StringsConst.active.tr(),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  project.summaryKey.tr(),
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Iconsax.building_3,
                        size: 16.sp,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        StringsConst.incubator.tr(),
                        style: AppTextStyles.caption,
                      ),
                    ),
                    if (students.isNotEmpty) ...[
                      CircleAvatar(
                        radius: 14.r,
                        backgroundColor: AppColors.secondary,
                        child: Icon(
                          Iconsax.user,
                          size: 16.sp,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${students.length} ${StringsConst.students.tr()}',
                        style: AppTextStyles.caption,
                      ),
                      SizedBox(width: 12.w),
                    ],
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: AppColors.accent,
                      child: Icon(
                        Iconsax.money_2,
                        size: 16.sp,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      StringsConst.investor.tr(),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => context.pushNamed(
                      AppRoutes.incubatorChatName,
                      pathParameters: {'projectId': project.id},
                    ),
                    icon: const Icon(Iconsax.message_circle),
                    label: Text(StringsConst.openChat.tr()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
