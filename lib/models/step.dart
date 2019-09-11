import 'package:mis_recetas/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class Step
{
  //attributes
  int id;
  int num;
  String description;
  int aproxTime;
  //constructors
  Step({this.id, this.num,this.description,this.aproxTime});
  //methods
  Map<String,dynamic> toMap(op){
    return op?{
      'id':id,
      'num':num,
      'descript':description,
      'aproxTime':aproxTime
    }:{
      'num':num,
      'descript':description,
      'aproxTime':aproxTime
    };
  }
  static Future<int> insertStep(Step step) async{
    final Database db=await DbHelper().database;
    return await db.insert('step', step.toMap(false),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<void> deleteStep(int id) async{
    final Database db=await DbHelper().database;
    await db.delete('step',where: "id=?",whereArgs: [id]);
  }
  static Future<void> updateIngredient(Step step) async{
    final Database db=await DbHelper().database;
    await db.update('step', step.toMap(true),where: "id=?",whereArgs:[step.id]);
  }
  static Future<List<Step>> getAll() async {
    final Database db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('step');

    return List.generate(maps.length, (i) {
      return Step(
          id: maps[i]['id'],
          num: maps[i]['num'],
          description: maps[i]['descript'],
          aproxTime: maps[i]['aproxTime']
      );
    });
  }
  static Future<List<Step>> getStepsByRecipe(int idRecipe) async {
    String sql=
        "SELECT STEP.ID, STEP.NUM, STEP.DESCRIPT, STEP.APROXTIME "
        "FROM STEP "
        "INNER JOIN STEPLIST ON STEPLIST.IDSTEP=STEP.ID "
        "INNER JOIN RECIPE   ON STEPLIST.IDRECIPE=RECIPE.ID "
        "WHERE RECIPE.ID=?;"
    ;
    final Database db = await DbHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(sql, [idRecipe]);

    return List.generate(maps.length, (i) {
      return Step(
          id: maps[i]['id'],
          num: maps[i]['num'],
          description: maps[i]['descript'],
          aproxTime: maps[i]['aproxTime']
      );
    });
  }

  static Future<void> deleteStepsByRecipes(int idRecipe) async{
    getStepsByRecipe(idRecipe).then((data){
      data.forEach((step){
        deleteStep(step.id);
      });
    });
  }
}