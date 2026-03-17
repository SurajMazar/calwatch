import 'dart:typed_data';
import '../../data/models/food_analysis.dart';

abstract class AiVisionService {
  String get providerName;

  Future<FoodAnalysis> analyzeFood(Uint8List imageBytes);

  Future<bool> testConnection();
}
