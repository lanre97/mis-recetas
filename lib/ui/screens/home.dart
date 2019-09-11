import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/ui/screens/add_recipe_name.dart';
import 'package:mis_recetas/blocs/bloc_recipes.dart' as RecipeBloc;
import 'package:mis_recetas/ui/screens/recipe_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecipeBloc.recipesBloc.init();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.black,
        onPressed: ()=>Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeName()),
        ),
      ),
      appBar: AppBar(
          title: Text("Mis recetas")
      ),
      body: Container(
        child: RecipeList()
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: RecipeBloc.recipesBloc.recipesUpdates,
      builder: (context, snapshot){
        List<Recipe> list;
        if(snapshot!=null && snapshot.hasData){
          list=snapshot.data;
        }
        return (list!=null && list.isNotEmpty)?
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){
           return GestureDetector(
             child: RecipeCard(recipe: list[index],),
             onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => RecipeScreen(recipe: list[index],)),
               );
             },
             onLongPress: (){
               showDialog(context: context, builder: (context){
                 return DeleteDialog(recipe:list[index]);
               });
             },
           );
          }
        ):
        Center(
          child: Text("Aún no tienes recetas", style: TextStyle(color: Colors.grey),),
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  RecipeCard({this.recipe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:5.0,left: 5.0, right: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width-15.0,
        height: MediaQuery.of(context).size.height/2.5,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                  child: Container(
                    child: recipe.img!='icons/no-image.jpg'?Image.file(File(recipe.img),fit: BoxFit.cover,):Image.asset(recipe.img,fit: BoxFit.cover,),
                  ),
                  flex: 4,),
                new Expanded(
                  child: Center(child: ListTile(title: Text(recipe.name),subtitle: Text('Dificultad: ${recipe.difficulty}'),),),
                  flex: 2,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final Recipe recipe;
  DeleteDialog({this.recipe});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("¿Desea borrar esta receta?"),
      content: Text("La eliminación de una receta es irreversible"),
      actions: <Widget>[
        new FlatButton(onPressed: (){
          Navigator.of(context).pop();
        },child: Text("Cancelar")),
        new FlatButton(onPressed: (){
          RecipeBloc.recipesBloc.deleteRecipe(recipe).then((value){
            Navigator.of(context).pop();
          });
        },child: Text("Aceptar")),
      ],
    );
  }
}



