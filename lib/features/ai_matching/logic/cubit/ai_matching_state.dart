import 'package:equatable/equatable.dart';
import '../../data/models/smart_alert_model.dart';

abstract class AiMatchingState extends Equatable {
  const AiMatchingState();

  @override
  List<Object?> get props => [];
}

class AiMatchingInitial extends AiMatchingState {}

class AiMatchingLoading extends AiMatchingState {}

class AiMatchingLoaded extends AiMatchingState {
  final List<SmartAlert> alerts;
  final int unreadCount;

  const AiMatchingLoaded({required this.alerts, required this.unreadCount});

  @override
  List<Object?> get props => [alerts, unreadCount];
}

class AiMatchingError extends AiMatchingState {
  final String message;

  const AiMatchingError(this.message);

  @override
  List<Object?> get props => [message];
}
