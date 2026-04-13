import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../logic/cubit/legal_finance_cubit.dart';
import '../../logic/cubit/legal_finance_state.dart';

class LegalConsultationsPage extends StatelessWidget {
  const LegalConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalFinanceCubit()..loadExperts(),
      child: const _LegalConsultationsView(),
    );
  }
}

class _LegalConsultationsView extends StatelessWidget {
  const _LegalConsultationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConst.legalConsultations.tr()),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.bank),
            onPressed: () => context.go('/legal-finance/banking'),
          ),
          IconButton(
            icon: const Icon(Iconsax.status),
            onPressed: () => context.go('/legal-finance/status-tracker'),
          ),
        ],
      ),
      body: BlocBuilder<LegalFinanceCubit, LegalFinanceState>(
        builder: (context, state) {
          if (state is LegalFinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LegalExpertsLoaded) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.experts.length,
              itemBuilder: (context, index) {
                final expert = state.experts[index];
                return SherikiCard(
                  onTap: () => context.go('/legal-finance/expert/${expert.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              expert.name.tr().substring(0, 1),
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expert.name.tr(),
                                  style: AppTextStyles.labelLarge,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  expert.specialization.tr(),
                                  style: AppTextStyles.bodySmall,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        i < expert.rating.floor()
                                            ? Iconsax.star1
                                            : Iconsax.star,
                                        color: AppColors.secondary,
                                        size: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${expert.rating} (${expert.reviewCount})',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        expert.bio.tr(),
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            '${expert.consultationFee.toStringAsFixed(0)} ${StringsConst.dzdSession.tr()}',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          SherikiButton(
                            text: StringsConst.bookConsultation.tr(),
                            width: 150.w,
                            onPressed: () => context.go(
                              '/legal-finance/expert/${expert.id}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
