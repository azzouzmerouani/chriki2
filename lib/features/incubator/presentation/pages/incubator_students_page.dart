import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/incubator_dummy_data.dart';

class IncubatorStudentsPage extends StatelessWidget {
  const IncubatorStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final students = IncubatorDummyData.students;

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.manageStudents.tr())),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          final project = IncubatorDummyData.projectById(student.projectId);
          return SherikiCard(
            onTap: () => context.pushNamed(
              AppRoutes.incubatorStudentDetailsName,
              pathParameters: {'id': student.id},
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: UnsplashImageWidget(
                    keyword: student.imageKeyword,
                    photoIndex: index % 2,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.nameKey.tr(),
                        style: AppTextStyles.labelLarge,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        project.titleKey.tr(),
                        style: AppTextStyles.bodySmall,
                      ),
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
          );
        },
      ),
    );
  }
}
