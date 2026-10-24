import 'package:chriki2/core/constants/strings_const.dart';
import 'package:chriki2/features/ai_assistant/data/models/assistant_message.dart';
import 'package:chriki2/features/ai_assistant/data/services/ai_assistant_service.dart';
import 'package:chriki2/features/ai_assistant/logic/cubit/ai_assistant_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeService implements AiAssistantService {
  bool shouldFail = false;
  String? lastLanguage;
  int calls = 0;

  @override
  Future<String> sendMessage({
    required List<AssistantMessage> history,
    required String languageCode,
  }) async {
    calls++;
    lastLanguage = languageCode;
    if (shouldFail) throw const AiAssistantException('offline');
    return 'reply to ${history.last.text}';
  }
}

void main() {
  late _FakeService service;
  late AiAssistantCubit cubit;

  setUp(() {
    service = _FakeService();
    cubit = AiAssistantCubit(service: service);
  });

  tearDown(() => cubit.close());

  test('appends user message and assistant reply', () async {
    await cubit.sendMessage('  What is ROI?  ', languageCode: 'ar');

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.messages.map((m) => m.text), [
      'What is ROI?',
      'reply to What is ROI?',
    ]);
    expect(cubit.state.messages.last.role, AssistantRole.assistant);
    expect(service.lastLanguage, 'ar');
  });

  test('ignores empty messages', () async {
    await cubit.sendMessage('   ', languageCode: 'fr');

    expect(cubit.state.messages, isEmpty);
    expect(service.calls, 0);
  });

  test('keeps the user message and sets an error on failure', () async {
    service.shouldFail = true;
    await cubit.sendMessage('Hello', languageCode: 'fr');

    expect(cubit.state.messages, hasLength(1));
    expect(cubit.state.errorKey, StringsConst.aiAssistantError);

    service.shouldFail = false;
    await cubit.retry(languageCode: 'fr');

    expect(cubit.state.errorKey, isNull);
    expect(cubit.state.messages, hasLength(2));
  });

  test('clearConversation resets the state', () async {
    await cubit.sendMessage('Hello', languageCode: 'fr');
    cubit.clearConversation();

    expect(cubit.state.messages, isEmpty);
  });
}
