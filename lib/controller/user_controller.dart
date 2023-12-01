import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:itu_app/model/db_helper.dart';

class UserController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addUser(String name) async {
    await _dbHelper.insertUser(name);
  }

  Future<void> removeUser(int id) async {
    await _dbHelper.deleteUser(id);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _dbHelper.getUsers();
  }
}