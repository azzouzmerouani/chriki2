import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/ai_assistant/logic/cubit/ai_assistant_cubit.dart';
import 'features/ai_assistant/presentation/widgets/floating_assistant_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      startLocale: const Locale('fr'),
      child: const SherikiApp(),
    ),
  );
}

class SherikiApp extends StatelessWidget {
  const SherikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => AiAssistantCubit(),
          child: MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) => FloatingAssistantButton(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
