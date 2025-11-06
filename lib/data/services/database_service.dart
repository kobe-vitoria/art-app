import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


class DatabaseService {
  static const _databaseName = 'app.db';
  static const _databaseVersion = 2;

  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    databaseFactory = databaseFactoryFfiWeb;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE Author (
        id INTEGER,
        authorName TEXT NOT NULL,
        authorBio TEXT,
        lastUpdatedAt TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE Arte (
        id INTEGER PRIMARY,
        authorId INTEGER,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        temas TEXT,
        curiosidades TEXT,
        FOREIGN KEY(authorId) REFERENCES Author(id)
      )
    ''');
  }
}