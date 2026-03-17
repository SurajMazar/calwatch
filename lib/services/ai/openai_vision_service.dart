import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../data/models/food_analysis.dart';
import 'ai_vision_service.dart';

class OpenAiVisionService implements AiVisionService {
  final String apiKey;

  OpenAiVisionService({required this.apiKey});

  @override
  String get providerName => 'openai';

  @override
  Future<FoodAnalysis> analyzeFood(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'response_format': {'type': 'json_object'},
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': AppConstants.foodAnalysisPrompt},
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                  'detail': 'high',
                },
              },
            ],
          }
        ],
        'max_tokens': 1000,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['choices'][0]['message']['content'] as String;
    final parsed = jsonDecode(content) as Map<String, dynamic>;
    return FoodAnalysis.fromJson(parsed);
  }

  @override
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {'role': 'user', 'content': 'Reply with just "ok"'}
          ],
          'max_tokens': 5,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
