import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/ui/screens/add_recipe_difficulty.dart';
import 'package:mis_recetas/blocs/bloc_duration.dart';
import 'package:mis_recetas/blocs/bloc_steps.dart';
import 'package:mis_recetas/models/step.dart'as ModelStep;
import 'package:flutter/services.dart';

final TextEditingController textEditingController= new TextEditingController();
final StepsBloc stepsBloc=StepsBloc();
final DurationBloc durationBloc=DurationBloc();

class RecipeSteps extends StatelessWidget {
  final Recipe recipe;
  RecipeSteps({this.recipe});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom==0.0,
        child: FloatingActionButton(
          child: Icon(Icons.arrow_forward),
          backgroundColor: Colors.black,
          onPressed: ()=>Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RecipeDifficulty(
              recipe: Recipe(name: recipe.name, category: recipe.category, ingredients: recipe.ingredients, steps: stepsBloc.steps),
            )),
          ),
        ),
      ),
      body:Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child:ListView(
          children: <Widget>[
            new Container(
                padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: DurationPickerSelection(durationBloc: durationBloc,)
            ),
            new TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  labelText: "Describe los pasos a seguir",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  )
              ),
              maxLines: null,
              //keyboardType: TextInputType.multiline,
            ),
            new Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: RaisedButton(
                    onPressed: (){
                      if(textEditingController.text.isNotEmpty)stepsBloc.addStep(new ModelStep.Step(num: stepsBloc.quantity+1
                          ,description: textEditingController.text,
                          aproxTime: durationBloc.minutes));
                      textEditingController.text='';
                    },
                    textColor: Colors.white,
                    color: Colors.black,
                    child: Text("Anadir", style: TextStyle(fontSize: 15.0),),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    )
                ),
              ),
            ),
            new Text("Preparación",style: TextStyle(fontFamily: "Cookie", fontSize: MediaQuery.of(context).size.width/5),),
            new ListOfSteps(stepsBloc: stepsBloc,),
          ],
        )
      )
    );
  }
}

class DurationPickerSelection extends StatelessWidget {
  final DurationBloc durationBloc;
  DurationPickerSelection({this.durationBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      initialData: Duration(minutes: 1),
      stream: durationBloc.durationUpdates,
      builder: (context, snapshot){
        Duration duration =Duration(minutes: 1);
        if(snapshot!=null && snapshot.hasData){
          duration=snapshot.data;
        }
        return DurationPicker(
          width:MediaQuery.of(context).size.width/1.8,
          height:MediaQuery.of(context).size.width/1.8,
          duration: duration,
          //snapToMins: 1.0,
          onChange: (Duration value){
            durationBloc.changeDuration(value);
          },
        );
      },
    );
  }
}

class ListOfSteps extends StatelessWidget {
  final StepsBloc stepsBloc;
  ListOfSteps({this.stepsBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ModelStep.Step>>(
      initialData: List<ModelStep.Step>(),
      stream: stepsBloc.stepsUpdates,
      builder: (context, snapshot){
        List<ModelStep.Step> list=List<ModelStep.Step>();
        if(snapshot!=null && snapshot.hasData){
          list=snapshot.data;
        }
        return list.isNotEmpty?
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Divider(),
                new Text('${list[index].num}. ${list[index].description}${(list[index].description[list[index].description.length-1]!='.')?'.':''} Tiempo aproximado '+
                    ((list[index].aproxTime/60).floor()>0?'${(list[index].aproxTime/60).floor()}h. ${list[index].aproxTime%60}min.':'${list[index].aproxTime%60}min.'),
                  style: TextStyle(fontSize: 20.0, ),),
              ],
            );
          },
        ):ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            new Divider(),
            new Text('1.'),
          ],
        );
      },
    );
  }
}

