import 'dart:async';
import 'package:mis_recetas/models/step.dart';

class StepsBloc{
  List<Step> _steps= List<Step>();
  StreamController _streamController=StreamController<List<Step>>.broadcast();

  Stream<List<Step>> get stepsUpdates=>_streamController.stream;
  int get quantity=>_steps.length;
  List<Step> get steps=>this._steps;

  void addStep(Step step){
    _steps.add(step);
    _streamController.add(_steps);
  }

  void close(){
    this._steps.clear();
  }
}