import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ai_provider.dart';
import '../../data/repositories/settings_repository.dart';
import 'ai_vision_service.dart';
import 'gemini_vision_service.dart';
import 'openai_vision_service.dart';
import 'claude_vision_service.dart';

final aiServiceProvider = FutureProvider<AiVisionService?>((ref) async {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final provider = await settingsRepo.getActiveAiProvider();
  final apiKey = await settingsRepo.getApiKey(provider);

  if (apiKey == null || apiKey.isEmpty) return null;

  return AiServiceFactory.create(provider, apiKey);
});

class AiServiceFactory {
  AiServiceFactory._();

  static AiVisionService create(AiProvider provider, String apiKey) {
    switch (provider) {
      case AiProvider.gemini:
        return GeminiVisionService(apiKey: apiKey);
      case AiProvider.openai:
        return OpenAiVisionService(apiKey: apiKey);
      case AiProvider.claude:
        return ClaudeVisionService(apiKey: apiKey);
    }
  }
}
