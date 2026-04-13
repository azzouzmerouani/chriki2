import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../incubator/data/models/university_idea_model.dart';

class UniversityIdeaNdaPage extends StatefulWidget {
  final UniversityIdea? idea;

  const UniversityIdeaNdaPage({super.key, this.idea});

  @override
  State<UniversityIdeaNdaPage> createState() => _UniversityIdeaNdaPageState();
}

class _UniversityIdeaNdaPageState extends State<UniversityIdeaNdaPage> {
  bool _agreed = false;
  final _signatureController = TextEditingController();

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idea = widget.idea;

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.ndaTitle.tr())),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SherikiCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsConst.ndaSummary.tr(), style: AppTextStyles.h4),
                SizedBox(height: 12.h),
                _TermItem(text: StringsConst.ndaTermNoCopy.tr()),
                _TermItem(text: StringsConst.ndaTermConfidential.tr()),
                _TermItem(text: StringsConst.ndaTermDuration.tr()),
                _TermItem(text: StringsConst.ndaTermBreach.tr()),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          if (idea != null)
            SherikiCard(
              margin: EdgeInsets.zero,
              color: AppColors.accent.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(idea.title, style: AppTextStyles.labelLarge),
                  SizedBox(height: 8.h),
                  Text(
                    '${StringsConst.problemStatement.tr()}: ${idea.problem}',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${StringsConst.proposedSolution.tr()}: ${idea.solution}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _agreed,
            title: Text(StringsConst.agreeTerms.tr()),
            onChanged: (value) => setState(() => _agreed = value ?? false),
          ),
          SizedBox(height: 10.h),
          SherikiTextField(
            label: StringsConst.electronicSignature.tr(),
            controller: _signatureController,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 16.h),
          SherikiButton(
            text: StringsConst.signAndContinue.tr(),
            onPressed: _canContinue ? _submit : null,
          ),
        ],
      ),
    );
  }

  bool get _canContinue =>
      _agreed && _signatureController.text.trim().isNotEmpty;

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(StringsConst.ndaSignedSuccess.tr()),
        backgroundColor: AppColors.success,
      ),
    );

    context.pushNamed(AppRoutes.universityIdeaChatName, extra: widget.idea);
  }
}

class _TermItem extends StatelessWidget {
  final String text;

  const _TermItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
