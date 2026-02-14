import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/idea_project_model.dart';
import '../../logic/cubit/entrepreneur_cubit.dart';
import '../../logic/cubit/entrepreneur_state.dart';

class EntrepreneurFormPage extends StatefulWidget {
  const EntrepreneurFormPage({super.key});

  @override
  State<EntrepreneurFormPage> createState() => _EntrepreneurFormPageState();
}

class _EntrepreneurFormPageState extends State<EntrepreneurFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _problemController = TextEditingController();
  final _capitalController = TextEditingController();

  ProjectCategory? _selectedCategory;
  ProgressStatus _progressStatus = ProgressStatus.ideaOnly;
  InvestmentType _investmentType = InvestmentType.equity;

  final List<String> _imagesPaths = [];
  final List<String> _videosPaths = [];
  final List<String> _documentsPaths = [];

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _problemController.dispose();
    _capitalController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _imagesPaths.addAll(images.map((e) => e.path));
      });
    }
  }

  Future<void> _pickVideos() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videosPaths.add(video.path);
      });
    }
  }

  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _documentsPaths.addAll(result.files.map((f) => f.path ?? ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EntrepreneurCubit(),
      child: BlocConsumer<EntrepreneurCubit, EntrepreneurState>(
        listener: (context, state) {
          if (state is EntrepreneurSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(StringsConst.submit.tr()),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
          if (state is EntrepreneurError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(StringsConst.shareYourIdea.tr())),
            body: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                type: StepperType.vertical,
                physics: const ClampingScrollPhysics(),
                onStepContinue: () {
                  if (_currentStep < 3) {
                    setState(() => _currentStep++);
                  } else {
                    _submitForm(context);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  } else {
                    context.pop();
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: SherikiButton(
                            text: _currentStep == 3
                                ? StringsConst.submit.tr()
                                : StringsConst.next.tr(),
                            isLoading: state is EntrepreneurSubmitting,
                            onPressed: details.onStepContinue,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        if (_currentStep > 0)
                          Expanded(
                            child: SherikiButton(
                              text: StringsConst.previous.tr(),
                              isOutlined: true,
                              onPressed: details.onStepCancel,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Basic Info
                  Step(
                    title: Text(
                      StringsConst.step.tr(
                        namedArgs: {'current': '1', 'total': '4'},
                      ),
                    ),
                    subtitle: Text(StringsConst.name.tr()),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        SherikiTextField(
                          label: StringsConst.name.tr(),
                          hint: StringsConst.name.tr(),
                          controller: _nameController,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: StringsConst.ideaTitle.tr(),
                          hint: StringsConst.ideaTitle.tr(),
                          controller: _titleController,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiDropdown<ProjectCategory>(
                          label: StringsConst.category.tr(),
                          hint: StringsConst.category.tr(),
                          value: _selectedCategory,
                          items: ProjectCategory.values
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(_categoryLabel(c)),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v),
                        ),
                      ],
                    ),
                  ),

                  // Step 2: Description
                  Step(
                    title: Text(
                      StringsConst.step.tr(
                        namedArgs: {'current': '2', 'total': '4'},
                      ),
                    ),
                    subtitle: Text(StringsConst.briefDescription.tr()),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        SherikiTextField(
                          label: StringsConst.briefDescription.tr(),
                          hint: StringsConst.briefDescription.tr(),
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: StringsConst.problemStatement.tr(),
                          hint: StringsConst.problemStatement.tr(),
                          controller: _problemController,
                          maxLines: 4,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),

                  // Step 3: Progress & Investment
                  Step(
                    title: Text(
                      StringsConst.step.tr(
                        namedArgs: {'current': '3', 'total': '4'},
                      ),
                    ),
                    subtitle: Text(StringsConst.investmentType.tr()),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringsConst.progressStatus.tr(),
                          style: AppTextStyles.labelLarge,
                        ),
                        SizedBox(height: 8.h),
                        ...ProgressStatus.values.map((s) {
                          return RadioListTile<ProgressStatus>(
                            title: Text(_statusLabel(s)),
                            value: s,
                            groupValue: _progressStatus,
                            onChanged: (v) =>
                                setState(() => _progressStatus = v!),
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                          );
                        }),
                        SizedBox(height: 16.h),
                        Text(
                          StringsConst.investmentType.tr(),
                          style: AppTextStyles.labelLarge,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: _SelectionChip(
                                label: StringsConst.equity.tr(),
                                isSelected:
                                    _investmentType == InvestmentType.equity,
                                onTap: () => setState(
                                  () => _investmentType = InvestmentType.equity,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _SelectionChip(
                                label: StringsConst.loan.tr(),
                                isSelected:
                                    _investmentType == InvestmentType.loan,
                                onTap: () => setState(
                                  () => _investmentType = InvestmentType.loan,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: StringsConst.requiredCapital.tr(),
                          hint: '0 DZD',
                          controller: _capitalController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Iconsax.dollar_circle),
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),

                  // Step 4: Media
                  Step(
                    title: Text(
                      StringsConst.step.tr(
                        namedArgs: {'current': '4', 'total': '4'},
                      ),
                    ),
                    subtitle: Text(StringsConst.uploadImages.tr()),
                    isActive: _currentStep >= 3,
                    state: _currentStep > 3
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        _MediaPickerRow(
                          icon: Iconsax.image,
                          label: StringsConst.uploadImages.tr(),
                          count: _imagesPaths.length,
                          onTap: _pickImages,
                        ),
                        SizedBox(height: 12.h),
                        _MediaPickerRow(
                          icon: Iconsax.video,
                          label: StringsConst.uploadVideos.tr(),
                          count: _videosPaths.length,
                          onTap: _pickVideos,
                        ),
                        SizedBox(height: 12.h),
                        _MediaPickerRow(
                          icon: Iconsax.document,
                          label: StringsConst.uploadDocuments.tr(),
                          count: _documentsPaths.length,
                          onTap: _pickDocuments,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null) return;
      context.read<EntrepreneurCubit>().submitProject(
        name: _nameController.text,
        ideaTitle: _titleController.text,
        category: _selectedCategory!,
        briefDescription: _descriptionController.text,
        problemStatement: _problemController.text,
        progressStatus: _progressStatus,
        investmentType: _investmentType,
        requiredCapital: double.tryParse(_capitalController.text) ?? 0,
        imagesPaths: _imagesPaths,
        videosPaths: _videosPaths,
        documentsPaths: _documentsPaths,
      );
    }
  }

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
}

class _SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaPickerRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _MediaPickerRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            if (count > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            SizedBox(width: 8.w),
            Icon(Iconsax.arrow_right_3, color: AppColors.textHint, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
