import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/services/ai_plan_service.dart';
import 'gemini_plan_service.dart';
import 'openai_plan_service.dart';

/// Factory class for creating AI Plan Service instances based on configuration
class AiServiceFactory {
  /// Supported AI providers
  static const String providerGemini = 'gemini';
  static const String providerOpenAI = 'openai';

  /// Creates an instance of [AiPlanService] based on the AI_PROVIDER environment variable
  /// 
  /// Defaults to 'openai' if AI_PROVIDER is not set or invalid.
  /// 
  /// Returns:
  /// - [GeminiPlanService] if AI_PROVIDER='gemini'
  /// - [OpenAiPlanService] if AI_PROVIDER='openai' (default)
  /// 
  /// Throws [Exception] if the required API key is missing for the selected provider
  static AiPlanService create() {
    final provider = dotenv.env['AI_PROVIDER']?.toLowerCase().trim() ?? providerOpenAI;

    switch (provider) {
      case providerGemini:
        final apiKey = dotenv.env['GEMINI_API_KEY'];
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception(
            'GEMINI_API_KEY not found in environment variables. '
            'Please set GEMINI_API_KEY in .env file to use Gemini.',
          );
        }
        return GeminiPlanService();

      case providerOpenAI:
        final apiKey = dotenv.env['OPENAI_API_KEY'];
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception(
            'OPENAI_API_KEY not found in environment variables. '
            'Please set OPENAI_API_KEY in .env file to use OpenAI.',
          );
        }
        return OpenAiPlanService();

      default:
        // Default to OpenAI if unknown provider
        // ignore: avoid_print
        print('Warning: Unknown AI_PROVIDER "$provider". Defaulting to OpenAI.');
        final apiKey = dotenv.env['OPENAI_API_KEY'];
        if (apiKey == null || apiKey.isEmpty) {
          throw Exception(
            'OPENAI_API_KEY not found in environment variables. '
            'Please set OPENAI_API_KEY in .env file to use OpenAI.',
          );
        }
        return OpenAiPlanService();
    }
  }

  /// Returns the currently configured provider name
  static String getCurrentProvider() {
    final provider = dotenv.env['AI_PROVIDER']?.toLowerCase().trim() ?? providerOpenAI;
    return provider == providerGemini ? providerGemini : providerOpenAI;
  }

  /// Checks if the required API key is set for the configured provider
  static bool isProviderReady() {
    final provider = getCurrentProvider();
    
    if (provider == providerGemini) {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      return apiKey != null && apiKey.isNotEmpty;
    } else {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      return apiKey != null && apiKey.isNotEmpty;
    }
  }
}

