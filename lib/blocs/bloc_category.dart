import 'dart:async';

class CategoryList{
  int _index;
  StreamController _streamController=StreamController<int>.broadcast();

  Stream<int> get categoryUpdates=>_streamController.stream;
  int get category=>_index;

  void changeCategory(int index){
    _index=index;
    _streamController.add(_index);
  }

  void close(){
    _streamController.close();
  }

}