import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:itu_app/model/film.dart';
import 'package:itu_app/model/db_helper.dart';

class FilmsModel extends ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  //List<Film> _films = [Film(0, "Film0"), Film(1, "Film1")];

  //int _lastId = 2;

  //get length => _films.length;

  //bool contains(Film film) => _films.contains(film);
  
  Future<void> insertFilm(Film film) async {
    final db = await databaseHelper.database;
    await db.insert('films', 
      film.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<List<Film>> films() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('films');
    return List.generate(maps.length, (i) {
      return Film(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
      );
    });
  }

  Future<Film> film(int id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('films', where: 'id = ?', whereArgs: [id]);
    return Film(
      id: maps[0]['id'] as int,
      title: maps[0]['title'] as String,
    );
  }
  
  Future<void> updateFilm(Film film) async {
    final db = await databaseHelper.database;
    await db.update('films', film.toMap(), where: 'id = ?', whereArgs: [film.id]);
    notifyListeners();
  }

  Future<void> deleteFilm(int id) async {
    final db = await databaseHelper.database;
    await db.delete('films', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }

  // void add(String title) {
  //   _films.add(Film(_lastId++, title));
  //   notifyListeners();
  // }

  // void delete(Film film) {
  //   _films.remove(film);
  //   notifyListeners();
  // }
  /// Get item by [id].
  //Film getById(int id) => _films[id];

  /// Get item by its position in the catalog.
  // Film getByPosition(int position) {
  //   // In this simplified case, an item's position in the catalog
  //   // is also its id.
  //   return getById(position);
  // }
}


//https://docs.flutter.dev/data-and-backend/serialization/json