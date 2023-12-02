//Define model for food
class MealPlan{
  final int id;
  final String date;
  final String foodItems;
  final int totalCalories;

  MealPlan({
    required this.id,
    required this.date,
    required this.foodItems,
    required this.totalCalories
  });

  MealPlan.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        date = result["date"],
        foodItems = result["foodItems"],
        totalCalories = result["totalCalories"];

  Map<String, Object> toMap() {
    return{
      'id': id,
      'date': date,
      'foodItems': foodItems,
      'totalCalories': totalCalories,
    };
  }
}