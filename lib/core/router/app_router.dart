import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_routes.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/logic/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/entrepreneur/presentation/pages/entrepreneur_form_page.dart';
import '../../features/entrepreneur/presentation/pages/entrepreneur_list_page.dart';
import '../../features/investor/presentation/pages/investor_directory_page.dart';
import '../../features/investor/presentation/pages/investment_summary_page.dart';
import '../../features/investor/presentation/pages/investor_detail_page.dart';
import '../../features/investor/presentation/pages/university_idea_nda_page.dart';
import '../../features/investor/presentation/pages/university_idea_chat_page.dart';
import '../../features/investor/presentation/pages/university_ideas_page.dart';
import '../../features/real_estate/presentation/pages/real_estate_map_page.dart';
import '../../features/real_estate/presentation/pages/project_detail_page.dart';
import '../../features/real_estate/presentation/pages/crowdfunding_page.dart';
import '../../features/real_estate/presentation/pages/property_valuation_page.dart';
import '../../features/real_estate/presentation/pages/experts_directory_page.dart';
import '../../features/legal_finance/presentation/pages/legal_consultations_page.dart';
import '../../features/legal_finance/presentation/pages/expert_profile_page.dart';
import '../../features/legal_finance/presentation/pages/banking_hub_page.dart';
import '../../features/legal_finance/presentation/pages/funding_application_page.dart';
import '../../features/legal_finance/presentation/pages/status_tracker_page.dart';
import '../../features/incubator/data/models/university_idea_model.dart';
import '../../features/incubator/presentation/pages/incubator_chat_page.dart';
import '../../features/incubator/presentation/pages/incubator_chats_page.dart';
import '../../features/incubator/presentation/pages/incubator_hub_page.dart';
import '../../features/incubator/presentation/pages/incubator_investor_requests_page.dart';
import '../../features/incubator/presentation/pages/incubator_manage_ideas_page.dart';
import '../../features/incubator/presentation/pages/incubator_project_details_page.dart';
import '../../features/incubator/presentation/pages/incubator_statistics_page.dart';
import '../../features/incubator/presentation/pages/incubator_student_details_page.dart';
import '../../features/incubator/presentation/pages/incubator_students_page.dart';
import '../../features/incubator/presentation/pages/university_idea_form_page.dart';
import '../../features/shell/presentation/pages/shell_page.dart';

class AppRouter {
  AppRouter._();

  static bool? _onboardingCompleted;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Redirects to onboarding if the user hasn't completed it yet.
  static Future<String?> _guardOnboarding(
    BuildContext context,
    GoRouterState state,
  ) async {
    _onboardingCompleted ??= (await SharedPreferences.getInstance()).getBool(
      'onboarding_completed',
    );

    final isCompleted = _onboardingCompleted ?? false;
    final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;

    if (!isCompleted && !isGoingToOnboarding) {
      return AppRoutes.onboarding;
    }
    if (isCompleted && isGoingToOnboarding) {
      return AppRoutes.home;
    }
    return null;
  }

  /// Call this when onboarding finishes so the guard updates.
  static void markOnboardingCompleted() {
    _onboardingCompleted = true;
  }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: _guardOnboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => BlocProvider(
          create: (_) => OnboardingCubit()..checkOnboardingStatus(),
          child: const OnboardingPage(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: AppRoutes.entrepreneur,
            name: AppRoutes.entrepreneurName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: EntrepreneurListPage()),
            routes: [
              GoRoute(
                path: AppRoutes.newSub,
                name: AppRoutes.entrepreneurNewName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const EntrepreneurFormPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.investor,
            name: AppRoutes.investorName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InvestorDirectoryPage()),
            routes: [
              GoRoute(
                path: AppRoutes.summarySub,
                name: AppRoutes.investmentSummaryName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const InvestmentSummaryPage(),
              ),
              GoRoute(
                path: AppRoutes.idSub,
                name: AppRoutes.investorDetailName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) =>
                    InvestorDetailPage(investorId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: AppRoutes.universityIdeasSub,
                name: AppRoutes.universityIdeasName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const UniversityIdeasPage(),
              ),
              GoRoute(
                path: AppRoutes.universityIdeaNdaSub,
                name: AppRoutes.universityIdeaNdaName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final idea = state.extra is UniversityIdea
                      ? state.extra! as UniversityIdea
                      : null;
                  return UniversityIdeaNdaPage(idea: idea);
                },
              ),
              GoRoute(
                path: AppRoutes.universityIdeaChatSub,
                name: AppRoutes.universityIdeaChatName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final idea = state.extra is UniversityIdea
                      ? state.extra! as UniversityIdea
                      : null;
                  return UniversityIdeaChatPage(idea: idea);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.incubator,
            name: AppRoutes.incubatorName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: IncubatorHubPage()),
            routes: [
              GoRoute(
                path: AppRoutes.incubatorAddIdeaSub,
                name: AppRoutes.incubatorAddIdeaName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const UniversityIdeaFormPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorManageIdeasSub,
                name: AppRoutes.incubatorManageIdeasName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const IncubatorManageIdeasPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorProjectDetailsSub,
                name: AppRoutes.incubatorProjectDetailsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => IncubatorProjectDetailsPage(
                  projectId: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                path: AppRoutes.incubatorStudentsSub,
                name: AppRoutes.incubatorStudentsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const IncubatorStudentsPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorStudentDetailsSub,
                name: AppRoutes.incubatorStudentDetailsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => IncubatorStudentDetailsPage(
                  studentId: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                path: AppRoutes.incubatorInvestorRequestsSub,
                name: AppRoutes.incubatorInvestorRequestsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) =>
                    const IncubatorInvestorRequestsPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorStatisticsSub,
                name: AppRoutes.incubatorStatisticsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const IncubatorStatisticsPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorChatsSub,
                name: AppRoutes.incubatorChatsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const IncubatorChatsPage(),
              ),
              GoRoute(
                path: AppRoutes.incubatorChatSub,
                name: AppRoutes.incubatorChatName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => IncubatorChatPage(
                  projectId: state.pathParameters['projectId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.realEstate,
            name: AppRoutes.realEstateName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RealEstateMapPage()),
            routes: [
              GoRoute(
                path: AppRoutes.projectIdSub,
                name: AppRoutes.projectDetailName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) =>
                    ProjectDetailPage(projectId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: AppRoutes.crowdfundingSub,
                name: AppRoutes.crowdfundingName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CrowdfundingPage(),
              ),
              GoRoute(
                path: AppRoutes.valuationSub,
                name: AppRoutes.propertyValuationName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const PropertyValuationPage(),
              ),
              GoRoute(
                path: AppRoutes.expertsSub,
                name: AppRoutes.realEstateExpertsName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ExpertsDirectoryPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.legalFinance,
            name: AppRoutes.legalFinanceName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LegalConsultationsPage()),
            routes: [
              GoRoute(
                path: AppRoutes.expertIdSub,
                name: AppRoutes.expertProfileName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) =>
                    ExpertProfilePage(expertId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: AppRoutes.bankingSub,
                name: AppRoutes.bankingHubName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const BankingHubPage(),
              ),
              GoRoute(
                path: AppRoutes.applyFundingSub,
                name: AppRoutes.applyFundingName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const FundingApplicationPage(),
              ),
              GoRoute(
                path: AppRoutes.statusTrackerSub,
                name: AppRoutes.statusTrackerName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const StatusTrackerPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
