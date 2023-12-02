import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'food.dart';
import 'mealPlan.dart';

class DataBaseHelperFood {
  Future<Database> initializedDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'food.db');

    if (await databaseExists(path)) {
      return openDatabase(path);
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, version) async {
        await db.execute(
          "CREATE TABLE food(id INTEGER PRIMARY KEY, name TEXT NOT NULL,calories INTEGER NOT NULL)",
        );
      },
    );
  }

  // Takes list of food and inserts into food database
  Future<int> insertFood(List<Food> foods) async {
    int result = 0;
    final Database db = await initializedDB();
    var itemCheck = await db.rawQuery('SELECT COUNT(*) as count FROM food');
    int? numOfItems = Sqflite.firstIntValue(itemCheck);
    print(numOfItems);
    if (numOfItems!>0){
      return result;
    }
    else{
      for (var food in foods) {
        result = await db.insert('food', food.toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }
    }
    return result;
  }

  // retrieve data
  Future<List<Food>> retrieveFoods() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('food');
    return queryResult.map((e) => Food.fromMap(e)).toList();
  }

}


class DataBaseHelperMeal {
  Future<Database> initializedDBMeal() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'mealplan.db');

    if (await databaseExists(path)) {
      return openDatabase(path);
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, version) async {
        await db.execute(
          "CREATE TABLE mealplan(id INTEGER PRIMARY KEY, date TEXT NOT NULL, foodItems TEXT NOT NULL, totalCalories INTEGER NOT NULL)",
        );
      },
    );
  }

  Future<void> insertMealPlan(List<String> foods, int totalCalories, String date) async {
    final Database db = await initializedDBMeal();
    String meal = jsonEncode(foods);
    MealPlan mealPlan = MealPlan(id: 0, date: date, foodItems: meal, totalCalories: totalCalories);

    Map<String, dynamic> mealPlanMap = mealPlan.toMap();

    await db.insert('mealplan', mealPlanMap,
      conflictAlgorithm: ConflictAlgorithm.replace);

  }

  // retrieve data
  Future<List<MealPlan>> retrieveMeals() async {
    final Database db = await initializedDBMeal();
    final List<Map<String, Object?>> queryResult = await db.query('mealplan');
    return queryResult.map((e) => MealPlan.fromMap(e)).toList();
  }

}