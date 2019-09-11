import 'package:flutter/material.dart';
import 'package:mis_recetas/ui/screens/add_recipe_category.dart';
import 'package:mis_recetas/blocs/bloc_name.dart';
import 'package:mis_recetas/models/recipes.dart';

final TextEditingController textEditingController= new TextEditingController();
final NameBloc nameBloc=NameBloc();

class RecipeName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom==0.0,
        child: FloatingActionButton(
            child:Icon(Icons.arrow_forward),
            backgroundColor:Colors.black,
            onPressed: (){
              String name=textEditingController.text;
              bool validate=textEditingController.text.isNotEmpty?true:false;
              if(validate){
                //nameBloc.close();
                textEditingController.text='';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeCategory(recipe: Recipe(name: name),)),
                );
              }else{
                nameBloc.changeState(false);
              }
            }
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(15.0)),
            new Text("Elija un nombre para la receta", style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/5,
                fontFamily: 'Cookie'
            ),),
            new Padding(padding: EdgeInsets.all(20.0)),
            new NameSelector( nameBloc: nameBloc,),
          ],
        ),
      ),
    );
  }
}

class NameSelector extends StatelessWidget {
  final NameBloc nameBloc;
  NameSelector({this.nameBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: nameBloc.stateUpdates,
      builder: (context, snapshot){
        bool validate=true;
        if(snapshot!=null && snapshot.hasData){
          validate=snapshot.data;
        }
        return TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              labelText: "Ej. Arroz con pollo",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              errorText: validate?null:"Debe ingresar un nombre para su receta",
          ),
          onChanged: (text){
            nameBloc.changeState(true);
          },
          //keyboardType: TextInputType.multiline,
        );
      },
    );
  }
}

