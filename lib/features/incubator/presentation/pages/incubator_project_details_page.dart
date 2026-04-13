import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/incubator_dummy_data.dart';
import '../../data/models/university_idea_model.dart';

class IncubatorProjectDetailsPage extends StatelessWidget {
  final String projectId;

  const IncubatorProjectDetailsPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final project = IncubatorDummyData.projectById(projectId);
    final teamCount = IncubatorDummyData.students
        .where((student) => student.projectId == project.id)
        .length;

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.projectDetails.tr())),
      body: ListView(
        padding: EdgeInsets.only(bottom: 16.h),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              height: 220.h,
              child: UnsplashImageWidget(
                keyword: project.imageKeyword,
                size: 'regular',
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
          SherikiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.titleKey.tr(), style: AppTextStyles.h3),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SherikiStatusBadge(
                      text: _fieldLabel(context, project.field),
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8.w),
                    SherikiStatusBadge(
                      text: project.readinessKey.tr(),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(project.summaryKey.tr(), style: AppTextStyles.bodyMedium),
                SizedBox(height: 12.h),
                Text(
                  '${StringsConst.statusTracker.tr()}: ${project.statusKey.tr()}',
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 6.h),
                Text(
                  '${StringsConst.manageStudents.tr()}: $teamCount',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fieldLabel(BuildContext context, UniversityIdeaField field) {
    switch (field) {
      case UniversityIdeaField.technology:
        return StringsConst.technology.tr();
      case UniversityIdeaField.agriculture:
        return StringsConst.agriculture.tr();
      case UniversityIdeaField.energies:
        return StringsConst.energies.tr();
      case UniversityIdeaField.healthcare:
        return StringsConst.healthcare.tr();
      case UniversityIdeaField.ai:
        return StringsConst.ai.tr();
      case UniversityIdeaField.industries:
        return StringsConst.industries.tr();
      case UniversityIdeaField.other:
        return StringsConst.other.tr();
    }
  }
}
