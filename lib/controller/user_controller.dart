import 'package:flutter/material.dart';

import 'package:itu_app/model/user.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:io';

class UserController {
  

  String fileName = 'data.json';

  void writeToFile(User user) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    String text = jsonEncode(user.toJson());
    await file.writeAsString(text);
    print('Data written to file [$filePath]: $text');
  }

  Future<User> readFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    String text = await file.readAsString();
    print('Data read from file [$filePath]: $text');
    return User.fromJson(jsonDecode(text));
  }

  Future<String> readFileRaw() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    return await file.readAsString();
  }
}

// https://docs.flutter.dev/cookbook/persistence/reading-writing-files