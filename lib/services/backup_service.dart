import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../data/database/app_database.dart';
import '../main.dart';
import 'image_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final imageService = ref.watch(imageServiceProvider);
  return BackupService(appDatabase, imageService);
});

class BackupService {
  final AppDatabase _db;

  BackupService(this._db, ImageService imageService);

  Future<File> createBackup() async {
    final tempDir = await getTemporaryDirectory();
    final backupDir = Directory(p.join(tempDir.path, 'calwatch_backup'));
    if (await backupDir.exists()) await backupDir.delete(recursive: true);
    await backupDir.create(recursive: true);

    // Export database data as JSON
    final meals = await _db.getAllMeals();
    final goals = await _db.getGoals();
    final settings = await _db.getSettings();

    final data = {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'meals': meals.map((m) => {
            'id': m.id,
            'imagePath': p.basename(m.imagePath),
            'totalCalories': m.totalCalories,
            'totalProteinG': m.totalProteinG,
            'totalCarbsG': m.totalCarbsG,
            'totalFatG': m.totalFatG,
            'foodsJson': m.foodsJson,
            'healthFeedback': m.healthFeedback,
            'mealType': m.mealType,
            'aiProviderUsed': m.aiProviderUsed,
            'createdAt': m.createdAt.toIso8601String(),
          }).toList(),
      'goals': {
        'calorieGoal': goals.calorieGoal,
        'proteinGoal': goals.proteinGoal,
        'carbsGoal': goals.carbsGoal,
        'fatGoal': goals.fatGoal,
      },
      'settings': {
        'activeAiProvider': settings.activeAiProvider,
        'driveSyncFrequency': settings.driveSyncFrequency,
      },
    };

    final jsonFile = File(p.join(backupDir.path, 'data.json'));
    await jsonFile.writeAsString(jsonEncode(data));

    // Copy images
    final imagesDir = Directory(p.join(backupDir.path, 'images'));
    await imagesDir.create();

    for (final meal in meals) {
      final imageFile = File(meal.imagePath);
      if (await imageFile.exists()) {
        final destPath = p.join(imagesDir.path, p.basename(meal.imagePath));
        await imageFile.copy(destPath);
      }
    }

    // Create tar.gz archive
    final archive = Archive();

    final jsonBytes = await jsonFile.readAsBytes();
    archive.addFile(ArchiveFile('data.json', jsonBytes.length, jsonBytes));

    final imageFiles = imagesDir.listSync().whereType<File>();
    for (final imgFile in imageFiles) {
      final bytes = await imgFile.readAsBytes();
      archive.addFile(
        ArchiveFile('images/${p.basename(imgFile.path)}', bytes.length, bytes),
      );
    }

    final tarData = TarEncoder().encode(archive);
    final gzipData = GZipEncoder().encode(tarData);

    final outputFile = File(p.join(tempDir.path, 'calwatch_backup.tar.gz'));
    await outputFile.writeAsBytes(gzipData);

    // Cleanup temp backup dir
    await backupDir.delete(recursive: true);

    return outputFile;
  }

  Future<void> restoreBackup(File archiveFile) async {
    final bytes = await archiveFile.readAsBytes();

    final gzipDecoded = GZipDecoder().decodeBytes(bytes);
    final archive = TarDecoder().decodeBytes(gzipDecoded);

    String? jsonData;
    final Map<String, List<int>> imageFiles = {};

    for (final file in archive) {
      if (file.name == 'data.json') {
        jsonData = utf8.decode(file.content as List<int>);
      } else if (file.name.startsWith('images/')) {
        imageFiles[p.basename(file.name)] = file.content as List<int>;
      }
    }

    if (jsonData == null) {
      throw Exception('Invalid backup: missing data.json');
    }

    final data = jsonDecode(jsonData) as Map<String, dynamic>;

    // Restore images
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'meal_images'));
    if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

    for (final entry in imageFiles.entries) {
      final file = File(p.join(imagesDir.path, entry.key));
      await file.writeAsBytes(entry.value);
    }

    // Restore meals
    final meals = data['meals'] as List;
    for (final mealJson in meals) {
      final imageName = mealJson['imagePath'] as String;
      final fullImagePath = p.join(imagesDir.path, imageName);

      await _db.insertMeal(MealsCompanion.insert(
        imagePath: fullImagePath,
        totalCalories: mealJson['totalCalories'] as int,
        totalProteinG: Value(
            (mealJson['totalProteinG'] as num?)?.toDouble() ?? 0),
        totalCarbsG:
            Value((mealJson['totalCarbsG'] as num?)?.toDouble() ?? 0),
        totalFatG: Value((mealJson['totalFatG'] as num?)?.toDouble() ?? 0),
        foodsJson: mealJson['foodsJson'] as String,
        healthFeedback: Value(mealJson['healthFeedback'] as String? ?? ''),
        mealType: Value(mealJson['mealType'] as String? ?? 'other'),
        aiProviderUsed:
            Value(mealJson['aiProviderUsed'] as String? ?? 'gemini'),
        createdAt: Value(DateTime.parse(mealJson['createdAt'] as String)),
      ));
    }

    // Restore goals
    final goalsData = data['goals'] as Map<String, dynamic>?;
    if (goalsData != null) {
      await _db.updateGoals(DailyGoalsCompanion(
        calorieGoal: Value(goalsData['calorieGoal'] as int? ?? 2200),
        proteinGoal: Value(goalsData['proteinGoal'] as int? ?? 150),
        carbsGoal: Value(goalsData['carbsGoal'] as int? ?? 250),
        fatGoal: Value(goalsData['fatGoal'] as int? ?? 70),
      ));
    }

    // Restore settings
    final settingsData = data['settings'] as Map<String, dynamic>?;
    if (settingsData != null) {
      await _db.updateSettings(AppSettingsCompanion(
        activeAiProvider: Value(
            settingsData['activeAiProvider'] as String? ?? 'gemini'),
        driveSyncFrequency:
            Value(settingsData['driveSyncFrequency'] as String? ?? 'manual'),
      ));
    }
  }
}
