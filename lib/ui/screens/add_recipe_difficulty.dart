import 'package:flutter/material.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/ui/screens/add_recipe_image.dart';
import 'package:mis_recetas/blocs/bloc_difficulty.dart';

final DifficultyBloc difficultyBloc=DifficultyBloc();

class RecipeDifficulty extends StatelessWidget {
  final Recipe recipe;
  RecipeDifficulty({this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.black,
        onPressed: (){
          String difficulty;
          switch(difficultyBloc.difficulty){
            case 0:difficulty="Principiante";break;
            case 1:difficulty="Intermedio";break;
            case 2:difficulty="Avanzado";break;
            default:difficulty="Intermedio";break;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RecipeImage(
              recipe: Recipe(
                  name: recipe.name,
                  category: recipe.category,
                  ingredients: recipe.ingredients,
                  steps: recipe.steps,
                  difficulty: difficulty
              ),
            )),
          );
        }
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Spacer(flex: 1,),
            new Container(
              padding: EdgeInsets.all(20.0),
              child: Text("Defina el nivel de dificultad",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/5,
                      fontFamily: 'Cookie'
                  )
              ),
            ),
            new Spacer(flex: 1  ,),
            new DifficultyList(difficultyBloc: difficultyBloc,),
            new Spacer(flex: 4,),
          ],
        ),
      ),
    );
  }
}
class Difficulty extends StatelessWidget {
  final String text;
  final bool selected;
  Difficulty({this.text,this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected?Colors.grey.withAlpha(80):Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20.0),
        child: new Text(this.text,style: TextStyle(fontFamily: 'Cookie',fontSize: 40.0)),
      )
    );
  }
}

class DifficultyList extends StatelessWidget {
  final DifficultyBloc difficultyBloc;
  DifficultyList({this.difficultyBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: difficultyBloc.difficultyUpdates,
      builder: (context, snapshot){
        int index=1;
        if(snapshot!=null && snapshot.hasData){
          index=snapshot.data;
        }
        return Column(
          children: <Widget>[
            new GestureDetector(
              child:new Difficulty(text:"Principiante",selected: index==0?true:false,),
              onTap: (){
                difficultyBloc.changeDifficulty(0);
              },
            ),
            new GestureDetector(
              child:new Difficulty(text:"Intermedio",selected: index==1?true:false,),
              onTap: (){
                difficultyBloc.changeDifficulty(1);
              },
            ),
            new GestureDetector(
              child:new Difficulty(text:"Avanzado",selected: index==2?true:false,),
              onTap: (){
                difficultyBloc.changeDifficulty(2);
              },
            ),
          ],
        );
      },
    );
  }
}


