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
import '../../data/models/university_idea_model.dart';

class IncubatorInvestorRequestsPage extends StatelessWidget {
  const IncubatorInvestorRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idea = UniversityIdea(
      id: 'u1',
      title: StringsConst.universityIdea1Title.tr(),
      field: UniversityIdeaField.agriculture,
      problem: StringsConst.universityIdea1Problem.tr(),
      solution: StringsConst.universityIdea1Solution.tr(),
      progress: UniversityIdeaProgress.ideaOnly,
      readiness: InvestmentReadiness.medium,
      incubatorName: StringsConst.universityIdea1Incubator.tr(),
      universityName: StringsConst.universityIdea1University.tr(),
    );

    final requests = [
      (
        investor: StringsConst.incubatorInvestor1Name.tr(),
        status: StringsConst.pending.tr(),
        amount: '12M DZD',
      ),
      (
        investor: StringsConst.incubatorInvestor2Name.tr(),
        status: StringsConst.pending.tr(),
        amount: '8M DZD',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.investorRequests.tr())),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return SherikiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.user_tag,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        request.investor,
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    SherikiStatusBadge(
                      text: request.status,
                      color: AppColors.warning,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${StringsConst.totalInvested.tr()}: ${request.amount}',
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: SherikiButton(
                        text: StringsConst.approved.tr(),
                        backgroundColor: AppColors.success,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                StringsConst.investorInterestNotification.tr(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: SherikiButton(
                        text: StringsConst.rejected.tr(),
                        backgroundColor: AppColors.error,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => context.pushNamed(
                      AppRoutes.universityIdeaNdaName,
                      extra: idea,
                    ),
                    icon: const Icon(Iconsax.document_text),
                    label: Text(StringsConst.ndaTitle.tr()),
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
