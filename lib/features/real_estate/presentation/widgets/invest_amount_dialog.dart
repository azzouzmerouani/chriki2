import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/real_estate_model.dart';

/// Shows a dialog to choose how much to invest in [project].
///
/// Returns the confirmed amount in DZD, or `null` if cancelled.
Future<double?> showInvestAmountDialog(
  BuildContext context,
  RealEstateProject project,
) {
  return showDialog<double>(
    context: context,
    builder: (_) => InvestAmountDialog(project: project),
  );
}

/// Formats [amount] as a localized DZD value, e.g. `1 500 000 DZD`.
String formatDzd(BuildContext context, double amount) {
  final formatter = NumberFormat.decimalPattern(context.locale.languageCode);
  return '${formatter.format(amount.round())} DZD';
}

class InvestAmountDialog extends StatefulWidget {
  final RealEstateProject project;

  const InvestAmountDialog({super.key, required this.project});

  @override
  State<InvestAmountDialog> createState() => _InvestAmountDialogState();
}

class _InvestAmountDialogState extends State<InvestAmountDialog> {
  final _amountController = TextEditingController();
  double? _amount;

  RealEstateProject get _project => widget.project;

  double get _maxAmount => math.max(0, _project.remainingFunding);

  /// The minimum can't exceed what is left to raise.
  double get _minAmount => math.min(_project.minInvestment, _maxAmount);

  bool get _isFullyFunded => _maxAmount <= 0;

  List<double> get _quickAmounts {
    final amounts = <double>{
      for (final factor in const [1, 2, 5])
        if (_project.minInvestment * factor <= _maxAmount)
          _project.minInvestment * factor,
      _maxAmount,
    };
    return amounts.toList()..sort();
  }

  String? get _errorText {
    final amount = _amount;
    if (amount == null) return null;
    if (amount < _minAmount) {
      return StringsConst.investAmountTooLow.tr(
        args: [formatDzd(context, _minAmount)],
      );
    }
    if (amount > _maxAmount) {
      return StringsConst.investAmountTooHigh.tr(
        args: [formatDzd(context, _maxAmount)],
      );
    }
    return null;
  }

  bool get _canConfirm => _amount != null && _errorText == null;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(double amount) {
    final text = amount.round().toString();
    _amountController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() => _amount = amount.roundToDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            _buildFundingInfo(),
            SizedBox(height: 20.h),
            if (_isFullyFunded)
              Text(
                StringsConst.investFullyFunded.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                ),
                textAlign: TextAlign.center,
              )
            else ...[
              _buildAmountField(),
              SizedBox(height: 12.h),
              _buildQuickAmounts(),
              if (_canConfirm) ...[SizedBox(height: 16.h), _buildShare()],
            ],
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: SherikiButton(
                    text: StringsConst.cancel.tr(),
                    isOutlined: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SherikiButton(
                    text: StringsConst.investConfirm.tr(),
                    onPressed: _canConfirm
                        ? () => Navigator.of(context).pop(_amount)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Iconsax.wallet_add,
            color: AppColors.primary,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringsConst.investDialogTitle.tr(),
                style: AppTextStyles.h4,
              ),
              Text(
                _project.title,
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFundingInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoItem(
              label: StringsConst.remaining.tr(),
              value: formatDzd(context, _maxAmount),
            ),
          ),
          Container(width: 1, height: 32.h, color: AppColors.divider),
          SizedBox(width: 12.w),
          Expanded(
            child: _InfoItem(
              label: StringsConst.minInvestment.tr(),
              value: formatDzd(context, _project.minInvestment),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
      ],
      onChanged: (value) => setState(() => _amount = double.tryParse(value)),
      style: AppTextStyles.h4,
      decoration: InputDecoration(
        labelText: StringsConst.amountLabel.tr(),
        hintText: StringsConst.investAmountHint.tr(),
        suffixText: 'DZD',
        prefixIcon: const Icon(Iconsax.money_3),
        errorText: _errorText,
        errorMaxLines: 2,
        helperText: _amount != null && _errorText == null
            ? formatDzd(context, _amount!)
            : null,
      ),
    );
  }

  Widget _buildQuickAmounts() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _quickAmounts.map((amount) {
        final isMax = amount == _maxAmount;
        return ChoiceChip(
          label: Text(
            isMax
                ? '${StringsConst.investMax.tr()} · ${formatDzd(context, amount)}'
                : formatDzd(context, amount),
          ),
          selected: _amount == amount.roundToDouble(),
          onSelected: (_) => _setAmount(amount),
          labelStyle: AppTextStyles.caption,
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  Widget _buildShare() {
    final share = _project.totalFunding > 0
        ? _amount! / _project.totalFunding * 100
        : 0.0;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Iconsax.chart_21, color: AppColors.secondaryDark, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              StringsConst.investYourShare.tr(),
              style: AppTextStyles.bodySmall,
            ),
          ),
          Text(
            '${share.toStringAsFixed(share < 1 ? 2 : 1)}%',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.secondaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
