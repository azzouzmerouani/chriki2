import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/university_idea_model.dart';

enum _AccountMode { createNew, useDemo }

class IncubatorHubPage extends StatefulWidget {
  const IncubatorHubPage({super.key});

  @override
  State<IncubatorHubPage> createState() => _IncubatorHubPageState();
}

class _IncubatorHubPageState extends State<IncubatorHubPage> {
  final _formKey = GlobalKey<FormState>();

  final _incubatorNameController = TextEditingController();
  final _universityNameController = TextEditingController();
  final _stateController = TextEditingController();
  final _officialEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _managerController = TextEditingController();

  _AccountMode _accountMode = _AccountMode.createNew;
  bool _isActivated = false;
  bool _uploadedDecree = false;
  final Set<UniversityIdeaField> _selectedFields = {
    UniversityIdeaField.technology,
  };

  @override
  void dispose() {
    _incubatorNameController.dispose();
    _universityNameController.dispose();
    _stateController.dispose();
    _officialEmailController.dispose();
    _phoneController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _pickDecree() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() => _uploadedDecree = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.incubatorHub.tr())),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SherikiCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsConst.selectAccountMode.tr(),
                  style: AppTextStyles.h4,
                ),
                SizedBox(height: 12.h),
                Text(
                  StringsConst.incubatorHubSubtitle.tr(),
                  style: AppTextStyles.bodySmall,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _ModeCard(
                        icon: Iconsax.add_circle,
                        title: StringsConst.createNewAccount.tr(),
                        subtitle: StringsConst.createNewAccountSubtitle.tr(),
                        selected: _accountMode == _AccountMode.createNew,
                        onTap: () => setState(
                          () => _accountMode = _AccountMode.createNew,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _ModeCard(
                        icon: Iconsax.flash_1,
                        title: StringsConst.useDemoAccount.tr(),
                        subtitle: StringsConst.useDemoAccountSubtitle.tr(),
                        selected: _accountMode == _AccountMode.useDemo,
                        onTap: () =>
                            setState(() => _accountMode = _AccountMode.useDemo),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          if (_accountMode == _AccountMode.createNew)
            _buildRegistrationForm(context),
          if (_accountMode == _AccountMode.useDemo) ...[
            SwitchListTile.adaptive(
              value: _isActivated,
              title: Text(StringsConst.demoActivatedAccount.tr()),
              secondary: const Icon(Iconsax.tick_circle),
              onChanged: (v) => setState(() => _isActivated = v),
            ),
            if (_isActivated) ...[
              SizedBox(height: 8.h),
              _buildDashboard(context),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return SherikiCard(
      margin: EdgeInsets.zero,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringsConst.incubatorRegistration.tr(),
              style: AppTextStyles.h4,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.incubatorName.tr(),
              controller: _incubatorNameController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.universityName.tr(),
              controller: _universityNameController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.stateName.tr(),
              controller: _stateController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.officialEmail.tr(),
              controller: _officialEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.phoneNumber.tr(),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.incubatorManagerName.tr(),
              controller: _managerController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            Text(
              StringsConst.specializations.tr(),
              style: AppTextStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: UniversityIdeaField.values.map((field) {
                final selected = _selectedFields.contains(field);
                return FilterChip(
                  label: Text(_fieldLabel(field)),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectedFields.add(field);
                      } else {
                        _selectedFields.remove(field);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    StringsConst.uploadIncubatorDecree.tr(),
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                SizedBox(width: 12.w),
                SherikiButton(
                  text: StringsConst.uploadDocuments.tr(),
                  width: 120.w,
                  icon: Iconsax.document_upload,
                  onPressed: _pickDecree,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SherikiStatusBadge(
              text: _uploadedDecree
                  ? StringsConst.submit.tr()
                  : StringsConst.pendingIncubatorApproval.tr(),
              color: _uploadedDecree ? AppColors.success : AppColors.error,
            ),
            SizedBox(height: 16.h),
            SherikiButton(
              text: StringsConst.submit.tr(),
              onPressed: _submitRegistration,
            ),
            SizedBox(height: 10.h),
            Text(
              StringsConst.accountUnderReview.tr(),
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final tiles = [
      _DashboardAction(
        icon: Iconsax.folder_2,
        label: StringsConst.manageIdeas.tr(),
        onTap: () => context.push(AppRoutes.incubatorManageIdeas),
      ),
      _DashboardAction(
        icon: Iconsax.profile_2user,
        label: StringsConst.manageStudents.tr(),
        onTap: () => context.push(AppRoutes.incubatorStudents),
      ),
      _DashboardAction(
        icon: Iconsax.user_tag,
        label: StringsConst.investorRequests.tr(),
        onTap: () => context.push(AppRoutes.incubatorInvestorRequests),
      ),
      _DashboardAction(
        icon: Iconsax.chart_2,
        label: StringsConst.statistics.tr(),
        onTap: () => context.push(AppRoutes.incubatorStatistics),
      ),
      _DashboardAction(
        icon: Iconsax.message_circle,
        label: StringsConst.projectChats.tr(),
        onTap: () => context.push(AppRoutes.incubatorChats),
      ),
    ];

    return SherikiCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringsConst.incubatorDashboard.tr(), style: AppTextStyles.h4),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) => tiles[index],
          ),
        ],
      ),
    );
  }

  String _fieldLabel(UniversityIdeaField field) {
    switch (field) {
      case UniversityIdeaField.technology:
        return StringsConst.technology.tr();
      case UniversityIdeaField.agriculture:
        return StringsConst.agriculture.tr();
      case UniversityIdeaField.energies:
        return StringsConst.energies.tr();
      case UniversityIdeaField.healthcare:
        return StringsConst.healthcare.tr();
      case UniversityIdeaField.ai:
        return StringsConst.ai.tr();
      case UniversityIdeaField.industries:
        return StringsConst.industries.tr();
      case UniversityIdeaField.other:
        return StringsConst.other.tr();
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConst.errorOccurred.tr();
    }
    return null;
  }

  void _submitRegistration() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsConst.pendingIncubatorApproval.tr()),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textHint,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }
}
