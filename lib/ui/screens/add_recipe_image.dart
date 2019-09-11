import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mis_recetas/models/ingredient.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/models/step.dart' as RecipeStep;
import 'package:mis_recetas/blocs/bloc_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mis_recetas/ui/screens/add_steps.dart' as ScreenSteps;
import 'package:mis_recetas/ui/screens/add_ingredient.dart' as ScreenIngredients;
import 'package:mis_recetas/blocs/bloc_recipes.dart' as RecipeBloc;

final ImageBloc imageBloc=ImageBloc();
File imageFile;

class RecipeImage extends StatelessWidget {
  final Recipe recipe;
  RecipeImage({this.recipe});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        label: Text('Guardar receta'),
        backgroundColor: Colors.black,
        onPressed: ()async {
          String path=(imageFile!=null)?(await imageBloc.saveImage(recipe.name, imageFile)):"icons/no-image.jpg";
          RecipeBloc.recipesBloc.addRecipe(
              Recipe(
                name: recipe.name,
                category: recipe.category,
                difficulty: recipe.difficulty,img: path,
                ingredients: recipe.ingredients,
                steps: recipe.steps))
              .then((value){
                ScreenIngredients.ingredientBloc.close();
                ScreenSteps.stepsBloc.close();
                ScreenSteps.durationBloc.close();
                imageBloc.close();
                imageFile=null;
                Navigator.pop(context);
              }
          );

        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: AppbarImage(imageBloc: imageBloc,),
              ),
              actions: <Widget>[
                new IconButton(
                  icon: Icon(Icons.edit, size: 30.0,color: Colors.grey,),
                  onPressed: ()async{
                    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                    imageBloc.changeImage(imageFile);
                  },
                )
              ],
              brightness: Brightness.light,
            )
          ];
        },
        body: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: ListView(
            children: <Widget>[
              new Text(
                recipe.name,
                style: TextStyle(fontFamily: 'Cookie',fontSize: MediaQuery.of(context).size.width/5),
              ),
              new Container(
                alignment: Alignment.topRight,
                child:  Text(
                  'Dificultad: ${recipe.difficulty}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              new Text(
                'Ingredientes',
                style: TextStyle(fontFamily: 'Cookie',fontSize: 50.0),
              ),
              new Ingredients(ingredients: recipe.ingredients,),
              new Text(
                'Preparación',
                style: TextStyle(fontFamily: 'Cookie',fontSize: 50.0),
              ),
              new Preparation(list: recipe.steps,),
            ],
          ),
        )
      )
    );
  }
}

class Ingredients extends StatelessWidget {
  final List<Ingredient> ingredients;
  Ingredients({this.ingredients});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: ingredients.length,
        itemBuilder: (context, index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Divider(),
              new Row(
                children: <Widget>[
                  new Expanded(flex:1,child:Text('- '+ingredients[index].name, style: TextStyle(fontSize: 20.0, ),),),
                  new Expanded(flex:1,child: Text('${ingredients[index].quantity} ${ingredients[index].units}'+(ingredients[index].quantity>1?'s.':'.'), style: TextStyle(fontSize: 20.0, ),))
                ],
              )
            ],
          );
        },
      )
    );
  }
}

class Preparation extends StatelessWidget {
  final List<RecipeStep.Step> list;
  Preparation({this.list});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
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
      ),
    );
  }
}

class AppbarImage extends StatelessWidget {
  final ImageBloc imageBloc;
  AppbarImage({this.imageBloc});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Image>(
      stream: imageBloc.imageUpdates,
      builder: (context, snapshot){
        /*Image image=Image.asset('icons/no-image.jpg', fit: BoxFit.fitWidth,);
        if(snapshot!=null && snapshot.hasData){
          image=snapshot.data;
        }*/
        return imageBloc.image;
      },
    );
  }
}



