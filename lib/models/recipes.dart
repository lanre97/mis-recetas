import 'dart:io';

import 'package:mis_recetas/database/db_helper.dart';
import 'package:mis_recetas/models/step.dart';
import 'package:sqflite/sqflite.dart';

import 'ingredient.dart';

class Recipe
{
  //attributes
  final int id;
  final int category;
  final String name;
  final String img;
  final String difficulty;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  //constructor
  Recipe({this.id, this.name,this.category, this.img, this.difficulty, this.ingredients, this.steps});
  //methods
  Map<String,dynamic> toMap(bool op){
    return op?{
      'id':id,
      'name':name,
      'category':category,
      'img':img,
      'difficult':difficulty
    }:{
      'name':name,
      'category':category,
      'img':img,
      'difficult':difficulty
    };
  }
  static Future<int> insertRecipe(Recipe recipe, List<Step> steps, List<Ingredient> ingredients) async{
    final Database db=await DbHelper().database;
    final Map<String, dynamic> recipeMap=recipe.toMap(false);
    int idRecipe=await db.insert('recipe', recipeMap,conflictAlgorithm: ConflictAlgorithm.replace);
    //insert list of steps
    steps.forEach((step){
      Step.insertStep(step).then((id){
        insertStepList(id, idRecipe);
      });
    });
    //insert list of ingredients
    ingredients.forEach((ingredient){
      Ingredient.insertIngredient(ingredient).then((id){
        insertIngredientList(id, idRecipe);
      });
    });
    return idRecipe;
  }
  static Future<void> insertStepList(int stepId, int recipeId) async{
    final Database db=await DbHelper().database;
    await db.rawInsert("INSERT INTO STEPLIST(idRecipe, idStep) VALUES(?,?);",[recipeId,stepId]);
  }
  static Future<void> insertIngredientList(int ingredientId, int recipeId) async{
    final Database db=await DbHelper().database;
    await db.rawInsert("INSERT INTO INGREDIENTLIST(idRecipe, idINGREDIENT) VALUES(?,?);",[recipeId,ingredientId]);
  }
  static Future<void> deleteRecipe(Recipe recipe) async{
    int id=recipe.id;
    File image=File(recipe.img);
    image.delete();
    deleteIngredients(id).then((value){
      deleteSteps(id).then((value)async{
        final Database db=await DbHelper().database;
        await db.delete('recipe',where: "id=?",whereArgs: [id]);
      });
    });
  }
  static Future<void> deleteSteps(int id) async{
    Step.deleteStepsByRecipes(id);
    final Database db=await DbHelper().database;
    await db.delete('stepList',where: "idRecipe=?",whereArgs: [id]);
  }
  static Future<void> deleteIngredients(int id) async{
    Ingredient.deleteIngredientsByRecipes(id);
    final Database db=await DbHelper().database;
    await db.delete('ingredientList',where: "idRecipe=?",whereArgs: [id]);
  }
  static Future<void> updateRecipe(Recipe recipe) async{
    final Database db=await DbHelper().database;
    await db.update('recipe', recipe.toMap(true),where: "id=?",whereArgs:[recipe.id]);
  }
  static Future<List<Recipe>> getAll() async {
    final Database db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('recipe');

    List<Recipe> recipes = List.generate(maps.length, (i) {
      return Recipe(
          id: maps[i]['id'],
          name: maps[i]['name'],
          category: maps[i]['category'],
          img: maps[i]['img'],
          difficulty: maps[i]['difficult']
      );
    });
    return recipes;
  }
  static Future<List<Step>> getSteps(Recipe recipe) async{
    return await Step.getStepsByRecipe(recipe.id);
  }
  static Future<List<Ingredient>> getIngredients(Recipe recipe) async{
    return await Ingredient.getIngredientsByRecipe(recipe.id);
  }
}