import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';

class IncubatorStatisticsPage extends StatelessWidget {
  const IncubatorStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Iconsax.lamp_on,
        label: StringsConst.manageIdeas.tr(),
        value: '24',
        color: AppColors.primary,
      ),
      (
        icon: Iconsax.profile_2user,
        label: StringsConst.manageStudents.tr(),
        value: '61',
        color: AppColors.secondary,
      ),
      (
        icon: Iconsax.user_tag,
        label: StringsConst.investorRequests.tr(),
        value: '13',
        color: AppColors.accent,
      ),
      (
        icon: Iconsax.notification,
        label: StringsConst.smartAlerts.tr(),
        value: '7',
        color: AppColors.success,
      ),
    ];

    final monthlyIdeas = [6.0, 8.0, 11.0, 9.0, 13.0, 15.0];
    final investorInterestTrend = [2.0, 4.0, 5.0, 7.0, 6.0, 9.0, 11.0];
    const monthLabels = ['1', '2', '3', '4', '5', '6'];

    return Scaffold(
      appBar: AppBar(title: Text(StringsConst.statistics.tr())),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SizedBox(
            height: 180.h,
            child: UnsplashImageWidget(
              keyword: 'university innovation startup lab',
              size: 'regular',
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 14.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final item = stats[index];
              return SherikiCard(
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: item.color, size: 26.sp),
                    SizedBox(height: 10.h),
                    Text(
                      item.value,
                      style: AppTextStyles.h2.copyWith(color: item.color),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.label,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 14.h),
          SherikiCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsConst.manageIdeas.tr(), style: AppTextStyles.h4),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 170.h,
                  child: _SimpleBarChart(
                    values: monthlyIdeas,
                    labels: monthLabels,
                    barColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SherikiCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsConst.investorRequests.tr(),
                  style: AppTextStyles.h4,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 150.h,
                  child: _SimpleLineChart(
                    values: investorInterestTrend,
                    lineColor: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color barColor;

  const _SimpleBarChart({
    required this.values,
    required this.labels,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        final ratio = maxValue == 0 ? 0 : values[index] / maxValue;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${values[index].toInt()}', style: AppTextStyles.caption),
                SizedBox(height: 6.h),
                Container(
                  height: 90.h * ratio + 8.h,
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(labels[index], style: AppTextStyles.caption),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _SimpleLineChart extends StatelessWidget {
  final List<double> values;
  final Color lineColor;

  const _SimpleLineChart({required this.values, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(values: values, lineColor: lineColor),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;

  _LineChartPainter({required this.values, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final span = (maxValue - minValue).abs() < 0.001
        ? 1.0
        : maxValue - minValue;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final fillPath = Path();
    for (var i = 0; i < values.length; i++) {
      final x = (size.width / (values.length - 1)) * i;
      final y = size.height - ((values[i] - minValue) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
