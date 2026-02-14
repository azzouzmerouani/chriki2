import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../logic/cubit/real_estate_cubit.dart';
import '../../logic/cubit/real_estate_state.dart';

class ExpertsDirectoryPage extends StatelessWidget {
  const ExpertsDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RealEstateCubit()
        ..loadProjects()
        ..loadExperts(),
      child: const _ExpertsDirectoryView(),
    );
  }
}

class _ExpertsDirectoryView extends StatelessWidget {
  const _ExpertsDirectoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.expertServices.tr())),
      body: BlocBuilder<RealEstateCubit, RealEstateState>(
        builder: (context, state) {
          if (state is ExpertsLoaded) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.experts.length,
              itemBuilder: (context, index) {
                final expert = state.experts[index];
                return SherikiCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          expert.name[0],
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
                            Text(expert.name, style: AppTextStyles.labelLarge),
                            SizedBox(height: 2.h),
                            Text(
                              expert.specialization,
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
                                  '(${expert.reviewCount})',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SherikiButton(
                        text: StringsConst.contactExpert.tr(),
                        width: 100.w,
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
