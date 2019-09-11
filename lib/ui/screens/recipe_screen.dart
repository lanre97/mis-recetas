import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/models/ingredient.dart';
import 'package:mis_recetas/models/step.dart' as ModelStep;

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  RecipeScreen({this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.black),
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: recipe.img!='icons/no-image.jpg'?Image.file(File(recipe.img),fit: BoxFit.cover,):Image.asset(recipe.img,fit: BoxFit.cover,),
                ),
                brightness: Brightness.light,
              )];
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
                new Ingredients(recipe: recipe,),
                new Text(
                  'Preparación',
                  style: TextStyle(fontFamily: 'Cookie',fontSize: 50.0),
                ),
                new Preparation(recipe: recipe,),
              ],
            ),
          )
      )
    );
  }
}

class Ingredients extends StatelessWidget {
  final Recipe recipe;
  Ingredients({this.recipe});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ingredient>>(
      future: Recipe.getIngredients(recipe),
      builder: (context, snapshot){
        List<Ingredient> list;
        if(snapshot!=null && snapshot.hasData){
          list=snapshot.data;
        }
        if(list!=null && list.isNotEmpty){
          return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Divider(),
                  new Row(
                    children: <Widget>[
                      new Expanded(flex:1,child:Text('- '+list[index].name, style: TextStyle(fontSize: 20.0, ),),),
                      new Expanded(flex:1,child: Text('${list[index].quantity} ${list[index].units}'+(list[index].quantity>1?'s.':'.'), style: TextStyle(fontSize: 20.0, ),))
                    ],
                  )
                ],
              );
            },
          );
        }
        return Text('-');
      },
    );
  }
}

class Preparation extends StatelessWidget {
  final Recipe recipe;
  Preparation({this.recipe});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModelStep.Step>>(
      future: Recipe.getSteps(recipe),
      builder: (context, snapshot){
        List<ModelStep.Step> list;
        if(snapshot!=null && snapshot.hasData){
          list=snapshot.data;
        }
        if(list!=null && list.isNotEmpty){
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
        return Text('1.');
      },
    );
  }
}


