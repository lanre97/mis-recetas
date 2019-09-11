import 'dart:async';

class ComboUnits{
  int _index=0;
  StreamController _streamController=StreamController<int>.broadcast();
  final List<String> units=['und', 'cda', 'cdta', 'tza', 'ml','l','kg','g','mg','oz','fl. oz'];

  Stream<int> get unitUpdates=>_streamController.stream;

  String get unit=>units[_index];

  void changeUnit(int index){
    _index=index;
    _streamController.add(_index);
  }

  void close(){
    _streamController.close();
  }

}