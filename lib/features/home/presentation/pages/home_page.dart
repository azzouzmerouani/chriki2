import 'package:flutter/material.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 32.h),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringsConst.appName.tr(),
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              final current =
                                  context.locale == const Locale('ar');
                              context.setLocale(
                                current
                                    ? const Locale('fr')
                                    : const Locale('ar'),
                              );
                            },
                            icon: Icon(
                              Iconsax.language_circle,
                              color: AppColors.textOnPrimary,
                              size: 24.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.notification,
                              color: AppColors.textOnPrimary,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    StringsConst.welcomeSubtitle.tr(),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: StringsConst.search.tr(),
                        prefixIcon: const Icon(Iconsax.search_normal),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(StringsConst.getStarted.tr(), style: AppTextStyles.h3),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Iconsax.lamp_on,
                          title: StringsConst.shareYourIdea.tr(),
                          color: AppColors.primary,
                          onTap: () => context.go(AppRoutes.entrepreneur),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Iconsax.search_normal,
                          title: StringsConst.findOpportunity.tr(),
                          color: AppColors.accent,
                          onTap: () => context.go(AppRoutes.investor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Iconsax.building_3,
                          title: StringsConst.realEstate.tr(),
                          color: AppColors.secondary,
                          onTap: () => context.go(AppRoutes.realEstate),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Iconsax.judge,
                          title: StringsConst.legalFinance.tr(),
                          color: AppColors.error,
                          onTap: () => context.go(AppRoutes.legalFinance),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Featured Projects Section
          SliverToBoxAdapter(
            child: SherikiSectionHeader(
              title: StringsConst.activeProjects.tr(),
              actionText: StringsConst.viewAll.tr(),
              onAction: () => context.go(AppRoutes.realEstate),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _FeaturedProjectCard(index: index);
                },
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: StringsConst.activeProjects.tr(),
                      value: '124',
                      icon: Iconsax.folder_open,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      title: StringsConst.investorsCount.tr(),
                      value: '56',
                      icon: Iconsax.people,
                      color: AppColors.accent,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      title: StringsConst.totalFunding.tr(),
                      value: '240M DZD',
                      icon: Iconsax.dollar_circle,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: AppTextStyles.labelMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final int index;

  const _FeaturedProjectCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Smart Farm Tech',
      'Urban Living',
      'EduPlatform',
      'Green Energy',
      'FinTech Hub',
    ];
    final imageKeywords = [
      'smart farm technology',
      'urban apartment building',
      'education platform digital',
      'green energy solar',
      'fintech finance technology',
    ];
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 12.w),
      child: UnsplashImageWidget(
        keyword: imageKeywords[index % imageKeywords.length],
        size: 'regular',
        photoIndex: 0,
        borderRadius: BorderRadius.circular(16.r),
        overlayGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
        ),
        showAttribution: true,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '75% ${StringsConst.fundedPercentage.tr()}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                titles[index % titles.length],
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${(index + 1) * 5}M / ${(index + 1) * 10}M DZD',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 6.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(value, style: AppTextStyles.h4.copyWith(color: color)),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
