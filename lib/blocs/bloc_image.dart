import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageBloc{
  Image _image= Image.asset('icons/no-image.jpg', fit: BoxFit.cover,);
  StreamController _streamController=StreamController<Image>.broadcast();

  Stream<Image> get imageUpdates=>_streamController.stream;
  Image get image=>this._image;

  void changeImage(File image){
    _image=Image.file(image,fit: BoxFit.cover,);
    _streamController.add(_image);
  }

  Future<String> saveImage(String name, File image) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    String path=directory.path;
    path='$path/$name.jpg';
    image.copy(path);
    return path;
  }

  void close(){
    this._image=Image.asset('icons/no-image.jpg', fit: BoxFit.cover,);
  }

}