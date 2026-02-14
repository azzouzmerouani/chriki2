import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/investor_model.dart';
import '../../logic/cubit/investor_cubit.dart';
import '../../logic/cubit/investor_state.dart';

class InvestorDirectoryPage extends StatelessWidget {
  const InvestorDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvestorCubit()..loadInvestors(),
      child: const _InvestorDirectoryView(),
    );
  }
}

class _InvestorDirectoryView extends StatelessWidget {
  const _InvestorDirectoryView();

  static const _filters = [
    'Technology',
    'Agriculture',
    'Real Estate',
    'Healthcare',
    'Education',
    'Food & Beverage',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConst.investorDirectory.tr()),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.chart),
            onPressed: () => context.go(AppRoutes.investorSummary),
          ),
        ],
      ),
      body: BlocBuilder<InvestorCubit, InvestorState>(
        builder: (context, state) {
          if (state is InvestorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InvestorError) {
            return SherikiEmptyState(
              message: state.message,
              icon: Iconsax.warning_2,
              actionText: StringsConst.retry.tr(),
              onAction: () => context.read<InvestorCubit>().loadInvestors(),
            );
          }
          if (state is InvestorLoaded) {
            return Column(
              children: [
                // Filter chips
                SizedBox(
                  height: 50.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          label: Text(StringsConst.viewAll.tr()),
                          selected: state.activeFilter == null,
                          onSelected: (_) => context
                              .read<InvestorCubit>()
                              .filterByInterest(null),
                          selectedColor: AppColors.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      ..._filters.map((f) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: FilterChip(
                            label: Text(f),
                            selected: state.activeFilter == f,
                            onSelected: (_) => context
                                .read<InvestorCubit>()
                                .filterByInterest(f),
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Investor list
                Expanded(
                  child: state.investors.isEmpty
                      ? SherikiEmptyState(
                          message: StringsConst.noData.tr(),
                          icon: Iconsax.people,
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 16.h),
                          itemCount: state.investors.length,
                          itemBuilder: (context, index) {
                            return _InvestorCard(
                              investor: state.investors[index],
                              onTap: () => context.go(
                                AppRoutes.investorDetailPath(
                                  state.investors[index].id,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InvestorCard extends StatelessWidget {
  final Investor investor;
  final VoidCallback onTap;

  const _InvestorCard({required this.investor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  investor.name[0],
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(investor.name, style: AppTextStyles.labelLarge),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 14.sp,
                          color: AppColors.textHint,
                        ),
                        SizedBox(width: 4.w),
                        Text(investor.location, style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.star1,
                      size: 14.sp,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      investor.rating.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            investor.bio,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: investor.interests.map((i) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  i,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: StringsConst.totalInvested.tr(),
                  value:
                      '${(investor.totalInvested / 1000000).toStringAsFixed(1)}M DZD',
                ),
              ),
              Expanded(
                child: _MetricTile(
                  label: StringsConst.activeProjects.tr(),
                  value: '${investor.activeProjects}',
                ),
              ),
              SizedBox(
                width: 100.w,
                child: SherikiButton(
                  text: StringsConst.sendMessage.tr(),
                  onPressed: () {},
                  backgroundColor: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
