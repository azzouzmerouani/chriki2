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

class BankingHubPage extends StatelessWidget {
  const BankingHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalFinanceCubit()
        ..loadExperts()
        ..loadBanks(),
      child: const _BankingHubView(),
    );
  }
}

class _BankingHubView extends StatelessWidget {
  const _BankingHubView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.bankingHub.tr())),
      body: BlocBuilder<LegalFinanceCubit, LegalFinanceState>(
        builder: (context, state) {
          if (state is BanksLoaded) {
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.bank,
                        size: 48.sp,
                        color: AppColors.textOnPrimary,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        StringsConst.partnerBanks.tr(),
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${state.banks.length} ${StringsConst.banksAvailable.tr()}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Bank Cards
                ...state.banks.map((bank) {
                  return SherikiCard(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.bank,
                                  color: AppColors.accent,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bank.name.tr(),
                                    style: AppTextStyles.labelLarge,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${StringsConst.rateLabel.tr()}: ${bank.interestRate}%',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          bank.description.tr(),
                          style: AppTextStyles.bodySmall,
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 4.h,
                          children: bank.fundingTypes.map((type) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                type.tr(),
                                style: AppTextStyles.caption,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 12.h),
                        SherikiButton(
                          text: StringsConst.applyNow.tr(),
                          icon: Iconsax.send_1,
                          onPressed: () =>
                              context.go('/legal-finance/apply-funding'),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
