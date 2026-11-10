import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/khatian_record.dart';

class DatabaseHelper {
  // Singleton Pattern: Create a single instance of the database
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Getter to get the database connection
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Create a new database if it does not exist
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Set the database file path in the device internal storage
    String path = join(await getDatabasesPath(), 'bhumi_calc.db');
    
    return await openDatabase(
      path,
      version: 1, // Increase the version later if new columns are added
      onCreate: _onCreate,
    );
  }

  // Create a new table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE khatian_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        khatianType TEXT,
        khatianNo TEXT,
        dagNo TEXT,
        mouza TEXT,
        totalLandArea REAL,
        imagePath TEXT
      )
    ''');
  }

  // ---------------- CRUD Operations ----------------

  // 1. Save a new khatian (Insert)
  Future<int> insertKhatian(KhatianRecord record) async {
    final db = await database;
    return await db.insert(
      'khatian_records', 
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if the same ID exists
    );
  }

  // 2. Read the list of all khatians (Read All)
  Future<List<KhatianRecord>> getAllKhatians() async {
    final db = await database;
    
    // Fetch all data from the database as a list of Maps
    final List<Map<String, dynamic>> maps = await db.query('khatian_records');
    
    // Convert the list of Maps into a list of KhatianRecord objects
    return List.generate(maps.length, (i) {
      return KhatianRecord.fromMap(maps[i]);
    });
  }
}
