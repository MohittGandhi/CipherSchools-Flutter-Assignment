
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Added uid column to the transactions table.
      await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL,
          category TEXT,
          date TEXT,
          type TEXT,
          uid TEXT
        )
      ''');
    });
  }

  // Insert a transaction for a specific user.
  static Future<int> insertTransaction(TransactionEntry entry) async {
    final db = await database;
    return await db.insert('transactions', entry.toMap());
  }

  // Get transactions only for the provided user id.
  static Future<List<TransactionEntry>> getTransactions(String uid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'date DESC',
    );
    return List.generate(
      maps.length,
          (i) => TransactionEntry.fromMap(maps[i]),
    );
  }

  // Delete a transaction by id.
  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}

