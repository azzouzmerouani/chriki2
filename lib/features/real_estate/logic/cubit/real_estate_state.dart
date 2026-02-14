import 'package:equatable/equatable.dart';
import '../../data/models/real_estate_model.dart';

abstract class RealEstateState extends Equatable {
  const RealEstateState();

  @override
  List<Object?> get props => [];
}

class RealEstateInitial extends RealEstateState {}

class RealEstateLoading extends RealEstateState {}

class RealEstateLoaded extends RealEstateState {
  final List<RealEstateProject> projects;
  final RealEstateType? activeFilter;

  const RealEstateLoaded(this.projects, {this.activeFilter});

  @override
  List<Object?> get props => [projects, activeFilter];
}

class RealEstateProjectDetailLoaded extends RealEstateState {
  final RealEstateProject project;

  const RealEstateProjectDetailLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class CrowdfundingLoaded extends RealEstateState {
  final List<RealEstateProject> projects;

  const CrowdfundingLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ExpertsLoaded extends RealEstateState {
  final List<RealEstateExpert> experts;

  const ExpertsLoaded(this.experts);

  @override
  List<Object?> get props => [experts];
}

class RealEstateError extends RealEstateState {
  final String message;

  const RealEstateError(this.message);

  @override
  List<Object?> get props => [message];
}
