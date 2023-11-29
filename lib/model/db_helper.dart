import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
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
        year INTEGER NOT NULL,
        duration TIME,
        director TEXT,
        description TEXT,
        actors TEXT,
        image TEXT
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
}
