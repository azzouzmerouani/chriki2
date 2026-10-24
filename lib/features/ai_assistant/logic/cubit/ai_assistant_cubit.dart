import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings_const.dart';
import '../../data/models/assistant_message.dart';
import '../../data/services/ai_assistant_service.dart';
import 'ai_assistant_state.dart';

/// Manages the AI assistant conversation.
///
/// Provided above the app so the conversation survives closing and
/// reopening the chat screen.
class AiAssistantCubit extends Cubit<AiAssistantState> {
  AiAssistantCubit({AiAssistantService? service})
    : _service = service ?? AiAssistantService.instance,
      super(const AiAssistantState());

  final AiAssistantService _service;

  /// Sends [text] and appends the assistant's reply.
  Future<void> sendMessage(String text, {required String languageCode}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final messages = [
      ...state.messages,
      AssistantMessage(
        role: AssistantRole.user,
        text: trimmed,
        timestamp: DateTime.now(),
      ),
    ];
    emit(state.copyWith(messages: messages, isLoading: true, clearError: true));
    await _requestReply(languageCode);
  }

  /// Retries the last unanswered user message.
  Future<void> retry({required String languageCode}) async {
    if (state.isLoading || state.messages.isEmpty) return;
    if (!state.messages.last.isUser) return;

    emit(state.copyWith(isLoading: true, clearError: true));
    await _requestReply(languageCode);
  }

  /// Starts a new conversation.
  void clearConversation() {
    if (state.isLoading) return;
    emit(const AiAssistantState());
  }

  Future<void> _requestReply(String languageCode) async {
    try {
      final reply = await _service.sendMessage(
        history: state.messages,
        languageCode: languageCode,
      );
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            AssistantMessage(
              role: AssistantRole.assistant,
              text: reply,
              timestamp: DateTime.now(),
            ),
          ],
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorKey: StringsConst.aiAssistantError,
        ),
      );
    }
  }
}
