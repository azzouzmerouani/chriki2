import 'package:equatable/equatable.dart';
import '../../data/models/investor_model.dart';

abstract class InvestorState extends Equatable {
  const InvestorState();

  @override
  List<Object?> get props => [];
}

class InvestorInitial extends InvestorState {}

class InvestorLoading extends InvestorState {}

class InvestorLoaded extends InvestorState {
  final List<Investor> investors;
  final String? activeFilter;

  const InvestorLoaded(this.investors, {this.activeFilter});

  @override
  List<Object?> get props => [investors, activeFilter];
}

class InvestorDetailLoaded extends InvestorState {
  final Investor investor;
  final List<InvestmentRecord> records;

  const InvestorDetailLoaded(this.investor, this.records);

  @override
  List<Object?> get props => [investor, records];
}

class InvestmentSummaryLoaded extends InvestorState {
  final List<InvestmentRecord> records;
  final double totalInvested;
  final int activeCount;

  const InvestmentSummaryLoaded({
    required this.records,
    required this.totalInvested,
    required this.activeCount,
  });

  @override
  List<Object?> get props => [records, totalInvested, activeCount];
}

class InvestorError extends InvestorState {
  final String message;

  const InvestorError(this.message);

  @override
  List<Object?> get props => [message];
}
