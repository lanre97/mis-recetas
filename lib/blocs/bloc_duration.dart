import 'dart:async';

class DurationBloc{
  Duration _duration=Duration(minutes: 1);
  StreamController _streamController=StreamController<Duration>.broadcast();

  Stream<Duration> get durationUpdates=>_streamController.stream;
  int get minutes=>_duration.inMinutes;

  void changeDuration(Duration duration){
    _duration=duration;
    _streamController.add(_duration);
  }

  void close(){
    _duration=Duration(minutes: 1);
  }

}