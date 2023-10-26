import 'package:flutter/material.dart';

import 'package:itu_app/model/content_model.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:io';
//import 'package:path_provider/path_provider.dart';

class ContentController {
  final TextEditingController textEditingController = TextEditingController();
  ContentModel contentModel = ContentModel();

  String fileName = 'data.json';

  void writeToFile() async {
    contentModel.content = textEditingController.text;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(jsonEncode(contentModel.toJson()));
    print('Data written to file [$filePath]: ${textEditingController.text}');
  }

  // Future<String> readFileRaw() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final file = File(filePath);
  //   return await file.readAsString();
  // }
}