class AppConstants {
  AppConstants._();

  static const String appName = 'CalWatch';
  static const int defaultCalorieGoal = 2200;
  static const int defaultProteinGoal = 150;
  static const int defaultCarbsGoal = 250;
  static const int defaultFatGoal = 70;

  // Secure storage keys
  static const String geminiApiKeyStorageKey = 'ai_key_gemini';
  static const String openaiApiKeyStorageKey = 'ai_key_openai';
  static const String claudeApiKeyStorageKey = 'ai_key_claude';

  // AI prompt
  static const String foodAnalysisPrompt = '''
Analyze this food image carefully. Identify all visible food items, estimate their portions, and calculate calories.

Return ONLY valid JSON in this exact format (no markdown, no extra text):
{
  "foods": [
    {
      "name": "Food item name",
      "portion": "estimated portion (e.g., 1 cup, 150g, 1 slice)",
      "calories": 250,
      "protein_g": 20,
      "carbs_g": 30,
      "fat_g": 10,
      "category": "one of: Protein, Carbs, Vegetables, Fruits, Dairy, Fats, Grains, Beverages, Snacks"
    }
  ],
  "total_calories": 500,
  "total_protein_g": 30,
  "total_carbs_g": 50,
  "total_fat_g": 15,
  "health_feedback": "Brief health assessment of this meal, 2-3 sentences."
}
''';

  // Google Drive
  static const String driveBackupFileName = 'calwatch_backup.tar.gz';
  static const String driveAppFolderName = 'CalWatch Backups';
}
