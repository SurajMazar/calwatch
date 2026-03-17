import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../main.dart';
import '../widgets/meal_list_tile.dart';

class MealHistoryScreen extends ConsumerStatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  ConsumerState<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends ConsumerState<MealHistoryScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _buildWeekDates();
  }

  void _buildWeekDates() {
    final now = _selectedDate;
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _weekDates = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                          _buildWeekDates();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            // Week selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: _weekDates.map((date) {
                  final isSelected = _isSameDay(date, _selectedDate);
                  final dayName = DateFormat('E').format(date).substring(0, 3).toUpperCase();

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : isDark
                                  ? AppColors.surfaceDark
                                  : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppColors.textTertiaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Content
            Expanded(
              child: StreamBuilder<List<Meal>>(
                stream: appDatabase.watchMealsForDate(_selectedDate),
                builder: (context, snapshot) {
                  final meals = snapshot.data ?? [];
                  final goals = appDatabase.getGoals();

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
                      // Daily summary
                      FutureBuilder<DailyGoal>(
                        future: goals,
                        builder: (context, goalsSnap) {
                          final g = goalsSnap.data;
                          final calorieGoal = g?.calorieGoal ?? 2200;
                          final progress = calorieGoal > 0
                              ? (totalCals / calorieGoal).clamp(0.0, 1.0)
                              : 0.0;
                          final pct = (progress * 100).round();

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TOTAL CONSUMED',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                            color: isDark
                                                ? AppColors.textTertiaryDark
                                                : AppColors.textTertiaryLight,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '$totalCals ',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Inter',
                                                  color: isDark
                                                      ? AppColors.textPrimaryDark
                                                      : AppColors.textPrimaryLight,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '/ $calorieGoal kcal',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  color: isDark
                                                      ? AppColors.textTertiaryDark
                                                      : AppColors.textTertiaryLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        '$pct% Goal',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10,
                                    backgroundColor: isDark
                                        ? AppColors.borderDark
                                        : const Color(0xFFF1F5F9),
                                    valueColor: const AlwaysStoppedAnimation(
                                        AppColors.primary),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _MacroStat(
                                      label: 'PROTEIN',
                                      value: '${totalProtein.round()}g',
                                    ),
                                    _MacroStat(
                                      label: 'CARBS',
                                      value: '${totalCarbs.round()}g',
                                    ),
                                    _MacroStat(
                                      label: 'FAT',
                                      value: '${totalFat.round()}g',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Meal log header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'MEAL LOG',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (meals.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.no_meals_rounded,
                                  size: 48,
                                  color: isDark
                                      ? AppColors.textTertiaryDark
                                      : AppColors.textTertiaryLight,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No meals logged for this day',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...meals.map((meal) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Dismissible(
                                key: ValueKey(meal.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (_) async {
                                  await appDatabase.deleteMeal(meal.id);
                                },
                                child: MealListTile(
                                  title: _getMealTitle(meal),
                                  mealType: meal.mealType,
                                  time: meal.createdAt,
                                  calories: meal.totalCalories,
                                  imagePath: meal.imagePath,
                                ),
                              ),
                            )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  final String label;
  final String value;

  const _MacroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
