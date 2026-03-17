import 'dart:convert';

class FoodItem {
  final String name;
  final String portion;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String category;

  const FoodItem({
    required this.name,
    required this.portion,
    required this.calories,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.category = '',
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String? ?? 'Unknown',
      portion: json['portion'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (json['fat_g'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'portion': portion,
        'calories': calories,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'category': category,
      };
}

class FoodAnalysis {
  final List<FoodItem> foods;
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final String healthFeedback;

  const FoodAnalysis({
    required this.foods,
    required this.totalCalories,
    this.totalProteinG = 0,
    this.totalCarbsG = 0,
    this.totalFatG = 0,
    this.healthFeedback = '',
  });

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    final foodsList = (json['foods'] as List?)
            ?.map((f) => FoodItem.fromJson(f as Map<String, dynamic>))
            .toList() ??
        [];
    return FoodAnalysis(
      foods: foodsList,
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
      totalProteinG: (json['total_protein_g'] as num?)?.toDouble() ?? 0,
      totalCarbsG: (json['total_carbs_g'] as num?)?.toDouble() ?? 0,
      totalFatG: (json['total_fat_g'] as num?)?.toDouble() ?? 0,
      healthFeedback: json['health_feedback'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'foods': foods.map((f) => f.toJson()).toList(),
        'total_calories': totalCalories,
        'total_protein_g': totalProteinG,
        'total_carbs_g': totalCarbsG,
        'total_fat_g': totalFatG,
        'health_feedback': healthFeedback,
      };

  String toJsonString() => jsonEncode(toJson());

  factory FoodAnalysis.fromJsonString(String jsonString) {
    return FoodAnalysis.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
