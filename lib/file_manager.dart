import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager _instance = FileManager._internal();

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      return directory.path;
    } else {
      print('Directory is null');
      return '';
    }
  }

  Future<File> get _file async {
    final path = await _directoryPath;
    return File('$path/counter.txt');
  }

  readTextFile() async {
    String fileContent = 'test';

    File file = await _file;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('File does not exist');
    }

    return fileContent;
  }

  Future<String> writeTextFile() async {
    String text = DateFormat('h:mm:ss').format(DateTime.now());
    File file = await _file;
    await file.writeAsString(text);
    return text;
  }
}