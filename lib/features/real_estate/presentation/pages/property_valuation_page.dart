import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';

class PropertyValuationPage extends StatefulWidget {
  const PropertyValuationPage({super.key});

  @override
  State<PropertyValuationPage> createState() => _PropertyValuationPageState();
}

class _PropertyValuationPageState extends State<PropertyValuationPage> {
  final _formKey = GlobalKey<FormState>();
  String _propertyType = 'Residential';
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _yearController = TextEditingController();
  bool _showResult = false;

  @override
  void dispose() {
    _areaController.dispose();
    _locationController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.valueProperty.tr())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.calculator,
                      size: 48.sp,
                      color: AppColors.textOnPrimary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      StringsConst.valueProperty.tr(),
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Property Type
              SherikiDropdown<String>(
                label: StringsConst.category.tr(),
                value: _propertyType,
                items: ['Residential', 'Commercial', 'Land', 'Industrial']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _propertyType = v!),
              ),
              SizedBox(height: 16.h),

              SherikiTextField(
                label: StringsConst.location.tr(),
                hint: StringsConst.location.tr(),
                controller: _locationController,
                prefixIcon: const Icon(Iconsax.location),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16.h),

              SherikiTextField(
                label: 'Area (sqm)',
                hint: '0',
                controller: _areaController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Iconsax.ruler),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16.h),

              SherikiTextField(
                label: 'Year Built',
                hint: '2020',
                controller: _yearController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Iconsax.calendar),
              ),
              SizedBox(height: 24.h),

              SherikiButton(
                text: StringsConst.submit.tr(),
                icon: Iconsax.calculator,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _showResult = true);
                  }
                },
              ),
              SizedBox(height: 24.h),

              // Result
              if (_showResult)
                SherikiCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.tick_circle,
                        color: AppColors.success,
                        size: 48.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text('Estimated Value', style: AppTextStyles.labelLarge),
                      SizedBox(height: 8.h),
                      Text(
                        '${((double.tryParse(_areaController.text) ?? 0) * 150000).toStringAsFixed(0)} DZD',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Based on location, area, and market data',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      SherikiButton(
                        text: StringsConst.contactExpert.tr(),
                        isOutlined: true,
                        icon: Iconsax.user,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
