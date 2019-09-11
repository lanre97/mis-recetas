import 'dart:async';
import 'package:mis_recetas/models/recipes.dart';

final RecipesBloc recipesBloc=RecipesBloc();

class RecipesBloc{
  List<Recipe> _recipes;
  StreamController _streamController=StreamController<List<Recipe>>.broadcast();
  Stream<List<Recipe>> get recipesUpdates=>_streamController.stream;

  Future<void> addRecipe(Recipe recipe) async{
    Recipe.insertRecipe(recipe, recipe.steps, recipe.ingredients);
    _recipes= await Recipe.getAll();
    _streamController.add(_recipes);
  }
  Future<void> deleteRecipe(Recipe recipe) async{
    Recipe.deleteRecipe(recipe);
    _recipes= await Recipe.getAll();
    _streamController.add(_recipes);
  }
  Future<void>init()async{
    _recipes=await Recipe.getAll();
    _streamController.add(_recipes);
  }

}