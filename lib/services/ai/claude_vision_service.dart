import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../data/models/food_analysis.dart';
import 'ai_vision_service.dart';

class ClaudeVisionService implements AiVisionService {
  final String apiKey;

  ClaudeVisionService({required this.apiKey});

  @override
  String get providerName => 'claude';

  @override
  Future<FoodAnalysis> analyzeFood(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-20250514',
        'max_tokens': 1000,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': base64Image,
                },
              },
              {
                'type': 'text',
                'text': AppConstants.foodAnalysisPrompt,
              },
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error: ${response.statusCode} - ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['content'][0]['text'] as String;
    final jsonStr = _extractJson(content);
    final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
    return FoodAnalysis.fromJson(parsed);
  }

  @override
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 10,
          'messages': [
            {'role': 'user', 'content': 'Reply with just "ok"'}
          ],
        }),
      );
      return response.statusCode == 200;
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
