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
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/real_estate_model.dart';
import '../../logic/cubit/real_estate_cubit.dart';
import '../../logic/cubit/real_estate_state.dart';

class CrowdfundingPage extends StatelessWidget {
  const CrowdfundingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RealEstateCubit()
        ..loadProjects()
        ..loadCrowdfundingProjects(),
      child: const _CrowdfundingView(),
    );
  }
}

class _CrowdfundingView extends StatelessWidget {
  const _CrowdfundingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.groupInvestment.tr())),
      body: BlocBuilder<RealEstateCubit, RealEstateState>(
        builder: (context, state) {
          if (state is CrowdfundingLoaded) {
            if (state.projects.isEmpty) {
              return SherikiEmptyState(
                message: StringsConst.noData.tr(),
                icon: Iconsax.people,
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return _CrowdfundingCard(project: project);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _CrowdfundingCard extends StatelessWidget {
  final RealEstateProject project;

  const _CrowdfundingCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      onTap: () => context.go(AppRoutes.projectDetailPath(project.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Unsplash image
          UnsplashImageWidget(
            keyword: _imageKeyword(project.type),
            size: 'small',
            height: 140.h,
            borderRadius: BorderRadius.circular(12.r),
            overlayGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Iconsax.people,
                        color: AppColors.textOnPrimary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        StringsConst.groupInvestment.tr(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    project.title,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          Text(
            project.description,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${project.fundingPercentage.toStringAsFixed(0)}% ${StringsConst.fundedPercentage.tr()}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${project.investorsCount} ${StringsConst.investorsCount.tr()}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: project.fundingPercentage / 100,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringsConst.minInvestment.tr(),
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '${(project.minInvestment / 1000000).toStringAsFixed(1)}M DZD',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SherikiButton(
                text: StringsConst.investNow.tr(),
                width: 140.w,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _imageKeyword(RealEstateType type) {
    switch (type) {
      case RealEstateType.residential:
        return 'luxury residential apartment';
      case RealEstateType.commercial:
        return 'commercial office building';
      case RealEstateType.land:
        return 'land development aerial';
      case RealEstateType.renovation:
        return 'villa renovation architecture';
    }
  }
}
