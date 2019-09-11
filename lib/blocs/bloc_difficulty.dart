import 'dart:async';

class DifficultyBloc{
  int _index=1;
  StreamController _streamController=StreamController<int>.broadcast();

  Stream<int> get difficultyUpdates=>_streamController.stream;
  int get difficulty=>this._index;

  void changeDifficulty(int index){
    _index=index;
    _streamController.add(_index);
  }

  void close(){
    _streamController.close();
  }
}