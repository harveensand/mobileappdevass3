//Define model for food
class Food{
  final int id;
  final String name;
  final int calories;

  Food({
    required this.id,
    required this.name,
    required this.calories
  });

  Food.fromMap(Map<String, dynamic> result)
    : id = result["id"],
      name = result["name"],
      calories = result["calories"];

  Map<String, Object> toMap() {
    return{
      'name': name,
      'calories': calories
    };
  }
}