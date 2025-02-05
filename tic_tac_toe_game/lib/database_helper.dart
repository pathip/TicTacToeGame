import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("game_history.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gridSize INTEGER,
        history TEXT,
        winner TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertGame(int gridSize, List<List<String>> moves, String winner) async {
    final db = await database;
    return await db.insert('history', {
      'gridSize': gridSize,
      'history': jsonEncode(moves),
      'winner': winner,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
