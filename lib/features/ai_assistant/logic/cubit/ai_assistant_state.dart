import 'package:equatable/equatable.dart';

import '../../data/models/assistant_message.dart';

/// Conversation state for the AI assistant.
///
/// A single state class is used so messages stay visible while a reply
/// is loading or after an error.
class AiAssistantState extends Equatable {
  final List<AssistantMessage> messages;
  final bool isLoading;

  /// Translation key of the last error, or `null` if none.
  final String? errorKey;

  const AiAssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.errorKey,
  });

  AiAssistantState copyWith({
    List<AssistantMessage>? messages,
    bool? isLoading,
    String? errorKey,
    bool clearError = false,
  }) {
    return AiAssistantState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, errorKey];
}
