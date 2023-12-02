import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'food.dart';
import 'package:intl/intl.dart';
import 'databaseHelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Assignment 3 - MealPlan'),
    );
  }
}

//Homepage widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: mealPlan(),
      ),
      //Open the add meal plan when user pushes floating action button
      floatingActionButton: FloatingActionButton(
        //Define the floating button so that it can launch the
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateMealPlan()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//Create meal plan widget
class CreateMealPlan extends StatefulWidget{
  const CreateMealPlan({Key? key}) : super(key:key);

  @override
  State<CreateMealPlan> createState() => _CreateMealPlan();
}

class _CreateMealPlan extends State<CreateMealPlan>{
  //Declare and define text editing controllers
  TextEditingController dateController = TextEditingController();
  TextEditingController targetCalorieController = TextEditingController();
  //Declare database helper for food
  late DataBaseHelperFood dbHelperFood;
  late DataBaseHelperMeal dbHelperMeal;
  //Declare isChecked variable to determine if user has selected a specific food item
  List<bool> isChecked = List<bool>.filled(20, false);
  //Declare variable to hold total calories
  var totalCalories = 0;
  int targetCalories = 0;



  //Define addFood function to define food items
  Future<int> addFoods() async {
    Food banana =
      Food(id: 1, name: "Banana", calories: 89);
    Food carrot =
      Food(id: 2, name: "Carrot", calories: 41);
    Food chickenBreast =
      Food(id: 3, name: "Chicken Breast", calories: 165);
    Food pintoBeans =
      Food(id: 4, name: "Pinto Beans", calories: 347);
    Food groundTurkey =
      Food(id: 5, name: "Ground Turkey", calories: 189);
    Food grape =
      Food(id: 6, name: "Grape", calories: 67);
    Food groundBeef =
      Food(id: 7, name: "Ground Beef", calories: 250);
    Food bacon =
      Food(id: 8, name: "Bacon", calories: 541);
    Food oats =
      Food(id: 9, name: "Oats", calories: 389);
    Food egg =
      Food(id: 10, name: "Egg", calories: 155);
    Food salmon =
      Food(id: 11, name: "Salmon", calories: 208);
    Food greekYogurt =
      Food(id: 12, name: "Greek Yogurt", calories: 59);
    Food blackBeans =
      Food(id: 13, name: "Black Beans", calories: 541);
    Food tuna =
      Food(id: 14, name: "Tuna", calories: 132);
    Food apple =
      Food(id: 15, name: "Apple", calories: 52);
    Food orange =
      Food(id: 16, name: "Orange", calories: 47);
    Food potato =
      Food(id: 17, name: "Potato", calories: 110);
    Food whiteRice =
      Food(id: 18, name: "White Rice", calories: 130);
    Food broccoli =
      Food(id: 19, name: "Broccoli", calories: 34);
    Food brownRice =
      Food(id: 20, name: "Brown Rice", calories: 111);


    //Store food items on to list
    List<Food> foods = [
      banana,
      carrot,
      chickenBreast,
      pintoBeans,
      groundTurkey,
      grape,
      groundBeef,
      bacon,
      oats,
      egg,
      salmon,
      greekYogurt,
      blackBeans,
      tuna,
      apple,
      orange,
      potato,
      whiteRice,
      broccoli,
      brownRice
    ];

    //Call insert food function with foodList
    return await dbHelperFood.insertFood(foods);
  }

  //Use initState to add food to database
  @override
  void initState() {
    super.initState();
    dbHelperMeal = DataBaseHelperMeal();
    dbHelperMeal.initializedDBMeal().whenComplete(() async {
      setState(() {
      });
    });
    dbHelperFood = DataBaseHelperFood();
    dbHelperFood.initializedDB().whenComplete(() async {
        await addFoods();
        setState(() {
        });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Meal Plan"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                controller: targetCalorieController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Target Calories per Day",
                ),
                keyboardType: TextInputType.number
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    //Use showDatePicker to select date of meal plan
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100)
                    );
                    //If the user has selected a date, save date in year/month/day format and change text editor r
                    if (pickedDate != null){
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                }
              ),
            ),
            //Use the future builder to call database for food list and to create list of food
            FutureBuilder(
                future: dbHelperFood.retrieveFoods(),
                builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot){
                    if (snapshot.hasData){
                      return Container(
                        height: 400,
                        child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                  final String name = snapshot.data![index].name;
                                  final int calories = snapshot.data![index].calories;
                                  return CheckboxListTile(
                                      title: Text(name),
                                      subtitle: Text(calories.toString()),
                                      value: isChecked[index],
                                      onChanged: (value) {
                                        setState(() {
                                          int error = 0;

                                          try{
                                            targetCalories = int.parse(targetCalorieController.text);
                                            } catch(e){
                                              var snackBar = const SnackBar(content: Text('Invalid target calorie value. Please input a number'));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              isChecked[index] = false;
                                              error = 1;
                                            }

                                          if ((totalCalories + calories)>targetCalories && (value == true)){
                                            value = false;
                                            error = 1;
                                            var snackBar = const SnackBar(content: Text('Total calorie exceeds target calories'));
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          }
                                          else if ((value == true) && (error == 0)){
                                            totalCalories = totalCalories + calories;
                                            isChecked[index] = value!;
                                          }
                                          else if ((value == false) && (error==0)) {
                                            totalCalories = totalCalories - calories;
                                            isChecked[index] = value!;
                                          }
                                        });
                                      },
                                  );
                              },
                          ),
                      );
                    } else {
                      //If the data doesn't load, show circular progress indicator
                      return const Center(child: CircularProgressIndicator());
                    }
                }

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 50, 0, 0),
              child: Text('Total Calories - $totalCalories'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String date = dateController.text;
          final List<Food> foods = await dbHelperFood.retrieveFoods();
          List<String> mealPlan = [];
          for (int i = 0; i<20;i++){
            if (isChecked[i] == true){
              print(foods[i].name);
              mealPlan.add(foods[i].name);
              print(mealPlan);
            }
          }

          dbHelperMeal.insertMealPlan(mealPlan, totalCalories,date);
        },


        tooltip: 'Increment',
        child: const Icon(Icons.save),
      ),
    );
  }
}

class mealPlan extends StatefulWidget {
@override
_mealPlanState createState() => _mealPlanState();
}

class _mealPlanState extends State<mealPlan> {
  @override
  Widget build(BuildContext context) {
    // Your widget's UI goes here
    return Center(
      child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mealplans")
            ],
      )
    );
  }
}



