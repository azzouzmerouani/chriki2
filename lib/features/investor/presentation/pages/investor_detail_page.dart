import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../logic/cubit/investor_cubit.dart';
import '../../logic/cubit/investor_state.dart';

class InvestorDetailPage extends StatelessWidget {
  final String investorId;

  const InvestorDetailPage({super.key, required this.investorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvestorCubit()
        ..loadInvestors()
        ..loadInvestorDetail(investorId),
      child: const _InvestorDetailView(),
    );
  }
}

class _InvestorDetailView extends StatelessWidget {
  const _InvestorDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.details.tr())),
      body: BlocBuilder<InvestorCubit, InvestorState>(
        builder: (context, state) {
          if (state is InvestorDetailLoaded) {
            final investor = state.investor;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            investor.name[0],
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(investor.name, style: AppTextStyles.h3),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 16.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              investor.location,
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < investor.rating.floor()
                                  ? Iconsax.star1
                                  : Iconsax.star,
                              color: AppColors.secondary,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Bio
                  Text(investor.bio, style: AppTextStyles.bodyMedium),
                  SizedBox(height: 24.h),

                  // Interests
                  Text(StringsConst.filter.tr(), style: AppTextStyles.h4),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: investor.interests
                        .map((i) => Chip(label: Text(i)))
                        .toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Stats
                  Row(
                    children: [
                      _StatBox(
                        label: StringsConst.totalInvested.tr(),
                        value:
                            '${(investor.totalInvested / 1000000).toStringAsFixed(1)}M DZD',
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12.w),
                      _StatBox(
                        label: StringsConst.activeProjects.tr(),
                        value: '${investor.activeProjects}',
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 12.w),
                      _StatBox(
                        label: StringsConst.rating.tr(),
                        value: investor.rating.toString(),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Investment History
                  Text(
                    StringsConst.investmentSummary.tr(),
                    style: AppTextStyles.h4,
                  ),
                  SizedBox(height: 12.h),
                  ...state.records.map((record) {
                    return SherikiCard(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.projectName,
                                  style: AppTextStyles.labelLarge,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${record.amount.toStringAsFixed(0)} DZD',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          SherikiStatusBadge(
                            text: record.status,
                            color: record.status == 'active'
                                ? AppColors.success
                                : record.status == 'pending'
                                ? AppColors.warning
                                : AppColors.info,
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SherikiButton(
                          text: StringsConst.sendMessage.tr(),
                          icon: Iconsax.message,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: SherikiButton(
                          text: StringsConst.negotiate.tr(),
                          icon: Iconsax.share,
                          isOutlined: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h3.copyWith(color: color)),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
