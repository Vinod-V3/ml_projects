import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Database? _database;

  Future<void> initialize({required String dbName}) async {
    if (_database != null) {
      debugPrint('Database already initialized');
      return;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, '$dbName.db');

    debugPrint('Initializing database at: $path');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        debugPrint('Database created with version $version');
      },
    );

    debugPrint('Database initialized successfully');
  }

  Future<void> _ensureTableExists(String tableName) async {
    if (_database == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }

    final result = await _database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );

    if (result.isEmpty) {
      await _database!.execute('''
        CREATE TABLE $tableName (
          id TEXT PRIMARY KEY,
          data TEXT NOT NULL
        )
      ''');
      debugPrint('Created table: $tableName');
    }
  }

  Future<void> saveData(String tableName, String id, String jsonData) async {
    await _ensureTableExists(tableName);

    await _database!.insert(
      tableName,
      {'id': id, 'data': jsonData},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    debugPrint('Saved data to $tableName with id: $id');
  }

  Future<String?> getData(String tableName, String id) async {
    await _ensureTableExists(tableName);

    final result = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['data'] as String?;
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    await _ensureTableExists(tableName);

    final result = await _database!.query(tableName);

    return result.map((row) {
      final jsonString = row['data'] as String;
      return json.decode(jsonString) as Map<String, dynamic>;
    }).toList();
  }

  /// Check if data exists in the specified table
  Future<bool> isDataExists(String tableName, String id) async {
    await _ensureTableExists(tableName);

    final result = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }

  Future<void> deleteData(String tableName, String id) async {
    await _ensureTableExists(tableName);

    await _database!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    debugPrint('Deleted data from $tableName with id: $id');
  }

  Future<void> clearTable(String tableName) async {
    await _ensureTableExists(tableName);

    await _database!.delete(tableName);

    debugPrint('Cleared all data from table: $tableName');
  }

  Database? get database => _database;

  Future<void> close() async {
    await _database?.close();
    _database = null;
    debugPrint('Database closed');
  }
}
