import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constants.dart';
import '../../data/models/food_analysis.dart';
import 'ai_vision_service.dart';

class GeminiVisionService implements AiVisionService {
  final String apiKey;

  GeminiVisionService({required this.apiKey});

  @override
  String get providerName => 'gemini';

  @override
  Future<FoodAnalysis> analyzeFood(Uint8List imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );

    final content = Content.multi([
      TextPart(AppConstants.foodAnalysisPrompt),
      DataPart('image/jpeg', imageBytes),
    ]);

    final response = await model.generateContent([content]);
    final text = response.text;

    if (text == null || text.isEmpty) {
      throw Exception('Empty response from Gemini');
    }

    final jsonStr = _extractJson(text);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return FoodAnalysis.fromJson(json);
  }

  @override
  Future<bool> testConnection() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
      final response = await model.generateContent([
        Content.text('Reply with just the word "ok"'),
      ]);
      return response.text != null && response.text!.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  String _extractJson(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('{')) return trimmed;

    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return trimmed.substring(start, end + 1);
    }
    throw FormatException('Could not extract JSON from response: $trimmed');
  }
}
