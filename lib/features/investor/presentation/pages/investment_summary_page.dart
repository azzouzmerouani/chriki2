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

class InvestmentSummaryPage extends StatelessWidget {
  const InvestmentSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvestorCubit()
        ..loadInvestors()
        ..loadInvestmentSummary(),
      child: const _InvestmentSummaryView(),
    );
  }
}

class _InvestmentSummaryView extends StatelessWidget {
  const _InvestmentSummaryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.investmentSummary.tr())),
      body: BlocBuilder<InvestorCubit, InvestorState>(
        builder: (context, state) {
          if (state is InvestmentSummaryLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: StringsConst.totalInvested.tr(),
                          value:
                              '${(state.totalInvested / 1000000).toStringAsFixed(1)}M DZD',
                          icon: Iconsax.wallet_3,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _SummaryCard(
                          title: StringsConst.activeProjects.tr(),
                          value: '${state.activeCount}',
                          icon: Iconsax.folder_open,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  SherikiSectionHeader(title: StringsConst.activeProjects.tr()),
                  ...state.records.map((record) {
                    return SherikiCard(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Iconsax.briefcase,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
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
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                  ),
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textOnPrimary, size: 28.sp),
          SizedBox(height: 12.h),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: AppColors.textOnPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
