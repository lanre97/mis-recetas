import 'package:flutter/material.dart';
import 'package:mis_recetas/blocs/bloc_category.dart';
import 'package:mis_recetas/models/recipes.dart';
import 'package:mis_recetas/ui/screens/add_ingredient.dart';
import 'package:mis_recetas/ui/widgets/categories_swiper.dart';

final CategoryList categoryList=CategoryList();

class RecipeCategory extends StatelessWidget {
  final Recipe recipe;
  RecipeCategory({this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.black,
        onPressed: ()=>Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecipeIngredients(
              recipe: Recipe(
                  name: recipe.name,
                  category: categoryList.category
              )
          ))
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top:20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(20.0),
              child: Text("Seleccione una categoría",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width/5,
                  fontFamily: 'Cookie'
              )),
            ),
            new Spacer(flex: 1,),
            new Expanded(
              flex: 15,
              child:CategoriesSwiper(categoryList: categoryList,)
            ),
            new Spacer(flex: 8,),
          ],
        ),
      ),
    );
  }
}
