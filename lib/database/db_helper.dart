import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DbHelper
{
  static final DbHelper db=DbHelper();
  static Database _database;

  Future<Database> get database async{
    if(_database!=null)return _database;
    _database=await initDatabase();
    return _database;
  }
  static Future<String> get dbPath async{
    return getDatabasesPath();
  }
  static Future<Database> initDatabase() async{
    var databasesPath = await dbPath;
    var path= join(databasesPath,'dbRecetas.db');
    return await openDatabase(path,version: 1,onOpen: (db){
    },onCreate: (Database db,int version)async{
      await db.execute(
        "CREATE TABLE INGREDIENT("+
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"+
        "name VARCHAR(40) NOT NULL,"+
        "quantity FLOAT NOT NULL,"+
        "units VARCHAR(5) NOT NULL);"
      );
      await db.execute(
        "CREATE TABLE STEP("+
            "id integer primary key AUTOINCREMENT not null,"+
            "num integer not null,"+
            "descript varchar(200) not null,"+
            "aproxTime int nulL);"
      );
      await db.execute(
        "CREATE  TABLE RECIPE("+
            "id integer primary key AUTOINCREMENT not null,"+
            "category integer not null,"+
            "name varchar(45) not null,"+
            "img varchar(250) null,"+
            "difficult varchar(40) null);"

      );
      await db.execute(
        "create table StepList("+
            "idRecipe integer not null,"+
            "idStep integer not null,"+
            "primary key(idRecipe,idStep),"+
            "foreign key (idRecipe) references Recipe(id),"+
            "foreign key (idStep) references Step(id));"
      );
      /*await db.execute(
        "alter table stepList "+
        "add constraint pk_steplist "+
        "primary key(idRecipe, idstep);"
      );*/

      /*await db.execute(
        "alter table steplist "+
            "add constraint pk_step_recipe "+
            "foreign key (idRecipe) references Recipe(id);"
      );*/
      /*await db.execute(
        "alter table steplist "+
            "add constraint pk_step "+
            "foreign key (idStep) references Step(id);"
      );*/
      await db.execute(
        "create table IngredientList("+
            "idRecipe integer not null,"+
            "idIngredient integer not null,"
            "primary key(idRecipe,idIngredient),"+
            "foreign key (idRecipe) references Recipe(id),"+
            "foreign key (idIngredient) references Ingredient(id));"
      );
      /*await db.execute(
        "alter table IngredientList "+
            "add constraint pk_inglist "+
            "primary key(idRecipe, idIngredient);"
      );*/
      /*await db.execute(
        "alter table IngredientList "+
            "add constraint pk_ing_recipe "+
            "foreign key (idRecipe) references Recipe(id);"
      );
      await db.execute(
        "alter table Ingredientlist "+
            "add constraint fk_ing "+
            "foreign key (idIngredient) references Ingredient(id);"
      );*/
    });
  }
}