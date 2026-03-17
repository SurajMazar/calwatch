import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  IntColumn get totalCalories => integer()();
  RealColumn get totalProteinG => real().withDefault(const Constant(0))();
  RealColumn get totalCarbsG => real().withDefault(const Constant(0))();
  RealColumn get totalFatG => real().withDefault(const Constant(0))();
  TextColumn get foodsJson => text()();
  TextColumn get healthFeedback => text().withDefault(const Constant(''))();
  TextColumn get mealType =>
      text().withDefault(const Constant('other'))();
  TextColumn get aiProviderUsed =>
      text().withDefault(const Constant('gemini'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class DailyGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get calorieGoal => integer().withDefault(const Constant(2200))();
  IntColumn get proteinGoal => integer().withDefault(const Constant(150))();
  IntColumn get carbsGoal => integer().withDefault(const Constant(250))();
  IntColumn get fatGoal => integer().withDefault(const Constant(70))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get activeAiProvider =>
      text().withDefault(const Constant('gemini'))();
  TextColumn get driveSyncFrequency =>
      text().withDefault(const Constant('manual'))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Meals, DailyGoals, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await into(dailyGoals).insert(DailyGoalsCompanion.insert());
        await into(appSettings).insert(AppSettingsCompanion.insert());
      },
    );
  }

  // --- Meal queries ---

  Future<List<Meal>> getMealsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(meals)
          ..where(
              (m) => m.createdAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  Future<List<Meal>> getRecentMeals({int limit = 10}) {
    return (select(meals)
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit))
        .get();
  }

  Stream<List<Meal>> watchMealsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(meals)
          ..where(
              (m) => m.createdAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .watch();
  }

  Future<int> insertMeal(MealsCompanion entry) {
    return into(meals).insert(entry);
  }

  Future<bool> deleteMeal(int id) {
    return (delete(meals)..where((m) => m.id.equals(id)))
        .go()
        .then((rows) => rows > 0);
  }

  Future<List<Meal>> getAllMeals() => select(meals).get();

  // --- Goals queries ---

  Future<DailyGoal> getGoals() async {
    final results = await select(dailyGoals).get();
    if (results.isEmpty) {
      await into(dailyGoals).insert(DailyGoalsCompanion.insert());
      return (await select(dailyGoals).get()).first;
    }
    return results.first;
  }

  Stream<DailyGoal> watchGoals() {
    return select(dailyGoals).watchSingle();
  }

  Future<void> updateGoals(DailyGoalsCompanion goals) async {
    final existing = await getGoals();
    await (update(dailyGoals)..where((g) => g.id.equals(existing.id)))
        .write(goals);
  }

  // --- Settings queries ---

  Future<AppSetting> getSettings() async {
    final results = await select(appSettings).get();
    if (results.isEmpty) {
      await into(appSettings).insert(AppSettingsCompanion.insert());
      return (await select(appSettings).get()).first;
    }
    return results.first;
  }

  Stream<AppSetting> watchSettings() {
    return select(appSettings).watchSingle();
  }

  Future<void> updateSettings(AppSettingsCompanion settings) async {
    final existing = await getSettings();
    await (update(appSettings)..where((s) => s.id.equals(existing.id)))
        .write(settings);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'calwatch.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
