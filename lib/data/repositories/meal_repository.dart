import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/food_analysis.dart';
import '../../main.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(appDatabase);
});

class MealRepository {
  final AppDatabase _db;

  MealRepository(this._db);

  Stream<List<Meal>> watchMealsForDate(DateTime date) {
    return _db.watchMealsForDate(date);
  }

  Future<List<Meal>> getMealsForDate(DateTime date) {
    return _db.getMealsForDate(date);
  }

  Future<List<Meal>> getRecentMeals({int limit = 10}) {
    return _db.getRecentMeals(limit: limit);
  }

  Future<int> saveMeal({
    required String imagePath,
    required FoodAnalysis analysis,
    required String mealType,
    required String aiProvider,
  }) {
    return _db.insertMeal(MealsCompanion.insert(
      imagePath: imagePath,
      totalCalories: analysis.totalCalories,
      totalProteinG: Value(analysis.totalProteinG),
      totalCarbsG: Value(analysis.totalCarbsG),
      totalFatG: Value(analysis.totalFatG),
      foodsJson: jsonEncode(analysis.toJson()),
      healthFeedback: Value(analysis.healthFeedback),
      mealType: Value(mealType),
      aiProviderUsed: Value(aiProvider),
    ));
  }

  Future<bool> deleteMeal(int id) {
    return _db.deleteMeal(id);
  }

  Future<List<Meal>> getAllMeals() => _db.getAllMeals();

  Future<DailySummary> getDailySummary(DateTime date) async {
    final meals = await getMealsForDate(date);
    int totalCals = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (final meal in meals) {
      totalCals += meal.totalCalories;
      totalProtein += meal.totalProteinG;
      totalCarbs += meal.totalCarbsG;
      totalFat += meal.totalFatG;
    }

    return DailySummary(
      totalCalories: totalCals,
      totalProteinG: totalProtein,
      totalCarbsG: totalCarbs,
      totalFatG: totalFat,
      mealCount: meals.length,
    );
  }

  Stream<DailySummary> watchDailySummary(DateTime date) {
    return watchMealsForDate(date).map((meals) {
      int totalCals = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;

      for (final meal in meals) {
        totalCals += meal.totalCalories;
        totalProtein += meal.totalProteinG;
        totalCarbs += meal.totalCarbsG;
        totalFat += meal.totalFatG;
      }

      return DailySummary(
        totalCalories: totalCals,
        totalProteinG: totalProtein,
        totalCarbsG: totalCarbs,
        totalFatG: totalFat,
        mealCount: meals.length,
      );
    });
  }
}

class DailySummary {
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final int mealCount;

  const DailySummary({
    this.totalCalories = 0,
    this.totalProteinG = 0,
    this.totalCarbsG = 0,
    this.totalFatG = 0,
    this.mealCount = 0,
  });
}
