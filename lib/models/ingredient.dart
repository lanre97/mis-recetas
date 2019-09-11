import 'package:mis_recetas/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class Ingredient
{
  //attributes
  final int id;
  final String name;
  final double quantity;
  final String units;
  //constructors
  Ingredient({this.id, this.name,this.quantity,this.units});
  //methods
  Map<String,dynamic> toMap(bool op){
    return op?{
      'id':id,
      'name':name,
      'quantity':quantity,
      'units':units,
    }:{
      'name':name,
      'quantity':quantity,
      'units':units,
    };
  }
  static Future<int> insertIngredient(Ingredient ingredient) async{
    final Database db=await DbHelper().database;
    return await db.insert('ingredient', ingredient.toMap(false),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<void> deleteIngredient(int id) async{
    final Database db=await DbHelper().database;
    await db.delete('ingredient',where: "id=?",whereArgs: [id]);
  }
  static Future<void> updateIngredient(Ingredient ingredient) async{
    final Database db=await DbHelper().database;
    await db.update('ingredient', ingredient.toMap(true),where: "id=?",whereArgs:[ingredient.id]);
  }
  @override
  String toString(){
    return "Ingredient {id: "+id.toString()+", Description: "+name+" "+quantity.toString()+units+"}";
  }
  static Future<List<Ingredient>> getAll() async {
    final Database db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('ingredient');

    return List.generate(maps.length, (i) {
      return Ingredient(
        id: maps[i]['id'],
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        units: maps[i]['units']
      );
    });
  }
  static Future<List<Ingredient>> getIngredientsByRecipe(int idRecipe) async {
    String sql=
        "SELECT INGREDIENT.ID, INGREDIENT.NAME, INGREDIENT.QUANTITY, INGREDIENT.UNITS "
        "FROM INGREDIENT "
        "INNER JOIN INGREDIENTLIST ON INGREDIENTLIST.IDINGREDIENT=INGREDIENT.ID "
        "INNER JOIN RECIPE ON INGREDIENTLIST.IDRECIPE=RECIPE.ID "
        "WHERE RECIPE.ID=?;"
    ;
    final Database db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(sql,[idRecipe]);

    return List.generate(maps.length, (i) {
      return Ingredient(
          id: maps[i]['id'],
          name: maps[i]['name'],
          quantity: maps[i]['quantity'],
          units: maps[i]['units']
      );
    });
  }
  static Future<void> deleteIngredientsByRecipes(int idRecipe) async{
    getIngredientsByRecipe(idRecipe).then((data){
      data.forEach((ingredient){
        deleteIngredient(ingredient.id);
      });
    });
  }
}