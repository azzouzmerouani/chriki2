import 'package:equatable/equatable.dart';

enum AssistantRole { user, assistant }

/// A single message exchanged with the AI assistant.
class AssistantMessage extends Equatable {
  final AssistantRole role;
  final String text;
  final DateTime timestamp;

  const AssistantMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  bool get isUser => role == AssistantRole.user;

  /// OpenAI-compatible representation used by the chat completions API.
  Map<String, String> toApiJson() => {
    'role': isUser ? 'user' : 'assistant',
    'content': text,
  };

  @override
  List<Object?> get props => [role, text, timestamp];
}
