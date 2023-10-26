import 'package:flutter/material.dart';
import 'package:itu_app/file_manager.dart';

class FileController extends ChangeNotifier {
  String _text = '';

  String get text => _text;

  readText() async {
    _text = await FileManager().readTextFile();
    notifyListeners();
  }

  writeTetxt() async {
    _text = await FileManager().writeTextFile();
    notifyListeners();
  }
}