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
import '../../../incubator/data/models/university_idea_model.dart';

class UniversityIdeasPage extends StatelessWidget {
  const UniversityIdeasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ideas = [
      UniversityIdea(
        id: 'u1',
        title: StringsConst.universityIdea1Title.tr(),
        field: UniversityIdeaField.agriculture,
        problem: StringsConst.universityIdea1Problem.tr(),
        solution: StringsConst.universityIdea1Solution.tr(),
        progress: UniversityIdeaProgress.ideaOnly,
        readiness: InvestmentReadiness.medium,
        incubatorName: StringsConst.universityIdea1Incubator.tr(),
        universityName: StringsConst.universityIdea1University.tr(),
      ),
      UniversityIdea(
        id: 'u2',
        title: StringsConst.universityIdea2Title.tr(),
        field: UniversityIdeaField.healthcare,
        problem: StringsConst.universityIdea2Problem.tr(),
        solution: StringsConst.universityIdea2Solution.tr(),
        progress: UniversityIdeaProgress.prototype,
        readiness: InvestmentReadiness.high,
        incubatorName: StringsConst.universityIdea2Incubator.tr(),
        universityName: StringsConst.universityIdea2University.tr(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.universityIdeas.tr())),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: ideas.length,
        itemBuilder: (context, index) {
          final idea = ideas[index];
          return SherikiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.lamp_on,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      StringsConst.universityIdea.tr(),
                      style: AppTextStyles.labelLarge,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(idea.title, style: AppTextStyles.h4),
                SizedBox(height: 6.h),
                Text(
                  '${StringsConst.underIncubatorSupervision.tr()} ${idea.universityName}',
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SherikiStatusBadge(
                      text: _fieldLabel(context, idea.field),
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8.w),
                    SherikiStatusBadge(
                      text: _progressLabel(context, idea.progress),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.lock, color: AppColors.warning, size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          StringsConst.detailsLocked.tr(),
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SherikiButton(
                  text: StringsConst.expressInterest.tr(),
                  icon: Iconsax.send_2,
                  onPressed: () => context.pushNamed(
                    AppRoutes.universityIdeaNdaName,
                    extra: idea,
                  ),
                ),
              ],
            ),
          );
        },
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

  String _progressLabel(BuildContext context, UniversityIdeaProgress progress) {
    switch (progress) {
      case UniversityIdeaProgress.ideaOnly:
        return StringsConst.ideaOnly.tr();
      case UniversityIdeaProgress.prototype:
        return StringsConst.prototype.tr();
      case UniversityIdeaProgress.readyForExecution:
        return StringsConst.readyProject.tr();
    }
  }
}
