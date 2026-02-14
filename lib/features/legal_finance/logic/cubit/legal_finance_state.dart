import 'package:equatable/equatable.dart';
import '../../data/models/legal_finance_model.dart';

abstract class LegalFinanceState extends Equatable {
  const LegalFinanceState();

  @override
  List<Object?> get props => [];
}

class LegalFinanceInitial extends LegalFinanceState {}

class LegalFinanceLoading extends LegalFinanceState {}

class LegalExpertsLoaded extends LegalFinanceState {
  final List<LegalExpert> experts;

  const LegalExpertsLoaded(this.experts);

  @override
  List<Object?> get props => [experts];
}

class LegalExpertDetailLoaded extends LegalFinanceState {
  final LegalExpert expert;

  const LegalExpertDetailLoaded(this.expert);

  @override
  List<Object?> get props => [expert];
}

class BanksLoaded extends LegalFinanceState {
  final List<Bank> banks;

  const BanksLoaded(this.banks);

  @override
  List<Object?> get props => [banks];
}

class FundingApplicationsLoaded extends LegalFinanceState {
  final List<FundingApplication> applications;

  const FundingApplicationsLoaded(this.applications);

  @override
  List<Object?> get props => [applications];
}

class FundingSubmitting extends LegalFinanceState {}

class FundingSubmitted extends LegalFinanceState {}

class LegalFinanceError extends LegalFinanceState {
  final String message;

  const LegalFinanceError(this.message);

  @override
  List<Object?> get props => [message];
}
