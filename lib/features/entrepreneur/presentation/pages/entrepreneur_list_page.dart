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
import '../../data/models/idea_project_model.dart';
import '../../logic/cubit/entrepreneur_cubit.dart';
import '../../logic/cubit/entrepreneur_state.dart';

class EntrepreneurListPage extends StatelessWidget {
  const EntrepreneurListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EntrepreneurCubit()..loadProjects(),
      child: const _EntrepreneurListView(),
    );
  }
}

class _EntrepreneurListView extends StatelessWidget {
  const _EntrepreneurListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConst.shareYourIdea.tr()),
        actions: [
          IconButton(icon: const Icon(Iconsax.filter), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.entrepreneurNew),
        icon: const Icon(Iconsax.add),
        label: Text(StringsConst.shareYourIdea.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: BlocBuilder<EntrepreneurCubit, EntrepreneurState>(
        builder: (context, state) {
          if (state is EntrepreneurLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EntrepreneurError) {
            return SherikiEmptyState(
              message: state.message,
              icon: Iconsax.warning_2,
              actionText: StringsConst.retry.tr(),
              onAction: () => context.read<EntrepreneurCubit>().loadProjects(),
            );
          }
          if (state is EntrepreneurLoaded) {
            if (state.projects.isEmpty) {
              return SherikiEmptyState(
                message: StringsConst.noData.tr(),
                icon: Iconsax.lamp_on,
                actionText: StringsConst.shareYourIdea.tr(),
                onAction: () => context.go(AppRoutes.entrepreneurNew),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                return _IdeaProjectCard(project: state.projects[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _IdeaProjectCard extends StatelessWidget {
  final IdeaProject project;

  const _IdeaProjectCard({required this.project});

  String _categoryLabel(ProjectCategory cat) {
    switch (cat) {
      case ProjectCategory.technology:
        return StringsConst.technology.tr();
      case ProjectCategory.agriculture:
        return StringsConst.agriculture.tr();
      case ProjectCategory.realEstate:
        return StringsConst.realEstateCat.tr();
      case ProjectCategory.healthcare:
        return StringsConst.healthcare.tr();
      case ProjectCategory.education:
        return StringsConst.education.tr();
      case ProjectCategory.foodBeverage:
        return StringsConst.foodBeverage.tr();
    }
  }

  Color _statusColor(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.ideaOnly:
        return AppColors.info;
      case ProgressStatus.prototype:
        return AppColors.warning;
      case ProgressStatus.readyProject:
        return AppColors.success;
    }
  }

  String _statusLabel(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.ideaOnly:
        return StringsConst.ideaOnly.tr();
      case ProgressStatus.prototype:
        return StringsConst.prototype.tr();
      case ProgressStatus.readyProject:
        return StringsConst.readyProject.tr();
    }
  }

  IconData _categoryIcon(ProjectCategory cat) {
    switch (cat) {
      case ProjectCategory.technology:
        return Iconsax.monitor;
      case ProjectCategory.agriculture:
        return Iconsax.tree;
      case ProjectCategory.realEstate:
        return Iconsax.building;
      case ProjectCategory.healthcare:
        return Iconsax.health;
      case ProjectCategory.education:
        return Iconsax.teacher;
      case ProjectCategory.foodBeverage:
        return Iconsax.coffee;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _categoryIcon(project.category),
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.ideaTitle, style: AppTextStyles.labelLarge),
                    SizedBox(height: 2.h),
                    Text(project.name, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              SherikiStatusBadge(
                text: _statusLabel(project.progressStatus),
                color: _statusColor(project.progressStatus),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            project.briefDescription,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _InfoChip(
                icon: Iconsax.category,
                label: _categoryLabel(project.category),
              ),
              SizedBox(width: 8.w),
              _InfoChip(
                icon: Iconsax.dollar_circle,
                label:
                    '${(project.requiredCapital / 1000000).toStringAsFixed(1)}M DZD',
              ),
              SizedBox(width: 8.w),
              _InfoChip(
                icon: Iconsax.share,
                label: project.investmentType == InvestmentType.equity
                    ? StringsConst.equity.tr()
                    : StringsConst.loan.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
