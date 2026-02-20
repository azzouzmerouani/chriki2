import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/onboarding_item.dart';
import '../../logic/cubit/onboarding_cubit.dart';
import '../../logic/cubit/onboarding_state.dart';

/// Full-screen onboarding flow shown on first launch.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
      icon: Iconsax.lamp_charge,
      color: AppColors.primary,
    ),
    OnboardingItem(
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
      icon: Iconsax.chart_square,
      color: AppColors.secondary,
    ),
    OnboardingItem(
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
      icon: Iconsax.building_3,
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(AppRoutes.home);
        } else if (state is OnboardingRequired) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h, right: 16.w, left: 16.w),
                  child: TextButton(
                    onPressed: () =>
                        context.read<OnboardingCubit>().completeOnboarding(),
                    child: Text(
                      StringsConst.onboardingSkip.tr(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (index) =>
                      context.read<OnboardingCubit>().goToPage(index),
                  itemBuilder: (context, index) =>
                      _OnboardingContent(item: _items[index]),
                ),
              ),

              // Dots & controls
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    if (state is! OnboardingRequired) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        // Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _items.length,
                            (i) => _Dot(isActive: i == state.currentPage),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Action button
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () =>
                                context.read<OnboardingCubit>().nextPage(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              state.isLastPage
                                  ? StringsConst.getStarted.tr()
                                  : StringsConst.next.tr(),
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Visual content for a single onboarding page.
class _OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const _OnboardingContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 72.sp, color: item.color),
          ),
          SizedBox(height: 48.h),

          // Title
          Text(
            item.titleKey.tr(),
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),

          // Description
          Text(
            item.descriptionKey.tr(),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Animated dot indicator.
class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 28.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.divider,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
