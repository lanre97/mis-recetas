enum Categories{ACCOMPANIMENT,SNACKS, BREAKFASTS, SALADS, STARTERS, BREADS, MAIN_COURSES, DESSERTS, SAUCES, SOUPS_AND_CREAMS}

class Category{
  final String name;
  final int index;

  List<Category>_list;
  Category({this.index,this.name});
  List<Category> get list{
    _list=[
      new Category(index:Categories.ACCOMPANIMENT.index,name:"Acompañamientos"),
      new Category(index:Categories.SNACKS.index,name:"Bocaditos"),
      new Category(index:Categories.BREAKFASTS.index,name:"Desayunos"),
      new Category(index:Categories.SALADS.index,name:"Ensaladas"),
      new Category(index:Categories.STARTERS.index,name:"Entradas"),
      new Category(index:Categories.BREADS.index,name:"Panes"),
      new Category(index:Categories.MAIN_COURSES.index,name:"Platos principales"),
      new Category(index:Categories.DESSERTS.index,name:"Postres"),
      new Category(index:Categories.SAUCES.index,name:"Salsas"),
      new Category(index:Categories.SOUPS_AND_CREAMS.index,name:"Sopas y Cremas"),
    ];
    return this._list;
  }
}