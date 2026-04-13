import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/university_idea_model.dart';

class UniversityIdeaFormPage extends StatefulWidget {
  const UniversityIdeaFormPage({super.key});

  @override
  State<UniversityIdeaFormPage> createState() => _UniversityIdeaFormPageState();
}

class _UniversityIdeaFormPageState extends State<UniversityIdeaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _universityController = TextEditingController();

  UniversityIdeaField _field = UniversityIdeaField.technology;
  UniversityIdeaProgress _progress = UniversityIdeaProgress.ideaOnly;
  InvestmentReadiness _readiness = InvestmentReadiness.medium;
  bool _hideStudentName = true;
  bool _lockDetails = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.addUniversityIdea.tr())),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            SherikiTextField(
              label: StringsConst.ideaTitle.tr(),
              controller: _titleController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiDropdown<UniversityIdeaField>(
              label: StringsConst.ideaField.tr(),
              value: _field,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _field = value);
                }
              },
              items: UniversityIdeaField.values
                  .map(
                    (field) => DropdownMenuItem(
                      value: field,
                      child: Text(_fieldLabel(field)),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.briefDescription.tr(),
              controller: _descriptionController,
              maxLines: 4,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.problemStatement.tr(),
              controller: _problemController,
              maxLines: 4,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.proposedSolution.tr(),
              controller: _solutionController,
              maxLines: 4,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            SherikiTextField(
              label: StringsConst.universityName.tr(),
              controller: _universityController,
              validator: _required,
            ),
            SizedBox(height: 12.h),
            Text(
              StringsConst.progressStatus.tr(),
              style: AppTextStyles.labelLarge,
            ),
            ...UniversityIdeaProgress.values.map(
              (progress) => RadioListTile<UniversityIdeaProgress>(
                value: progress,
                groupValue: _progress,
                contentPadding: EdgeInsets.zero,
                title: Text(_progressLabel(progress)),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _progress = value);
                  }
                },
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              StringsConst.investmentReadiness.tr(),
              style: AppTextStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: InvestmentReadiness.values.map((readiness) {
                return ChoiceChip(
                  selected: _readiness == readiness,
                  label: Text(_readinessLabel(readiness)),
                  onSelected: (_) => setState(() => _readiness = readiness),
                );
              }).toList(),
            ),
            SizedBox(height: 12.h),
            SherikiCard(
              margin: EdgeInsets.zero,
              color: AppColors.primary.withValues(alpha: 0.06),
              child: Text(
                '${StringsConst.incubatorTag.tr()} ${_universityController.text.isEmpty ? '...' : _universityController.text}',
                style: AppTextStyles.bodyMedium,
              ),
            ),
            SizedBox(height: 12.h),
            CheckboxListTile(
              value: _hideStudentName,
              contentPadding: EdgeInsets.zero,
              title: Text(StringsConst.hideStudentName.tr()),
              onChanged: (value) =>
                  setState(() => _hideStudentName = value ?? true),
            ),
            CheckboxListTile(
              value: _lockDetails,
              contentPadding: EdgeInsets.zero,
              title: Text(StringsConst.lockDetailsUntilApproval.tr()),
              onChanged: (value) =>
                  setState(() => _lockDetails = value ?? true),
            ),
            SizedBox(height: 12.h),
            SherikiButton(
              text: StringsConst.publishIdeaToInvestors.tr(),
              onPressed: _publishIdea,
            ),
          ],
        ),
      ),
    );
  }

  void _publishIdea() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsConst.aiMatchAlertTemplate.tr()),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
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

  String _progressLabel(UniversityIdeaProgress progress) {
    switch (progress) {
      case UniversityIdeaProgress.ideaOnly:
        return StringsConst.ideaOnly.tr();
      case UniversityIdeaProgress.prototype:
        return StringsConst.prototype.tr();
      case UniversityIdeaProgress.readyForExecution:
        return StringsConst.readyProject.tr();
    }
  }

  String _readinessLabel(InvestmentReadiness readiness) {
    switch (readiness) {
      case InvestmentReadiness.low:
        return StringsConst.low.tr();
      case InvestmentReadiness.medium:
        return StringsConst.medium.tr();
      case InvestmentReadiness.high:
        return StringsConst.high.tr();
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConst.errorOccurred.tr();
    }
    return null;
  }
}
