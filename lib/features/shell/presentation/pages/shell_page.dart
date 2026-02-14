import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.investor)) return 1;
    if (location.startsWith(AppRoutes.realEstate)) return 2;
    if (location.startsWith(AppRoutes.legalFinance)) return 3;
    if (location.startsWith(AppRoutes.entrepreneur)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => _onTap(context, i),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home, size: 24.sp),
              activeIcon: Icon(Iconsax.home_15, size: 24.sp),
              label: StringsConst.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.trend_up, size: 24.sp),
              activeIcon: Icon(Iconsax.trend_up, size: 24.sp),
              label: StringsConst.investor.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.building_3, size: 24.sp),
              activeIcon: Icon(Iconsax.building_4, size: 24.sp),
              label: StringsConst.realEstate.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.judge, size: 24.sp),
              activeIcon: Icon(Iconsax.judge, size: 24.sp),
              label: StringsConst.legalFinance.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.lamp_on, size: 24.sp),
              activeIcon: Icon(Iconsax.lamp_on, size: 24.sp),
              label: StringsConst.entrepreneur.tr(),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.investor);
        break;
      case 2:
        context.go(AppRoutes.realEstate);
        break;
      case 3:
        context.go(AppRoutes.legalFinance);
        break;
      case 4:
        context.go(AppRoutes.entrepreneur);
        break;
    }
  }
}
