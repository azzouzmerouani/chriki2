import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/assistant_message.dart';

/// Thrown when the AI provider cannot produce a reply.
class AiAssistantException implements Exception {
  final String message;

  const AiAssistantException(this.message);

  @override
  String toString() => 'AiAssistantException: $message';
}

/// Talks to the free Pollinations.ai chat completions API.
///
/// Tries the primary endpoint first and falls back to the secondary one
/// if it fails or times out. When the anonymous rate limit is hit, waits
/// for the delay suggested by the API and retries once.
class AiAssistantService {
  AiAssistantService._();

  static final AiAssistantService instance = AiAssistantService._();

  final http.Client _client = http.Client();

  static const Duration _timeout = Duration(seconds: 60);

  /// Longest rate-limit wait we accept before giving up.
  static const int _maxRetryWaitSeconds = 35;

  /// Maximum number of previous messages sent as conversation context.
  static const int _maxHistory = 12;

  static const Map<String, String> _languageNames = {
    'fr': 'French',
    'ar': 'Arabic',
    'en': 'English',
  };

  /// Sends the conversation [history] and returns the assistant's reply.
  ///
  /// [languageCode] is the current app language, used as the default
  /// reply language.
  Future<String> sendMessage({
    required List<AssistantMessage> history,
    required String languageCode,
  }) async {
    final recent = history.length > _maxHistory
        ? history.sublist(history.length - _maxHistory)
        : history;

    final body = json.encode({
      'model': ApiConstants.aiChatModel,
      'messages': [
        {'role': 'system', 'content': _systemPrompt(languageCode)},
        ...recent.map((m) => m.toApiJson()),
      ],
    });

    final headers = {
      'Content-Type': 'application/json',
      if (ApiConstants.aiChatApiKey.isNotEmpty)
        'Authorization': 'Bearer ${ApiConstants.aiChatApiKey}',
    };

    Object? lastError;
    var retriedAfterLimit = false;
    final urls = [
      ApiConstants.aiChatPrimaryUrl,
      ApiConstants.aiChatFallbackUrl,
    ];
    for (var i = 0; i < urls.length; i++) {
      try {
        final response = await _client
            .post(Uri.parse(urls[i]), headers: headers, body: body)
            .timeout(_timeout);
        final responseBody = utf8.decode(response.bodyBytes);

        if (response.statusCode == 200) {
          final reply = _parseReply(responseBody);
          if (reply.isNotEmpty) return reply;
        }

        final waitSeconds = _rateLimitWait(response.statusCode, responseBody);
        if (waitSeconds != null && !retriedAfterLimit) {
          retriedAfterLimit = true;
          await Future<void>.delayed(Duration(seconds: waitSeconds));
          i--; // Retry the same endpoint.
          continue;
        }
        lastError = 'HTTP ${response.statusCode}';
      } catch (e) {
        lastError = e;
      }
    }

    throw AiAssistantException(lastError.toString());
  }

  /// Returns how many seconds to wait if the response is a rate-limit
  /// error with an acceptable delay, otherwise `null`.
  int? _rateLimitWait(int statusCode, String responseBody) {
    if (statusCode != 402 && statusCode != 429) return null;
    final match = RegExp(
      r'Retry after (\d+)\s*s',
      caseSensitive: false,
    ).firstMatch(responseBody);
    final seconds = int.tryParse(match?.group(1) ?? '') ?? 30;
    return seconds <= _maxRetryWaitSeconds ? seconds + 1 : null;
  }

  String _parseReply(String responseBody) {
    final data = json.decode(responseBody) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>? ?? [];
    if (choices.isEmpty) return '';
    final message =
        (choices.first as Map<String, dynamic>)['message']
            as Map<String, dynamic>? ??
        {};
    return _cleanMarkdown(message['content'] as String? ?? '');
  }

  /// The chat UI renders plain text, so strip common Markdown and LaTeX.
  String _cleanMarkdown(String text) {
    return text
        .replaceAllMapped(
          RegExp(r'\\frac\{([^{}]*)\}\{([^{}]*)\}'),
          (m) => '(${m[1]}) / (${m[2]})',
        )
        .replaceAllMapped(
          RegExp(r'\\(?:text|mathrm)\{([^{}]*)\}'),
          (m) => m[1]!,
        )
        .replaceAll(r'\times', '×')
        .replaceAll(r'\%', '%')
        .replaceAll(RegExp(r'\\[\[\]()]'), '')
        .replaceAll(RegExp(r'\*\*|__'), '')
        .replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*[*-]\s+', multiLine: true), '• ')
        .trim();
  }

  String _systemPrompt(String languageCode) {
    final language = _languageNames[languageCode] ?? 'French';
    return '''
You are "Cheriki Assistant", the AI advisor inside Cheriki (Sheriki), an investment and partnership platform in Algeria.
The platform connects entrepreneurs with investors, lists real estate projects with crowdfunding and property valuation, offers legal and financial consultations, banking and funding applications, and links university incubators and student projects with investors.

Your role:
- Answer questions about investing, real estate and property investment, crowdfunding, partnerships, startup funding, valuation, ROI, risks, legal and banking procedures, and how to use the Cheriki app.
- Give practical, clear and concise answers, adapted to the Algerian context (DZD, local regulations, Islamic finance options) when relevant.
- For legal, tax or financial decisions, give general guidance and recommend consulting a qualified expert (available in the app's Legal & Finance section).
- Politely redirect questions unrelated to investment, business or the app.

Language: reply in the same language the user writes in (French, Arabic, Algerian Darija, English, ...). If unclear, reply in $language.
Formatting: plain text only, no Markdown, no LaTeX, no tables. Write formulas inline, e.g. "Yield = annual rent / price × 100". Use short paragraphs and simple "•" bullet points when listing.
''';
  }
}
