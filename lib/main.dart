import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mis_recetas/ui/screens/home.dart';
import 'package:mis_recetas/ui/screens/add_recipe_name.dart';
import 'package:mis_recetas/ui/screens/add_recipe_category.dart';
import 'package:mis_recetas/ui/screens/add_ingredient.dart';
import 'package:mis_recetas/ui/screens/add_steps.dart';
import 'package:mis_recetas/ui/screens/add_recipe_image.dart';
import 'package:mis_recetas/ui/screens/add_recipe_difficulty.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white
      )
  );
  runApp(MyRecipes());
}

class MyRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.black
          )
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          textTheme: TextTheme(
            title: TextStyle(
              fontFamily: 'Cookie',
              fontSize: 40.0,
              color: Colors.black
            )
          )
        )
      ),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => new Home(),
          '/form1' : (BuildContext context) => new RecipeName(),
          '/form2' : (BuildContext context) => new RecipeCategory(),
          '/form3' : (BuildContext context) => new RecipeIngredients(),
          '/form4' : (BuildContext context) => new RecipeSteps(),
          '/form5' : (BuildContext context) => new RecipeDifficulty(),
          '/form6' : (BuildContext context) => new RecipeImage(),
        },
      home: Home()
    );
  }

}
