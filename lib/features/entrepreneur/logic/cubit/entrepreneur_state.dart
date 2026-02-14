import 'package:equatable/equatable.dart';
import '../../data/models/idea_project_model.dart';

abstract class EntrepreneurState extends Equatable {
  const EntrepreneurState();

  @override
  List<Object?> get props => [];
}

class EntrepreneurInitial extends EntrepreneurState {}

class EntrepreneurLoading extends EntrepreneurState {}

class EntrepreneurLoaded extends EntrepreneurState {
  final List<IdeaProject> projects;

  const EntrepreneurLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class EntrepreneurError extends EntrepreneurState {
  final String message;

  const EntrepreneurError(this.message);

  @override
  List<Object?> get props => [message];
}

class EntrepreneurSubmitting extends EntrepreneurState {}

class EntrepreneurSubmitted extends EntrepreneurState {}
