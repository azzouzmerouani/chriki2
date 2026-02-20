import 'package:equatable/equatable.dart';

/// States for the onboarding flow.
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Checking if onboarding has been completed before.
class OnboardingChecking extends OnboardingState {
  const OnboardingChecking();
}

/// User has not completed onboarding – show screens.
class OnboardingRequired extends OnboardingState {
  final int currentPage;
  final int totalPages;

  const OnboardingRequired({this.currentPage = 0, required this.totalPages});

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  List<Object?> get props => [currentPage, totalPages];
}

/// Onboarding has been completed – navigate to home.
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
