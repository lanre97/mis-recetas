import 'package:flutter/material.dart';
import 'package:mis_recetas/blocs/bloc_category.dart';
import 'package:mis_recetas/models/category.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

final Category category=Category();

class CategoriesSwiper extends StatelessWidget {
  final CategoryList categoryList;
  CategoriesSwiper({this.categoryList});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: categoryList.categoryUpdates,
      builder: (context, snapshot){
        int idx=0;
        if(snapshot!=null && snapshot.hasData){
          idx=snapshot.data>0?snapshot.data-1:category.list.length-1;
          return Column(
            children: <Widget>[
              new Expanded(
                child: Swiper(
                  itemBuilder: (BuildContext context,int index){
                    categoryList.changeCategory(index);
                    return SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset('icons/${Categories.values[index].index}.jpg',fit: BoxFit.cover,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      ),
                    );
                  },
                  itemCount: Categories.values.length,
                  viewportFraction: 0.7,
                  scale: 0.9,
                ),
              ),
              new Padding(padding: EdgeInsets.all(5.0)),
              new Text(
                category.list[idx].name,
                style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Cookie'
                ),
              ),
            ],
          );
                }
        return CircularProgressIndicator();
      },
    );
  }
}
