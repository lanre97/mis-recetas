import 'dart:async';

class NameBloc{
  bool _validate=true;
  StreamController _streamController=StreamController<bool>.broadcast();

  Stream<bool> get stateUpdates=>_streamController.stream;

  void changeState(bool state){
    _validate=state;
    _streamController.add(_validate);
  }
  void close(){
    _streamController.close();
  }

}