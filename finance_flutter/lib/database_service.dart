import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'finance_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'finance_tracker.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        income REAL,
        expenses REAL,
        category INTEGER,
        type TEXT,
        date TEXT,
        incomeRange INTEGER
      )
    ''');
  }

  Future<int> insertRecord(FinanceRecord record) async {
    final db = await database;
    return await db.insert('records', record.toJson());
  }

  Future<List<FinanceRecord>> getAllRecords() async {
    final db = await database;
    final result = await db.query('records', orderBy: 'date DESC');
    return result.map((json) => FinanceRecord.fromJson(json)).toList();
  }

  Future<void> clearAllRecords() async {
    final db = await database;
    await db.delete('records');
  }
}
