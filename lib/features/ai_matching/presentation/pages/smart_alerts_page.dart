import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/smart_alert_model.dart';
import '../../logic/cubit/ai_matching_cubit.dart';
import '../../logic/cubit/ai_matching_state.dart';

class SmartAlertsPage extends StatelessWidget {
  const SmartAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiMatchingCubit()..loadAlerts(),
      child: const _SmartAlertsView(),
    );
  }
}

class _SmartAlertsView extends StatelessWidget {
  const _SmartAlertsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('smart_alerts'.tr()),
        actions: [
          BlocBuilder<AiMatchingCubit, AiMatchingState>(
            builder: (context, state) {
              if (state is AiMatchingLoaded && state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () =>
                      context.read<AiMatchingCubit>().markAllAsRead(),
                  icon: Icon(
                    Iconsax.tick_circle,
                    color: AppColors.textOnPrimary,
                    size: 18.sp,
                  ),
                  label: Text(
                    'Read All',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<AiMatchingCubit, AiMatchingState>(
        builder: (context, state) {
          if (state is AiMatchingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AiMatchingLoaded) {
            if (state.alerts.isEmpty) {
              return SherikiEmptyState(
                message: 'no_data'.tr(),
                icon: Iconsax.notification_bing,
              );
            }
            return Column(
              children: [
                // Unread count header
                if (state.unreadCount > 0)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: Text(
                      '${state.unreadCount} new matches',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: state.alerts.length,
                    itemBuilder: (context, index) {
                      final alert = state.alerts[index];
                      return _AlertCard(
                        alert: alert,
                        onTap: () => context.read<AiMatchingCubit>().markAsRead(
                          alert.id,
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

class _AlertCard extends StatelessWidget {
  final SmartAlert alert;
  final VoidCallback onTap;

  const _AlertCard({required this.alert, required this.onTap});

  Color _sectorColor(String sector) {
    switch (sector.toLowerCase()) {
      case 'technology':
        return AppColors.accent;
      case 'agriculture':
        return AppColors.success;
      case 'real estate':
        return AppColors.secondary;
      case 'healthcare':
        return AppColors.error;
      case 'education':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _sectorIcon(String sector) {
    switch (sector.toLowerCase()) {
      case 'technology':
        return Iconsax.monitor;
      case 'agriculture':
        return Iconsax.tree;
      case 'real estate':
        return Iconsax.building;
      case 'healthcare':
        return Iconsax.health;
      case 'education':
        return Iconsax.teacher;
      default:
        return Iconsax.lamp_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _sectorColor(alert.sector);

    return SherikiCard(
      onTap: onTap,
      color: alert.isRead
          ? AppColors.card
          : AppColors.primary.withValues(alpha: 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(_sectorIcon(alert.sector), color: color, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!alert.isRead)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        'new_match'.tr(),
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    Text(
                      _timeAgo(alert.matchedAt),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'match_description'.tr(namedArgs: {'sector': alert.sector}),
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Iconsax.briefcase,
                      size: 14.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        alert.projectTitle,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Iconsax.user, size: 14.sp, color: AppColors.textHint),
                    SizedBox(width: 4.w),
                    Text(alert.investorName, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
