import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/real_estate_model.dart';
import '../../logic/cubit/real_estate_cubit.dart';
import '../../logic/cubit/real_estate_state.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RealEstateCubit()
        ..loadProjects()
        ..loadProjectDetail(projectId),
      child: const _ProjectDetailView(),
    );
  }
}

class _ProjectDetailView extends StatelessWidget {
  const _ProjectDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RealEstateCubit, RealEstateState>(
        builder: (context, state) {
          if (state is RealEstateProjectDetailLoaded) {
            final project = state.project;
            return CustomScrollView(
              slivers: [
                // App Bar with gradient
                SliverAppBar(
                  expandedHeight: 200.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(project.title),
                    background: UnsplashImageWidget(
                      keyword: _imageKeyword(project.type),
                      size: 'regular',
                      overlayGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                project.address,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Description
                        Text(
                          StringsConst.details.tr(),
                          style: AppTextStyles.h4,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          project.description,
                          style: AppTextStyles.bodyMedium,
                        ),
                        SizedBox(height: 24.h),

                        // Funding Progress
                        Text(
                          StringsConst.totalFunding.tr(),
                          style: AppTextStyles.h4,
                        ),
                        SizedBox(height: 12.h),
                        _FundingProgressCard(project: project),
                        SizedBox(height: 24.h),

                        // Stats Grid
                        Row(
                          children: [
                            _DetailStat(
                              label: StringsConst.investorsCount.tr(),
                              value: '${project.investorsCount}',
                              icon: Iconsax.people,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 12.w),
                            _DetailStat(
                              label: StringsConst.minInvestment.tr(),
                              value:
                                  '${(project.minInvestment / 1000000).toStringAsFixed(1)}M DZD',
                              icon: Iconsax.dollar_circle,
                              color: AppColors.success,
                            ),
                            SizedBox(width: 12.w),
                            _DetailStat(
                              label: StringsConst.remaining.tr(),
                              value:
                                  '${(project.remainingFunding / 1000000).toStringAsFixed(0)}M DZD',
                              icon: Iconsax.timer,
                              color: AppColors.warning,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Gallery placeholder
                        Text(
                          StringsConst.gallery.tr(),
                          style: AppTextStyles.h4,
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 120.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 160.w,
                                margin: EdgeInsets.only(right: 12.w),
                                child: UnsplashImageWidget(
                                  keyword: _imageKeyword(project.type),
                                  size: 'small',
                                  photoIndex: index,
                                  borderRadius: BorderRadius.circular(12.r),
                                  showAttribution: true,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // BMC Viewer
                        if (project.bmcData != null) ...[
                          Text(
                            StringsConst.businessModel.tr(),
                            style: AppTextStyles.h4,
                          ),
                          SizedBox(height: 12.h),
                          SherikiCard(
                            margin: EdgeInsets.zero,
                            child: Text(
                              project.bmcData!,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        // Action Button
                        SherikiButton(
                          text: StringsConst.investNow.tr(),
                          icon: Iconsax.trend_up,
                          onPressed: () {},
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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

class _FundingProgressCard extends StatelessWidget {
  final RealEstateProject project;

  const _FundingProgressCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(project.currentFunding / 1000000).toStringAsFixed(0)}M DZD',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              Text(
                '${project.fundingPercentage.toStringAsFixed(0)}%',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: project.fundingPercentage / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${StringsConst.fundedPercentage.tr()}: ${(project.currentFunding / 1000000).toStringAsFixed(0)}M DZD',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                ),
              ),
              Text(
                '${StringsConst.totalFunding.tr()}: ${(project.totalFunding / 1000000).toStringAsFixed(0)}M DZD',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DetailStat({
    required this.label,
    required this.value,
    required this.icon,
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
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 6.h),
            Text(value, style: AppTextStyles.labelLarge.copyWith(color: color)),
            SizedBox(height: 2.h),
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
