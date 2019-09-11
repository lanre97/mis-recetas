import 'package:flutter/material.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/ui/screens/add_steps.dart';
import 'package:mis_recetas/blocs/bloc_ingredients.dart';
import 'package:mis_recetas/blocs/bloc_combo_units.dart';
import 'package:mis_recetas/models/ingredient.dart';

final IngredientBloc ingredientBloc=IngredientBloc();

class RecipeIngredients extends StatelessWidget {
  final Recipe recipe;
  RecipeIngredients({this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom==0.0,
        child: ActionButton(ingredientBloc: ingredientBloc
          ,recipe: Recipe(name: recipe.name, category: recipe.category),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Form(ingredientBloc: ingredientBloc,),
            new Spacer(flex: 2,),
            new Text(
             "Ingredientes:",
             style: TextStyle(
               fontFamily: "Cookie",
               fontSize: 80.0
             ),
            ),
            new Spacer(flex: 1,),
            new ListOfIngredients(ingredientBloc: ingredientBloc,)
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Recipe recipe;
  final IngredientBloc ingredientBloc;
  ActionButton({this.ingredientBloc,this.recipe});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.black,
        onPressed: (){
          final snackBar = SnackBar(content: Text('Debe añadir al menos un ingrediente'));
          ingredientBloc.quantity>0?Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RecipeSteps(
              recipe: Recipe(name: recipe.name, category: recipe.category, ingredients: ingredientBloc.ingredients),
            )),
          ):Scaffold.of(context).showSnackBar(snackBar);
        }
    );
  }
}


final TextEditingController nameController= new TextEditingController();
final TextEditingController quantityController=new TextEditingController();

class Form extends StatelessWidget {
  final ComboUnits comboUnits=ComboUnits();
  final IngredientBloc ingredientBloc;
  Form({this.ingredientBloc});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new TextField(
            controller: nameController,
            decoration: InputDecoration(
                labelText: "Ingrediente",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                )
            ),
          ),
          new Padding(padding: EdgeInsets.all(10.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                      labelText: "Cantidad",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  keyboardType: TextInputType.number,
                ),
                flex: 10,
              ),
              new Spacer(flex: 1,),
              new DropDownButtonUnits(comboUnits: comboUnits,),
              new Spacer(flex: 1,),
              new Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: (){
                      if(nameController.text.isNotEmpty && quantityController.text.isNotEmpty){
                        ingredientBloc.addIngredient(new Ingredient(
                            name: nameController.text,
                            quantity: double.parse(quantityController.text),
                            units: comboUnits.unit
                        ));
                       nameController.text='';
                       quantityController.text='';
                      }
                    },
                    textColor: Colors.white,
                    color: Colors.black,
                    child: Text("Anadir"),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    )
                  ),
                ),
                flex: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListOfIngredients extends StatelessWidget {
  final IngredientBloc ingredientBloc;
  ListOfIngredients({this.ingredientBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ingredient>>(
      initialData: List<Ingredient>(),
      stream: ingredientBloc.ingredientsUpdates,
      builder: (context, snapshot){
        List<Ingredient> list=List<Ingredient>();
        if(snapshot!=null && snapshot.hasData){
          list=snapshot.data;
        }
        return list.isNotEmpty?Expanded(
          flex: 80,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(flex:1,child:Text('- '+list[index].name, style: TextStyle(fontSize: 20.0, ),),),
                      new Expanded(flex:1,child: Text('${list[index].quantity} ${list[index].units}.', style: TextStyle(fontSize: 20.0, ),))
                    ],
                  )
                ],
              );
            },
          ),
        ):Expanded(
          flex: 80,
          child: ListView(
            children: <Widget>[
              new Divider(),
              new Text('-', style: TextStyle(fontSize: 20.0, ),),
            ],
          ),
        );
      },
    );
  }
}


class DropDownButtonUnits extends StatelessWidget {
  final ComboUnits comboUnits;
  DropDownButtonUnits({this.comboUnits});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: comboUnits.unitUpdates,
      builder: (context, snapshot){
        int index=0;
        if(snapshot!=null && snapshot.hasData){
          index=snapshot.data;
        }
        return DropdownButton(
            value: comboUnits.units[index],
            items: comboUnits.units.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String value){
              comboUnits.changeUnit(comboUnits.units.indexOf(value));
            }
        );
      },
    );
  }
}



