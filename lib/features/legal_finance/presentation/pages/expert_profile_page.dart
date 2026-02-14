import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../logic/cubit/legal_finance_cubit.dart';
import '../../logic/cubit/legal_finance_state.dart';

class ExpertProfilePage extends StatelessWidget {
  final String expertId;

  const ExpertProfilePage({super.key, required this.expertId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalFinanceCubit()
        ..loadExperts()
        ..loadExpertDetail(expertId),
      child: const _ExpertProfileView(),
    );
  }
}

class _ExpertProfileView extends StatelessWidget {
  const _ExpertProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('details'.tr())),
      body: BlocBuilder<LegalFinanceCubit, LegalFinanceState>(
        builder: (context, state) {
          if (state is LegalExpertDetailLoaded) {
            final expert = state.expert;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header
                  CircleAvatar(
                    radius: 48.r,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      expert.name.substring(5, 6),
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(expert.name, style: AppTextStyles.h3),
                  SizedBox(height: 4.h),
                  SherikiStatusBadge(
                    text: expert.specialization,
                    color: AppColors.accent,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < expert.rating.floor()
                              ? Iconsax.star1
                              : Iconsax.star,
                          color: AppColors.secondary,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${expert.rating} (${expert.reviewCount} reviews)',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Bio
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About', style: AppTextStyles.h4),
                        SizedBox(height: 8.h),
                        Text(expert.bio, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Consultation Fee
                  SherikiCard(
                    margin: EdgeInsets.zero,
                    color: AppColors.primary.withValues(alpha: 0.05),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.dollar_circle,
                          color: AppColors.primary,
                          size: 28.sp,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consultation Fee',
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(
                              '${expert.consultationFee.toStringAsFixed(0)} DZD per session',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  SherikiButton(
                    text: 'book_consultation'.tr(),
                    icon: Iconsax.calendar,
                    onPressed: () {},
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: SherikiButton(
                          text: 'chat'.tr(),
                          icon: Iconsax.message,
                          isOutlined: true,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: SherikiButton(
                          text: 'video_call'.tr(),
                          icon: Iconsax.video,
                          isOutlined: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SherikiButton(
                    text: 'voice_call'.tr(),
                    icon: Iconsax.call,
                    isOutlined: true,
                    onPressed: () {},
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
