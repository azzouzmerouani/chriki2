import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_router.dart';
import 'onboarding_state.dart';

/// Manages the onboarding flow state and persists completion.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingChecking());

  static const String _onboardingKey = 'onboarding_completed';
  static const int _totalPages = 3;

  /// Checks whether onboarding was previously completed.
  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool(_onboardingKey) ?? false;

    if (isCompleted) {
      emit(const OnboardingCompleted());
    } else {
      emit(const OnboardingRequired(totalPages: _totalPages));
    }
  }

  /// Updates the current page index.
  void goToPage(int page) {
    emit(OnboardingRequired(currentPage: page, totalPages: _totalPages));
  }

  /// Advances to the next page, or completes onboarding on the last page.
  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is OnboardingRequired) {
      if (currentState.isLastPage) {
        await completeOnboarding();
      } else {
        emit(
          OnboardingRequired(
            currentPage: currentState.currentPage + 1,
            totalPages: _totalPages,
          ),
        );
      }
    }
  }

  /// Marks onboarding as completed and persists the preference.
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    AppRouter.markOnboardingCompleted();
    emit(const OnboardingCompleted());
  }
}
