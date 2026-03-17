// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<int> totalCalories = GeneratedColumn<int>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProteinGMeta = const VerificationMeta(
    'totalProteinG',
  );
  @override
  late final GeneratedColumn<double> totalProteinG = GeneratedColumn<double>(
    'total_protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCarbsGMeta = const VerificationMeta(
    'totalCarbsG',
  );
  @override
  late final GeneratedColumn<double> totalCarbsG = GeneratedColumn<double>(
    'total_carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalFatGMeta = const VerificationMeta(
    'totalFatG',
  );
  @override
  late final GeneratedColumn<double> totalFatG = GeneratedColumn<double>(
    'total_fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _foodsJsonMeta = const VerificationMeta(
    'foodsJson',
  );
  @override
  late final GeneratedColumn<String> foodsJson = GeneratedColumn<String>(
    'foods_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _healthFeedbackMeta = const VerificationMeta(
    'healthFeedback',
  );
  @override
  late final GeneratedColumn<String> healthFeedback = GeneratedColumn<String>(
    'health_feedback',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _aiProviderUsedMeta = const VerificationMeta(
    'aiProviderUsed',
  );
  @override
  late final GeneratedColumn<String> aiProviderUsed = GeneratedColumn<String>(
    'ai_provider_used',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('gemini'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imagePath,
    totalCalories,
    totalProteinG,
    totalCarbsG,
    totalFatG,
    foodsJson,
    healthFeedback,
    mealType,
    aiProviderUsed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('total_protein_g')) {
      context.handle(
        _totalProteinGMeta,
        totalProteinG.isAcceptableOrUnknown(
          data['total_protein_g']!,
          _totalProteinGMeta,
        ),
      );
    }
    if (data.containsKey('total_carbs_g')) {
      context.handle(
        _totalCarbsGMeta,
        totalCarbsG.isAcceptableOrUnknown(
          data['total_carbs_g']!,
          _totalCarbsGMeta,
        ),
      );
    }
    if (data.containsKey('total_fat_g')) {
      context.handle(
        _totalFatGMeta,
        totalFatG.isAcceptableOrUnknown(data['total_fat_g']!, _totalFatGMeta),
      );
    }
    if (data.containsKey('foods_json')) {
      context.handle(
        _foodsJsonMeta,
        foodsJson.isAcceptableOrUnknown(data['foods_json']!, _foodsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_foodsJsonMeta);
    }
    if (data.containsKey('health_feedback')) {
      context.handle(
        _healthFeedbackMeta,
        healthFeedback.isAcceptableOrUnknown(
          data['health_feedback']!,
          _healthFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    if (data.containsKey('ai_provider_used')) {
      context.handle(
        _aiProviderUsedMeta,
        aiProviderUsed.isAcceptableOrUnknown(
          data['ai_provider_used']!,
          _aiProviderUsedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_calories'],
      )!,
      totalProteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_protein_g'],
      )!,
      totalCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs_g'],
      )!,
      totalFatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fat_g'],
      )!,
      foodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foods_json'],
      )!,
      healthFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_feedback'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      aiProviderUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_provider_used'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final String imagePath;
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final String foodsJson;
  final String healthFeedback;
  final String mealType;
  final String aiProviderUsed;
  final DateTime createdAt;
  const Meal({
    required this.id,
    required this.imagePath,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.foodsJson,
    required this.healthFeedback,
    required this.mealType,
    required this.aiProviderUsed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image_path'] = Variable<String>(imagePath);
    map['total_calories'] = Variable<int>(totalCalories);
    map['total_protein_g'] = Variable<double>(totalProteinG);
    map['total_carbs_g'] = Variable<double>(totalCarbsG);
    map['total_fat_g'] = Variable<double>(totalFatG);
    map['foods_json'] = Variable<String>(foodsJson);
    map['health_feedback'] = Variable<String>(healthFeedback);
    map['meal_type'] = Variable<String>(mealType);
    map['ai_provider_used'] = Variable<String>(aiProviderUsed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      imagePath: Value(imagePath),
      totalCalories: Value(totalCalories),
      totalProteinG: Value(totalProteinG),
      totalCarbsG: Value(totalCarbsG),
      totalFatG: Value(totalFatG),
      foodsJson: Value(foodsJson),
      healthFeedback: Value(healthFeedback),
      mealType: Value(mealType),
      aiProviderUsed: Value(aiProviderUsed),
      createdAt: Value(createdAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      totalCalories: serializer.fromJson<int>(json['totalCalories']),
      totalProteinG: serializer.fromJson<double>(json['totalProteinG']),
      totalCarbsG: serializer.fromJson<double>(json['totalCarbsG']),
      totalFatG: serializer.fromJson<double>(json['totalFatG']),
      foodsJson: serializer.fromJson<String>(json['foodsJson']),
      healthFeedback: serializer.fromJson<String>(json['healthFeedback']),
      mealType: serializer.fromJson<String>(json['mealType']),
      aiProviderUsed: serializer.fromJson<String>(json['aiProviderUsed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'imagePath': serializer.toJson<String>(imagePath),
      'totalCalories': serializer.toJson<int>(totalCalories),
      'totalProteinG': serializer.toJson<double>(totalProteinG),
      'totalCarbsG': serializer.toJson<double>(totalCarbsG),
      'totalFatG': serializer.toJson<double>(totalFatG),
      'foodsJson': serializer.toJson<String>(foodsJson),
      'healthFeedback': serializer.toJson<String>(healthFeedback),
      'mealType': serializer.toJson<String>(mealType),
      'aiProviderUsed': serializer.toJson<String>(aiProviderUsed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Meal copyWith({
    int? id,
    String? imagePath,
    int? totalCalories,
    double? totalProteinG,
    double? totalCarbsG,
    double? totalFatG,
    String? foodsJson,
    String? healthFeedback,
    String? mealType,
    String? aiProviderUsed,
    DateTime? createdAt,
  }) => Meal(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    totalCalories: totalCalories ?? this.totalCalories,
    totalProteinG: totalProteinG ?? this.totalProteinG,
    totalCarbsG: totalCarbsG ?? this.totalCarbsG,
    totalFatG: totalFatG ?? this.totalFatG,
    foodsJson: foodsJson ?? this.foodsJson,
    healthFeedback: healthFeedback ?? this.healthFeedback,
    mealType: mealType ?? this.mealType,
    aiProviderUsed: aiProviderUsed ?? this.aiProviderUsed,
    createdAt: createdAt ?? this.createdAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalProteinG: data.totalProteinG.present
          ? data.totalProteinG.value
          : this.totalProteinG,
      totalCarbsG: data.totalCarbsG.present
          ? data.totalCarbsG.value
          : this.totalCarbsG,
      totalFatG: data.totalFatG.present ? data.totalFatG.value : this.totalFatG,
      foodsJson: data.foodsJson.present ? data.foodsJson.value : this.foodsJson,
      healthFeedback: data.healthFeedback.present
          ? data.healthFeedback.value
          : this.healthFeedback,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      aiProviderUsed: data.aiProviderUsed.present
          ? data.aiProviderUsed.value
          : this.aiProviderUsed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProteinG: $totalProteinG, ')
          ..write('totalCarbsG: $totalCarbsG, ')
          ..write('totalFatG: $totalFatG, ')
          ..write('foodsJson: $foodsJson, ')
          ..write('healthFeedback: $healthFeedback, ')
          ..write('mealType: $mealType, ')
          ..write('aiProviderUsed: $aiProviderUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    totalCalories,
    totalProteinG,
    totalCarbsG,
    totalFatG,
    foodsJson,
    healthFeedback,
    mealType,
    aiProviderUsed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.imagePath == this.imagePath &&
          other.totalCalories == this.totalCalories &&
          other.totalProteinG == this.totalProteinG &&
          other.totalCarbsG == this.totalCarbsG &&
          other.totalFatG == this.totalFatG &&
          other.foodsJson == this.foodsJson &&
          other.healthFeedback == this.healthFeedback &&
          other.mealType == this.mealType &&
          other.aiProviderUsed == this.aiProviderUsed &&
          other.createdAt == this.createdAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String> imagePath;
  final Value<int> totalCalories;
  final Value<double> totalProteinG;
  final Value<double> totalCarbsG;
  final Value<double> totalFatG;
  final Value<String> foodsJson;
  final Value<String> healthFeedback;
  final Value<String> mealType;
  final Value<String> aiProviderUsed;
  final Value<DateTime> createdAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProteinG = const Value.absent(),
    this.totalCarbsG = const Value.absent(),
    this.totalFatG = const Value.absent(),
    this.foodsJson = const Value.absent(),
    this.healthFeedback = const Value.absent(),
    this.mealType = const Value.absent(),
    this.aiProviderUsed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String imagePath,
    required int totalCalories,
    this.totalProteinG = const Value.absent(),
    this.totalCarbsG = const Value.absent(),
    this.totalFatG = const Value.absent(),
    required String foodsJson,
    this.healthFeedback = const Value.absent(),
    this.mealType = const Value.absent(),
    this.aiProviderUsed = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : imagePath = Value(imagePath),
       totalCalories = Value(totalCalories),
       foodsJson = Value(foodsJson);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? imagePath,
    Expression<int>? totalCalories,
    Expression<double>? totalProteinG,
    Expression<double>? totalCarbsG,
    Expression<double>? totalFatG,
    Expression<String>? foodsJson,
    Expression<String>? healthFeedback,
    Expression<String>? mealType,
    Expression<String>? aiProviderUsed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalProteinG != null) 'total_protein_g': totalProteinG,
      if (totalCarbsG != null) 'total_carbs_g': totalCarbsG,
      if (totalFatG != null) 'total_fat_g': totalFatG,
      if (foodsJson != null) 'foods_json': foodsJson,
      if (healthFeedback != null) 'health_feedback': healthFeedback,
      if (mealType != null) 'meal_type': mealType,
      if (aiProviderUsed != null) 'ai_provider_used': aiProviderUsed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<String>? imagePath,
    Value<int>? totalCalories,
    Value<double>? totalProteinG,
    Value<double>? totalCarbsG,
    Value<double>? totalFatG,
    Value<String>? foodsJson,
    Value<String>? healthFeedback,
    Value<String>? mealType,
    Value<String>? aiProviderUsed,
    Value<DateTime>? createdAt,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteinG: totalProteinG ?? this.totalProteinG,
      totalCarbsG: totalCarbsG ?? this.totalCarbsG,
      totalFatG: totalFatG ?? this.totalFatG,
      foodsJson: foodsJson ?? this.foodsJson,
      healthFeedback: healthFeedback ?? this.healthFeedback,
      mealType: mealType ?? this.mealType,
      aiProviderUsed: aiProviderUsed ?? this.aiProviderUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<int>(totalCalories.value);
    }
    if (totalProteinG.present) {
      map['total_protein_g'] = Variable<double>(totalProteinG.value);
    }
    if (totalCarbsG.present) {
      map['total_carbs_g'] = Variable<double>(totalCarbsG.value);
    }
    if (totalFatG.present) {
      map['total_fat_g'] = Variable<double>(totalFatG.value);
    }
    if (foodsJson.present) {
      map['foods_json'] = Variable<String>(foodsJson.value);
    }
    if (healthFeedback.present) {
      map['health_feedback'] = Variable<String>(healthFeedback.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (aiProviderUsed.present) {
      map['ai_provider_used'] = Variable<String>(aiProviderUsed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProteinG: $totalProteinG, ')
          ..write('totalCarbsG: $totalCarbsG, ')
          ..write('totalFatG: $totalFatG, ')
          ..write('foodsJson: $foodsJson, ')
          ..write('healthFeedback: $healthFeedback, ')
          ..write('mealType: $mealType, ')
          ..write('aiProviderUsed: $aiProviderUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyGoalsTable extends DailyGoals
    with TableInfo<$DailyGoalsTable, DailyGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _calorieGoalMeta = const VerificationMeta(
    'calorieGoal',
  );
  @override
  late final GeneratedColumn<int> calorieGoal = GeneratedColumn<int>(
    'calorie_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2200),
  );
  static const VerificationMeta _proteinGoalMeta = const VerificationMeta(
    'proteinGoal',
  );
  @override
  late final GeneratedColumn<int> proteinGoal = GeneratedColumn<int>(
    'protein_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(150),
  );
  static const VerificationMeta _carbsGoalMeta = const VerificationMeta(
    'carbsGoal',
  );
  @override
  late final GeneratedColumn<int> carbsGoal = GeneratedColumn<int>(
    'carbs_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(250),
  );
  static const VerificationMeta _fatGoalMeta = const VerificationMeta(
    'fatGoal',
  );
  @override
  late final GeneratedColumn<int> fatGoal = GeneratedColumn<int>(
    'fat_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(70),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calorieGoal,
    proteinGoal,
    carbsGoal,
    fatGoal,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('calorie_goal')) {
      context.handle(
        _calorieGoalMeta,
        calorieGoal.isAcceptableOrUnknown(
          data['calorie_goal']!,
          _calorieGoalMeta,
        ),
      );
    }
    if (data.containsKey('protein_goal')) {
      context.handle(
        _proteinGoalMeta,
        proteinGoal.isAcceptableOrUnknown(
          data['protein_goal']!,
          _proteinGoalMeta,
        ),
      );
    }
    if (data.containsKey('carbs_goal')) {
      context.handle(
        _carbsGoalMeta,
        carbsGoal.isAcceptableOrUnknown(data['carbs_goal']!, _carbsGoalMeta),
      );
    }
    if (data.containsKey('fat_goal')) {
      context.handle(
        _fatGoalMeta,
        fatGoal.isAcceptableOrUnknown(data['fat_goal']!, _fatGoalMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      calorieGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_goal'],
      )!,
      proteinGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_goal'],
      )!,
      carbsGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carbs_goal'],
      )!,
      fatGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fat_goal'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyGoalsTable createAlias(String alias) {
    return $DailyGoalsTable(attachedDatabase, alias);
  }
}

class DailyGoal extends DataClass implements Insertable<DailyGoal> {
  final int id;
  final int calorieGoal;
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;
  final DateTime updatedAt;
  const DailyGoal({
    required this.id,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['calorie_goal'] = Variable<int>(calorieGoal);
    map['protein_goal'] = Variable<int>(proteinGoal);
    map['carbs_goal'] = Variable<int>(carbsGoal);
    map['fat_goal'] = Variable<int>(fatGoal);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyGoalsCompanion toCompanion(bool nullToAbsent) {
    return DailyGoalsCompanion(
      id: Value(id),
      calorieGoal: Value(calorieGoal),
      proteinGoal: Value(proteinGoal),
      carbsGoal: Value(carbsGoal),
      fatGoal: Value(fatGoal),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyGoal(
      id: serializer.fromJson<int>(json['id']),
      calorieGoal: serializer.fromJson<int>(json['calorieGoal']),
      proteinGoal: serializer.fromJson<int>(json['proteinGoal']),
      carbsGoal: serializer.fromJson<int>(json['carbsGoal']),
      fatGoal: serializer.fromJson<int>(json['fatGoal']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calorieGoal': serializer.toJson<int>(calorieGoal),
      'proteinGoal': serializer.toJson<int>(proteinGoal),
      'carbsGoal': serializer.toJson<int>(carbsGoal),
      'fatGoal': serializer.toJson<int>(fatGoal),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyGoal copyWith({
    int? id,
    int? calorieGoal,
    int? proteinGoal,
    int? carbsGoal,
    int? fatGoal,
    DateTime? updatedAt,
  }) => DailyGoal(
    id: id ?? this.id,
    calorieGoal: calorieGoal ?? this.calorieGoal,
    proteinGoal: proteinGoal ?? this.proteinGoal,
    carbsGoal: carbsGoal ?? this.carbsGoal,
    fatGoal: fatGoal ?? this.fatGoal,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyGoal copyWithCompanion(DailyGoalsCompanion data) {
    return DailyGoal(
      id: data.id.present ? data.id.value : this.id,
      calorieGoal: data.calorieGoal.present
          ? data.calorieGoal.value
          : this.calorieGoal,
      proteinGoal: data.proteinGoal.present
          ? data.proteinGoal.value
          : this.proteinGoal,
      carbsGoal: data.carbsGoal.present ? data.carbsGoal.value : this.carbsGoal,
      fatGoal: data.fatGoal.present ? data.fatGoal.value : this.fatGoal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyGoal(')
          ..write('id: $id, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbsGoal: $carbsGoal, ')
          ..write('fatGoal: $fatGoal, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, calorieGoal, proteinGoal, carbsGoal, fatGoal, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyGoal &&
          other.id == this.id &&
          other.calorieGoal == this.calorieGoal &&
          other.proteinGoal == this.proteinGoal &&
          other.carbsGoal == this.carbsGoal &&
          other.fatGoal == this.fatGoal &&
          other.updatedAt == this.updatedAt);
}

class DailyGoalsCompanion extends UpdateCompanion<DailyGoal> {
  final Value<int> id;
  final Value<int> calorieGoal;
  final Value<int> proteinGoal;
  final Value<int> carbsGoal;
  final Value<int> fatGoal;
  final Value<DateTime> updatedAt;
  const DailyGoalsCompanion({
    this.id = const Value.absent(),
    this.calorieGoal = const Value.absent(),
    this.proteinGoal = const Value.absent(),
    this.carbsGoal = const Value.absent(),
    this.fatGoal = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyGoalsCompanion.insert({
    this.id = const Value.absent(),
    this.calorieGoal = const Value.absent(),
    this.proteinGoal = const Value.absent(),
    this.carbsGoal = const Value.absent(),
    this.fatGoal = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<DailyGoal> custom({
    Expression<int>? id,
    Expression<int>? calorieGoal,
    Expression<int>? proteinGoal,
    Expression<int>? carbsGoal,
    Expression<int>? fatGoal,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calorieGoal != null) 'calorie_goal': calorieGoal,
      if (proteinGoal != null) 'protein_goal': proteinGoal,
      if (carbsGoal != null) 'carbs_goal': carbsGoal,
      if (fatGoal != null) 'fat_goal': fatGoal,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyGoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? calorieGoal,
    Value<int>? proteinGoal,
    Value<int>? carbsGoal,
    Value<int>? fatGoal,
    Value<DateTime>? updatedAt,
  }) {
    return DailyGoalsCompanion(
      id: id ?? this.id,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calorieGoal.present) {
      map['calorie_goal'] = Variable<int>(calorieGoal.value);
    }
    if (proteinGoal.present) {
      map['protein_goal'] = Variable<int>(proteinGoal.value);
    }
    if (carbsGoal.present) {
      map['carbs_goal'] = Variable<int>(carbsGoal.value);
    }
    if (fatGoal.present) {
      map['fat_goal'] = Variable<int>(fatGoal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbsGoal: $carbsGoal, ')
          ..write('fatGoal: $fatGoal, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activeAiProviderMeta = const VerificationMeta(
    'activeAiProvider',
  );
  @override
  late final GeneratedColumn<String> activeAiProvider = GeneratedColumn<String>(
    'active_ai_provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('gemini'),
  );
  static const VerificationMeta _driveSyncFrequencyMeta =
      const VerificationMeta('driveSyncFrequency');
  @override
  late final GeneratedColumn<String> driveSyncFrequency =
      GeneratedColumn<String>(
        'drive_sync_frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('manual'),
      );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activeAiProvider,
    driveSyncFrequency,
    lastSyncAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active_ai_provider')) {
      context.handle(
        _activeAiProviderMeta,
        activeAiProvider.isAcceptableOrUnknown(
          data['active_ai_provider']!,
          _activeAiProviderMeta,
        ),
      );
    }
    if (data.containsKey('drive_sync_frequency')) {
      context.handle(
        _driveSyncFrequencyMeta,
        driveSyncFrequency.isAcceptableOrUnknown(
          data['drive_sync_frequency']!,
          _driveSyncFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activeAiProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_ai_provider'],
      )!,
      driveSyncFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_sync_frequency'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String activeAiProvider;
  final String driveSyncFrequency;
  final DateTime? lastSyncAt;
  final DateTime updatedAt;
  const AppSetting({
    required this.id,
    required this.activeAiProvider,
    required this.driveSyncFrequency,
    this.lastSyncAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['active_ai_provider'] = Variable<String>(activeAiProvider);
    map['drive_sync_frequency'] = Variable<String>(driveSyncFrequency);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      activeAiProvider: Value(activeAiProvider),
      driveSyncFrequency: Value(driveSyncFrequency),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      activeAiProvider: serializer.fromJson<String>(json['activeAiProvider']),
      driveSyncFrequency: serializer.fromJson<String>(
        json['driveSyncFrequency'],
      ),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activeAiProvider': serializer.toJson<String>(activeAiProvider),
      'driveSyncFrequency': serializer.toJson<String>(driveSyncFrequency),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    int? id,
    String? activeAiProvider,
    String? driveSyncFrequency,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    DateTime? updatedAt,
  }) => AppSetting(
    id: id ?? this.id,
    activeAiProvider: activeAiProvider ?? this.activeAiProvider,
    driveSyncFrequency: driveSyncFrequency ?? this.driveSyncFrequency,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      activeAiProvider: data.activeAiProvider.present
          ? data.activeAiProvider.value
          : this.activeAiProvider,
      driveSyncFrequency: data.driveSyncFrequency.present
          ? data.driveSyncFrequency.value
          : this.driveSyncFrequency,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('activeAiProvider: $activeAiProvider, ')
          ..write('driveSyncFrequency: $driveSyncFrequency, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activeAiProvider,
    driveSyncFrequency,
    lastSyncAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.activeAiProvider == this.activeAiProvider &&
          other.driveSyncFrequency == this.driveSyncFrequency &&
          other.lastSyncAt == this.lastSyncAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> activeAiProvider;
  final Value<String> driveSyncFrequency;
  final Value<DateTime?> lastSyncAt;
  final Value<DateTime> updatedAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.activeAiProvider = const Value.absent(),
    this.driveSyncFrequency = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.activeAiProvider = const Value.absent(),
    this.driveSyncFrequency = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? activeAiProvider,
    Expression<String>? driveSyncFrequency,
    Expression<DateTime>? lastSyncAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activeAiProvider != null) 'active_ai_provider': activeAiProvider,
      if (driveSyncFrequency != null)
        'drive_sync_frequency': driveSyncFrequency,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? activeAiProvider,
    Value<String>? driveSyncFrequency,
    Value<DateTime?>? lastSyncAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      activeAiProvider: activeAiProvider ?? this.activeAiProvider,
      driveSyncFrequency: driveSyncFrequency ?? this.driveSyncFrequency,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activeAiProvider.present) {
      map['active_ai_provider'] = Variable<String>(activeAiProvider.value);
    }
    if (driveSyncFrequency.present) {
      map['drive_sync_frequency'] = Variable<String>(driveSyncFrequency.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('activeAiProvider: $activeAiProvider, ')
          ..write('driveSyncFrequency: $driveSyncFrequency, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $DailyGoalsTable dailyGoals = $DailyGoalsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    meals,
    dailyGoals,
    appSettings,
  ];
}

typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required String imagePath,
      required int totalCalories,
      Value<double> totalProteinG,
      Value<double> totalCarbsG,
      Value<double> totalFatG,
      required String foodsJson,
      Value<String> healthFeedback,
      Value<String> mealType,
      Value<String> aiProviderUsed,
      Value<DateTime> createdAt,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<String> imagePath,
      Value<int> totalCalories,
      Value<double> totalProteinG,
      Value<double> totalCarbsG,
      Value<double> totalFatG,
      Value<String> foodsJson,
      Value<String> healthFeedback,
      Value<String> mealType,
      Value<String> aiProviderUsed,
      Value<DateTime> createdAt,
    });

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFatG => $composableBuilder(
    column: $table.totalFatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodsJson => $composableBuilder(
    column: $table.foodsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthFeedback => $composableBuilder(
    column: $table.healthFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiProviderUsed => $composableBuilder(
    column: $table.aiProviderUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFatG => $composableBuilder(
    column: $table.totalFatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodsJson => $composableBuilder(
    column: $table.foodsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthFeedback => $composableBuilder(
    column: $table.healthFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiProviderUsed => $composableBuilder(
    column: $table.aiProviderUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFatG =>
      $composableBuilder(column: $table.totalFatG, builder: (column) => column);

  GeneratedColumn<String> get foodsJson =>
      $composableBuilder(column: $table.foodsJson, builder: (column) => column);

  GeneratedColumn<String> get healthFeedback => $composableBuilder(
    column: $table.healthFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get aiProviderUsed => $composableBuilder(
    column: $table.aiProviderUsed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
          Meal,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> totalCalories = const Value.absent(),
                Value<double> totalProteinG = const Value.absent(),
                Value<double> totalCarbsG = const Value.absent(),
                Value<double> totalFatG = const Value.absent(),
                Value<String> foodsJson = const Value.absent(),
                Value<String> healthFeedback = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> aiProviderUsed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                imagePath: imagePath,
                totalCalories: totalCalories,
                totalProteinG: totalProteinG,
                totalCarbsG: totalCarbsG,
                totalFatG: totalFatG,
                foodsJson: foodsJson,
                healthFeedback: healthFeedback,
                mealType: mealType,
                aiProviderUsed: aiProviderUsed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String imagePath,
                required int totalCalories,
                Value<double> totalProteinG = const Value.absent(),
                Value<double> totalCarbsG = const Value.absent(),
                Value<double> totalFatG = const Value.absent(),
                required String foodsJson,
                Value<String> healthFeedback = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> aiProviderUsed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                imagePath: imagePath,
                totalCalories: totalCalories,
                totalProteinG: totalProteinG,
                totalCarbsG: totalCarbsG,
                totalFatG: totalFatG,
                foodsJson: foodsJson,
                healthFeedback: healthFeedback,
                mealType: mealType,
                aiProviderUsed: aiProviderUsed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
      Meal,
      PrefetchHooks Function()
    >;
typedef $$DailyGoalsTableCreateCompanionBuilder =
    DailyGoalsCompanion Function({
      Value<int> id,
      Value<int> calorieGoal,
      Value<int> proteinGoal,
      Value<int> carbsGoal,
      Value<int> fatGoal,
      Value<DateTime> updatedAt,
    });
typedef $$DailyGoalsTableUpdateCompanionBuilder =
    DailyGoalsCompanion Function({
      Value<int> id,
      Value<int> calorieGoal,
      Value<int> proteinGoal,
      Value<int> carbsGoal,
      Value<int> fatGoal,
      Value<DateTime> updatedAt,
    });

class $$DailyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyGoalsTable> {
  $$DailyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieGoal => $composableBuilder(
    column: $table.calorieGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinGoal => $composableBuilder(
    column: $table.proteinGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carbsGoal => $composableBuilder(
    column: $table.carbsGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fatGoal => $composableBuilder(
    column: $table.fatGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyGoalsTable> {
  $$DailyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieGoal => $composableBuilder(
    column: $table.calorieGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinGoal => $composableBuilder(
    column: $table.proteinGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carbsGoal => $composableBuilder(
    column: $table.carbsGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fatGoal => $composableBuilder(
    column: $table.fatGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyGoalsTable> {
  $$DailyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get calorieGoal => $composableBuilder(
    column: $table.calorieGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proteinGoal => $composableBuilder(
    column: $table.proteinGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carbsGoal =>
      $composableBuilder(column: $table.carbsGoal, builder: (column) => column);

  GeneratedColumn<int> get fatGoal =>
      $composableBuilder(column: $table.fatGoal, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyGoalsTable,
          DailyGoal,
          $$DailyGoalsTableFilterComposer,
          $$DailyGoalsTableOrderingComposer,
          $$DailyGoalsTableAnnotationComposer,
          $$DailyGoalsTableCreateCompanionBuilder,
          $$DailyGoalsTableUpdateCompanionBuilder,
          (
            DailyGoal,
            BaseReferences<_$AppDatabase, $DailyGoalsTable, DailyGoal>,
          ),
          DailyGoal,
          PrefetchHooks Function()
        > {
  $$DailyGoalsTableTableManager(_$AppDatabase db, $DailyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> calorieGoal = const Value.absent(),
                Value<int> proteinGoal = const Value.absent(),
                Value<int> carbsGoal = const Value.absent(),
                Value<int> fatGoal = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyGoalsCompanion(
                id: id,
                calorieGoal: calorieGoal,
                proteinGoal: proteinGoal,
                carbsGoal: carbsGoal,
                fatGoal: fatGoal,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> calorieGoal = const Value.absent(),
                Value<int> proteinGoal = const Value.absent(),
                Value<int> carbsGoal = const Value.absent(),
                Value<int> fatGoal = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyGoalsCompanion.insert(
                id: id,
                calorieGoal: calorieGoal,
                proteinGoal: proteinGoal,
                carbsGoal: carbsGoal,
                fatGoal: fatGoal,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyGoalsTable,
      DailyGoal,
      $$DailyGoalsTableFilterComposer,
      $$DailyGoalsTableOrderingComposer,
      $$DailyGoalsTableAnnotationComposer,
      $$DailyGoalsTableCreateCompanionBuilder,
      $$DailyGoalsTableUpdateCompanionBuilder,
      (DailyGoal, BaseReferences<_$AppDatabase, $DailyGoalsTable, DailyGoal>),
      DailyGoal,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> activeAiProvider,
      Value<String> driveSyncFrequency,
      Value<DateTime?> lastSyncAt,
      Value<DateTime> updatedAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> activeAiProvider,
      Value<String> driveSyncFrequency,
      Value<DateTime?> lastSyncAt,
      Value<DateTime> updatedAt,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeAiProvider => $composableBuilder(
    column: $table.activeAiProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveSyncFrequency => $composableBuilder(
    column: $table.driveSyncFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeAiProvider => $composableBuilder(
    column: $table.activeAiProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveSyncFrequency => $composableBuilder(
    column: $table.driveSyncFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activeAiProvider => $composableBuilder(
    column: $table.activeAiProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driveSyncFrequency => $composableBuilder(
    column: $table.driveSyncFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activeAiProvider = const Value.absent(),
                Value<String> driveSyncFrequency = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                activeAiProvider: activeAiProvider,
                driveSyncFrequency: driveSyncFrequency,
                lastSyncAt: lastSyncAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activeAiProvider = const Value.absent(),
                Value<String> driveSyncFrequency = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                activeAiProvider: activeAiProvider,
                driveSyncFrequency: driveSyncFrequency,
                lastSyncAt: lastSyncAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$DailyGoalsTableTableManager get dailyGoals =>
      $$DailyGoalsTableTableManager(_db, _db.dailyGoals);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
