import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/calorie_progress_ring.dart';
import '../widgets/macro_card.dart';
import '../widgets/meal_list_tile.dart';
import '../../data/database/app_database.dart';
import '../../main.dart';

final _todayMealsProvider = StreamProvider<List<Meal>>((ref) {
  return appDatabase.watchMealsForDate(DateTime.now());
});

final _goalsProvider = StreamProvider<DailyGoal>((ref) {
  return appDatabase.watchGoals();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getMealTitle(Meal meal) {
    try {
      final json = jsonDecode(meal.foodsJson) as Map<String, dynamic>;
      final foods = json['foods'] as List?;
      if (foods != null && foods.isNotEmpty) {
        final names = foods.take(2).map((f) => f['name'] as String).toList();
        return names.join(' & ');
      }
    } catch (_) {}
    return 'Meal';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(_todayMealsProvider);
    final goalsAsync = ref.watch(_goalsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: mealsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (meals) {
            final goals = goalsAsync.valueOrNull;
            final calorieGoal = goals?.calorieGoal ?? 2200;
            final proteinGoal = goals?.proteinGoal ?? 150;
            final carbsGoal = goals?.carbsGoal ?? 250;
            final fatGoal = goals?.fatGoal ?? 70;

            int totalCals = 0;
            double totalProtein = 0, totalCarbs = 0, totalFat = 0;
            for (final m in meals) {
              totalCals += m.totalCalories;
              totalProtein += m.totalProteinG;
              totalCarbs += m.totalCarbsG;
              totalFat += m.totalFatG;
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            const Text(
                              'CalWatch',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Calorie ring section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark.withValues(alpha: 0.5)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      CalorieProgressRing(
                        consumed: totalCals,
                        goal: calorieGoal,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Consumed',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                                ),
                              ),
                              Text(
                                '$totalCals kcal',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                          Column(
                            children: [
                              Text(
                                'Goal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                                ),
                              ),
                              Text(
                                '$calorieGoal kcal',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Daily Macros
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Macros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: MacroCard(
                              label: 'Protein',
                              value: '${totalProtein.round()}g',
                              progress: proteinGoal > 0 ? totalProtein / proteinGoal : 0,
                              color: AppColors.protein,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MacroCard(
                              label: 'Carbs',
                              value: '${totalCarbs.round()}g',
                              progress: carbsGoal > 0 ? totalCarbs / carbsGoal : 0,
                              color: AppColors.carbs,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MacroCard(
                              label: 'Fats',
                              value: '${totalFat.round()}g',
                              progress: fatGoal > 0 ? totalFat / fatGoal : 0,
                              color: AppColors.fats,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Scan Your Meal CTA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () => context.push('/capture'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan Your Meal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'AI instant recognition',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Recent History
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/history'),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                if (meals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 48,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No meals logged yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the camera to scan your first meal!',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...meals.take(5).map((meal) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        child: MealListTile(
                          title: _getMealTitle(meal),
                          mealType: meal.mealType,
                          time: meal.createdAt,
                          calories: meal.totalCalories,
                          imagePath: meal.imagePath,
                        ),
                      )),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}
