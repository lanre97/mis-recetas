import 'dart:async';
import 'package:mis_recetas/models/ingredient.dart';

class IngredientBloc{
  List<Ingredient> _ingredients= List<Ingredient>();
  StreamController _streamController=StreamController<List<Ingredient>>.broadcast();

  Stream<List<Ingredient>> get ingredientsUpdates=>_streamController.stream;
  int get quantity=>_ingredients.length;
  List<Ingredient> get ingredients=>this._ingredients;

  void addIngredient(Ingredient ingredient){
    _ingredients.add(ingredient);
    _streamController.add(_ingredients);
  }

  void close(){
    _ingredients.clear();
  }

}
