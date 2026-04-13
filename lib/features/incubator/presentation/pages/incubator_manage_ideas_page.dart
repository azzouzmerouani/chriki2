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
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/incubator_dummy_data.dart';
import '../../data/models/university_idea_model.dart';

class IncubatorManageIdeasPage extends StatelessWidget {
  const IncubatorManageIdeasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ideas = IncubatorDummyData.projects;

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.manageIdeas.tr())),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.incubatorAddIdea),
        icon: const Icon(Iconsax.add),
        label: Text(StringsConst.addUniversityIdea.tr()),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 88.h),
        itemCount: ideas.length,
        itemBuilder: (context, index) {
          final idea = ideas[index];
          return SherikiCard(
            onTap: () => context.pushNamed(
              AppRoutes.incubatorProjectDetailsName,
              pathParameters: {'id': idea.id},
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140.h,
                  child: UnsplashImageWidget(
                    keyword: idea.imageKeyword,
                    size: 'small',
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(idea.titleKey.tr(), style: AppTextStyles.h4),
                SizedBox(height: 6.h),
                Text(idea.summaryKey.tr(), style: AppTextStyles.bodySmall),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SherikiStatusBadge(
                      text: _fieldLabel(context, idea.field),
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8.w),
                    SherikiStatusBadge(
                      text: idea.readinessKey.tr(),
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  '${StringsConst.statusTracker.tr()}: ${idea.statusKey.tr()}',
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => context.pushNamed(
                      AppRoutes.incubatorProjectDetailsName,
                      pathParameters: {'id': idea.id},
                    ),
                    icon: const Icon(Iconsax.eye),
                    label: Text(StringsConst.projectDetails.tr()),
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
}
