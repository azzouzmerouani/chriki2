/// Constants for external API integrations.
class ApiConstants {
  ApiConstants._();

  // Unsplash API
  // Replace with your own access key from https://unsplash.com/oauth/applications
  static const String unsplashAccessKey =
      'aflVWSqcZ_oECVuubYlr3Pb4b3MpbQPFkIsPD1qhShk';
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static const String unsplashSearchPhotos = '/search/photos';

  // AI Assistant – Pollinations.ai (free, OpenAI-compatible, no key required)
  static const String aiChatPrimaryUrl = 'https://text.pollinations.ai/openai';
  static const String aiChatFallbackUrl =
      'https://gen.pollinations.ai/v1/chat/completions';
  static const String aiChatModel = 'openai';

  // Optional free key from https://enter.pollinations.ai to lift the
  // anonymous limit (1 reply / 30s per IP). Pass it at build time:
  // flutter run --dart-define=POLLINATIONS_API_KEY=your_key
  static const String aiChatApiKey = String.fromEnvironment(
    'POLLINATIONS_API_KEY',
  );
}
