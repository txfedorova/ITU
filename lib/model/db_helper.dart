/// Authors: 
/// Vadim Goncearenco (xgonce00@stud.fit.vutbr.cz)
/// 

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  static const String _databaseName = 'film_database.db';

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    print('CREATING DATABASE\n\n\n\n\n\n\n');

    await db.execute('''
      CREATE TABLE films (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        releaseDate TEXT NOT NULL,
        duration TEXT,
        director TEXT,
        overview TEXT,
        actors TEXT,
        posterPath TEXT,
        UNIQUE(title, releaseDate)
      )
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        film_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (film_id) REFERENCES films (id)
      )''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_films (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_id INTEGER NOT NULL,
        film_id INTEGER NOT NULL,
        choice INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (film_id) REFERENCES films (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> clearDatabase() async {
    try {
      final databaseFile = join(await getDatabasesPath(),
          _databaseName); // Replace with your database file name

      await deleteDatabase(databaseFile);
      print('DATABASE DELETED\n\n\n');
    } catch (e) {
      print('ERROR DELETING DATABASE: $e\n\n\n');
    }
  }

  // Future<void> insertUser(String name) async {
  //   final db = await database;
  //   await db.insert(
  //     'users',
  //     {'name': name},
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   print('USER ADDED\n\n\n');
  // }

  // Future<void> deleteUser(int id) async {
  //   final db = await database;

  //   await db.transaction((txn) async {
  //     // Delete user_films associated with the user
  //     await txn.delete(
  //       'user_films',
  //       where: 'user_id = ?',
  //       whereArgs: [id],
  //     );

  //     // Delete the user
  //     await txn.delete(
  //       'users',
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   });

  //   print('USER DELETED\n\n\n');
  // }

  // Future<List<Map<String, dynamic>>> getUsers() async {
  //   final db = await database;
  //   return await db.query('users');
  // }

  // Future<String> getUserName(int id) async {
  //   final db = await database;
  //   final user = await db.query(
  //     'users',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //   print('USER NAME: ${user[0]['name']}\n\n\n');
  //   return user[0]['name'].toString();
  // }
}
