import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject_name TEXT NOT NULL,
      class INTEGER NOT NULL,
      report INTEGER NOT NULL,
      unit INTEGER NOT NULL,
      checks INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE texts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject_id INTEGER NOT NULL,
      class_index INTEGER NOT NULL,
      date TEXT,
      checks INTEGER NOT NULL,
      text TEXT,
      FOREIGN KEY(subject_id) REFERENCES users(id)
    )
  ''');

    await db.execute('''
CREATE TABLE report(
id INTEGER PRIMARY KEY AUTOINCREMENT,
subject_id INTEGER NOT NULL,
report_index INTEGER NOT NULL,
date TEXT,
checks INTEGER NOT NULL,
text TEXT,
FOREIGN KEY(subject_id) REFERENCES users(id)
)
''');

    await db.execute('''
CREATE TABLE deadline(
id INTEGER PRIMARY KEY AUTOINCREMENT,
date TEXT
)
''');
  }
}
