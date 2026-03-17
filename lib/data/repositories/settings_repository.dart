import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/app_database.dart';
import '../models/ai_provider.dart';
import '../../main.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(appDatabase);
});

class SettingsRepository {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SettingsRepository(this._db);

  // --- AI Provider ---

  Future<AiProvider> getActiveAiProvider() async {
    final settings = await _db.getSettings();
    return AiProvider.fromString(settings.activeAiProvider);
  }

  Stream<AppSetting> watchSettings() => _db.watchSettings();

  Future<void> setActiveAiProvider(AiProvider provider) async {
    await _db.updateSettings(
      AppSettingsCompanion(activeAiProvider: Value(provider.name)),
    );
  }

  // --- API Keys ---

  Future<String?> getApiKey(AiProvider provider) async {
    return _secureStorage.read(key: provider.storageKey);
  }

  Future<void> setApiKey(AiProvider provider, String key) async {
    await _secureStorage.write(key: provider.storageKey, value: key);
  }

  Future<void> deleteApiKey(AiProvider provider) async {
    await _secureStorage.delete(key: provider.storageKey);
  }

  Future<bool> hasApiKey(AiProvider provider) async {
    final key = await getApiKey(provider);
    return key != null && key.isNotEmpty;
  }

  // --- Goals ---

  Future<DailyGoal> getGoals() => _db.getGoals();
  Stream<DailyGoal> watchGoals() => _db.watchGoals();

  Future<void> updateGoals({
    int? calorieGoal,
    int? proteinGoal,
    int? carbsGoal,
    int? fatGoal,
  }) async {
    await _db.updateGoals(DailyGoalsCompanion(
      calorieGoal: calorieGoal != null ? Value(calorieGoal) : const Value.absent(),
      proteinGoal: proteinGoal != null ? Value(proteinGoal) : const Value.absent(),
      carbsGoal: carbsGoal != null ? Value(carbsGoal) : const Value.absent(),
      fatGoal: fatGoal != null ? Value(fatGoal) : const Value.absent(),
    ));
  }

  // --- Drive Sync ---

  Future<String> getDriveSyncFrequency() async {
    final settings = await _db.getSettings();
    return settings.driveSyncFrequency;
  }

  Future<void> setDriveSyncFrequency(String frequency) async {
    await _db.updateSettings(
      AppSettingsCompanion(driveSyncFrequency: Value(frequency)),
    );
  }

  Future<DateTime?> getLastSyncTime() async {
    final settings = await _db.getSettings();
    return settings.lastSyncAt;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await _db.updateSettings(
      AppSettingsCompanion(lastSyncAt: Value(time)),
    );
  }
}
