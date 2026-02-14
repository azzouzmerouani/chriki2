import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/legal_finance_model.dart';
import '../../logic/cubit/legal_finance_cubit.dart';
import '../../logic/cubit/legal_finance_state.dart';

class StatusTrackerPage extends StatelessWidget {
  const StatusTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalFinanceCubit()
        ..loadExperts()
        ..loadApplications(),
      child: const _StatusTrackerView(),
    );
  }
}

class _StatusTrackerView extends StatelessWidget {
  const _StatusTrackerView();

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return AppColors.warning;
      case ApplicationStatus.approved:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.error;
    }
  }

  String _statusLabel(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'pending'.tr();
      case ApplicationStatus.approved:
        return 'approved'.tr();
      case ApplicationStatus.rejected:
        return 'rejected'.tr();
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Iconsax.timer;
      case ApplicationStatus.approved:
        return Iconsax.tick_circle;
      case ApplicationStatus.rejected:
        return Iconsax.close_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('status_tracker'.tr())),
      body: BlocBuilder<LegalFinanceCubit, LegalFinanceState>(
        builder: (context, state) {
          if (state is FundingApplicationsLoaded) {
            if (state.applications.isEmpty) {
              return SherikiEmptyState(
                message: 'no_data'.tr(),
                icon: Iconsax.status,
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.applications.length,
              itemBuilder: (context, index) {
                final app = state.applications[index];
                return _ApplicationCard(
                  application: app,
                  statusColor: _statusColor(app.status),
                  statusLabel: _statusLabel(app.status),
                  statusIcon: _statusIcon(app.status),
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

class _ApplicationCard extends StatelessWidget {
  final FundingApplication application;
  final Color statusColor;
  final String statusLabel;
  final IconData statusIcon;

  const _ApplicationCard({
    required this.application,
    required this.statusColor,
    required this.statusLabel,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(application.bankName, style: AppTextStyles.labelLarge),
                    SizedBox(height: 2.h),
                    Text(
                      'Applied: ${_formatDate(application.appliedAt)}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              SherikiStatusBadge(text: statusLabel, color: statusColor),
            ],
          ),
          SizedBox(height: 12.h),

          // Details
          _DetailRow(
            label: 'Amount',
            value: '${application.amount.toStringAsFixed(0)} DZD',
          ),
          SizedBox(height: 4.h),
          _DetailRow(label: 'Purpose', value: application.purpose),
          if (application.notes != null) ...[
            SizedBox(height: 4.h),
            _DetailRow(label: 'Notes', value: application.notes!),
          ],

          SizedBox(height: 12.h),

          // Progress Timeline
          _StatusTimeline(status: application.status),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(child: Text(value, style: AppTextStyles.bodySmall)),
      ],
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final ApplicationStatus status;

  const _StatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimelineNode(label: 'Submitted', isActive: true, isCompleted: true),
        _TimelineConnector(isActive: status != ApplicationStatus.pending),
        _TimelineNode(
          label: 'Under Review',
          isActive: true,
          isCompleted: status != ApplicationStatus.pending,
        ),
        _TimelineConnector(
          isActive:
              status == ApplicationStatus.approved ||
              status == ApplicationStatus.rejected,
        ),
        _TimelineNode(
          label: status == ApplicationStatus.rejected
              ? 'rejected'.tr()
              : 'approved'.tr(),
          isActive:
              status == ApplicationStatus.approved ||
              status == ApplicationStatus.rejected,
          isCompleted: status == ApplicationStatus.approved,
          isRejected: status == ApplicationStatus.rejected,
        ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isRejected;

  const _TimelineNode({
    required this.label,
    required this.isActive,
    this.isCompleted = false,
    this.isRejected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRejected
        ? AppColors.error
        : isCompleted
        ? AppColors.success
        : isActive
        ? AppColors.warning
        : AppColors.divider;

    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: isActive ? color : AppColors.divider,
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? Icon(Iconsax.tick_square, size: 12.sp, color: Colors.white)
              : isRejected
              ? Icon(Iconsax.close_square, size: 12.sp, color: Colors.white)
              : null,
        ),
        SizedBox(height: 4.h),
        Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool isActive;

  const _TimelineConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(bottom: 18.h),
        color: isActive ? AppColors.success : AppColors.divider,
      ),
    );
  }
}
