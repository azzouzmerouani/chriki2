import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/incubator_dummy_data.dart';

class IncubatorStudentDetailsPage extends StatelessWidget {
  final String studentId;

  const IncubatorStudentDetailsPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final student = IncubatorDummyData.studentById(studentId);
    final project = IncubatorDummyData.projectById(student.projectId);

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.profile.tr())),
      body: ListView(
        padding: EdgeInsets.only(bottom: 16.h),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                SizedBox(
                  width: 92.w,
                  height: 92.w,
                  child: UnsplashImageWidget(
                    keyword: student.imageKeyword,
                    borderRadius: BorderRadius.circular(48.r),
                    photoIndex: 0,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.nameKey.tr(), style: AppTextStyles.h4),
                      SizedBox(height: 6.h),
                      SherikiStatusBadge(
                        text: student.trackKey.tr(),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SherikiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsConst.projectDetails.tr(), style: AppTextStyles.h4),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 160.h,
                  child: UnsplashImageWidget(
                    keyword: project.imageKeyword,
                    size: 'small',
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(project.titleKey.tr(), style: AppTextStyles.labelLarge),
                SizedBox(height: 6.h),
                Text(project.summaryKey.tr(), style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
