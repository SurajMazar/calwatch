import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class MealListTile extends StatelessWidget {
  final String title;
  final String mealType;
  final DateTime time;
  final int calories;
  final String? imagePath;
  final VoidCallback? onTap;

  const MealListTile({
    super.key,
    required this.title,
    required this.mealType,
    required this.time,
    required this.calories,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = DateFormat('h:mm a').format(time);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? AppColors.borderDark
                    : const Color(0xFFF1F5F9),
              ),
              clipBehavior: Clip.antiAlias,
              child: imagePath != null && File(imagePath!).existsSync()
                  ? Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.textTertiaryLight,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$calories',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'kcal',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
