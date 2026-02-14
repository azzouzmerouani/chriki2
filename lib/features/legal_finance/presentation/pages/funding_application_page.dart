import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../logic/cubit/legal_finance_cubit.dart';
import '../../logic/cubit/legal_finance_state.dart';

class FundingApplicationPage extends StatefulWidget {
  const FundingApplicationPage({super.key});

  @override
  State<FundingApplicationPage> createState() => _FundingApplicationPageState();
}

class _FundingApplicationPageState extends State<FundingApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Step 1
  final _companyNameController = TextEditingController();
  final _registrationController = TextEditingController();

  // Step 2
  String _selectedBank = 'National Development Bank';
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();

  // Step 3
  final _durationController = TextEditingController();
  String _collateralType = 'Property';

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalFinanceCubit(),
      child: BlocConsumer<LegalFinanceCubit, LegalFinanceState>(
        listener: (context, state) {
          if (state is FundingSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Application submitted successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('apply_funding'.tr())),
            body: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                type: StepperType.vertical,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep++);
                  } else {
                    _submitApplication(context);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: SherikiButton(
                            text: _currentStep == 2
                                ? 'submit'.tr()
                                : 'next'.tr(),
                            isLoading: state is FundingSubmitting,
                            onPressed: details.onStepContinue,
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          SizedBox(width: 12.w),
                          Expanded(
                            child: SherikiButton(
                              text: 'previous'.tr(),
                              isOutlined: true,
                              onPressed: details.onStepCancel,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Company Info
                  Step(
                    title: Text(
                      'step'.tr(namedArgs: {'current': '1', 'total': '3'}),
                    ),
                    subtitle: const Text('Company Information'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        SherikiTextField(
                          label: 'Company Name',
                          hint: 'Enter company name',
                          controller: _companyNameController,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: 'Registration Number',
                          hint: 'CR Number',
                          controller: _registrationController,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),

                  // Step 2: Funding Details
                  Step(
                    title: Text(
                      'step'.tr(namedArgs: {'current': '2', 'total': '3'}),
                    ),
                    subtitle: const Text('Funding Details'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      children: [
                        SherikiDropdown<String>(
                          label: 'Select Bank',
                          value: _selectedBank,
                          items:
                              [
                                    'National Development Bank',
                                    'Gulf Commercial Bank',
                                    'Islamic Finance House',
                                    'Innovation Capital Bank',
                                  ]
                                  .map(
                                    (b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(b),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setState(() => _selectedBank = v!),
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: 'required_capital'.tr(),
                          hint: '0 DZD',
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Iconsax.dollar_circle),
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiTextField(
                          label: 'Purpose',
                          hint: 'Describe the purpose of funding',
                          controller: _purposeController,
                          maxLines: 3,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),

                  // Step 3: Terms
                  Step(
                    title: Text(
                      'step'.tr(namedArgs: {'current': '3', 'total': '3'}),
                    ),
                    subtitle: const Text('Terms & Collateral'),
                    isActive: _currentStep >= 2,
                    content: Column(
                      children: [
                        SherikiTextField(
                          label: 'Requested Duration (months)',
                          hint: '12',
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        SherikiDropdown<String>(
                          label: 'Collateral Type',
                          value: _collateralType,
                          items:
                              [
                                    'Property',
                                    'Equipment',
                                    'Cash Deposit',
                                    'Guarantor',
                                  ]
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) =>
                              setState(() => _collateralType = v!),
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

  void _submitApplication(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LegalFinanceCubit>().submitFundingApplication(
        bankName: _selectedBank,
        amount: double.tryParse(_amountController.text) ?? 0,
        purpose: _purposeController.text,
      );
    }
  }
}
