import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/khatian_record.dart';

class DatabaseHelper {
  // Singleton Pattern: Create a single instance of the database
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Fallback in-memory storage for newly added records when SQLite is unavailable
  static final List<KhatianRecord> _memoryRecords = [];

  // Default 150-decimal Khatian records exclusively for 'mutant' and 'neon' accounts
  static final List<KhatianRecord> _defaultAccountRecords = [
    KhatianRecord(
      id: 9001,
      khatianType: 'CS',
      khatianNo: '105',
      dagNo: '312',
      division: 'ঢাকা (Dhaka)',
      district: 'ঢাকা (Dhaka)',
      upazila: 'ধানমন্ডি সার্কেল',
      mouza: 'Dhanmondi',
      ownershipType: 'উত্তরাধিকার সূত্রে',
      totalLandArea: 45.0,
      isTaxPaid: true,
    ),
    KhatianRecord(
      id: 9002,
      khatianType: 'BRS',
      khatianNo: '420',
      dagNo: '890',
      division: 'ঢাকা (Dhaka)',
      district: 'ঢাকা (Dhaka)',
      upazila: 'উত্তরা সার্কেল',
      mouza: 'Uttara Sector 4',
      ownershipType: 'নিজস্ব মালিকানা',
      totalLandArea: 60.0,
      isTaxPaid: true,
    ),
    KhatianRecord(
      id: 9003,
      khatianType: 'Kharij',
      khatianNo: '77',
      dagNo: '154',
      division: 'ঢাকা (Dhaka)',
      district: 'ঢাকা (Dhaka)',
      upazila: 'সাভার সদর',
      mouza: 'Savar Sadar',
      ownershipType: 'নিজস্ব মালিকানা',
      totalLandArea: 45.0,
      isTaxPaid: false,
    ),
  ];

  // Track tax status overrides for default demo records
  static final Map<int, bool> _demoTaxStatusOverrides = {};

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Check if the currently logged-in user is 'mutant' or 'neon'
  Future<bool> _isDefaultDemoUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('auth_is_logged_in') ?? false;
      if (!isLoggedIn) return false;
      final username =
          (prefs.getString('auth_username') ?? '').trim().toLowerCase();
      return username == 'mutant' || username == 'neon';
    } catch (_) {
      return false;
    }
  }

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
      version: 2, // Upgraded to version 2 for division, district, upazila, ownershipType, isTaxPaid
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        division TEXT,
        district TEXT,
        upazila TEXT,
        mouza TEXT,
        ownershipType TEXT,
        totalLandArea REAL,
        imagePath TEXT,
        isTaxPaid INTEGER DEFAULT 0
      )
    ''');
  }

  // Safely add new columns if upgrading from version 1
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final newColumns = [
        'ALTER TABLE khatian_records ADD COLUMN division TEXT DEFAULT "ঢাকা (Dhaka)"',
        'ALTER TABLE khatian_records ADD COLUMN district TEXT DEFAULT ""',
        'ALTER TABLE khatian_records ADD COLUMN upazila TEXT DEFAULT ""',
        'ALTER TABLE khatian_records ADD COLUMN ownershipType TEXT DEFAULT "নিজস্ব মালিকানা"',
        'ALTER TABLE khatian_records ADD COLUMN isTaxPaid INTEGER DEFAULT 0',
      ];
      for (final sql in newColumns) {
        try {
          await db.execute(sql);
        } catch (e) {
          debugPrint('Column upgrade note: $e');
        }
      }
    }
  }

  // ---------------- CRUD Operations ----------------

  // 1. Save a new khatian (Insert)
  Future<int> insertKhatian(KhatianRecord record) async {
    try {
      final db = await database;
      return await db.insert(
        'khatian_records',
        record.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Replace if the same ID exists
      );
    } catch (e) {
      debugPrint('Using in-memory fallback for insertKhatian: $e');
      final nextId = _memoryRecords.isEmpty
          ? 1
          : (_memoryRecords
                  .map((r) => r.id ?? 0)
                  .reduce((a, b) => a > b ? a : b) +
              1);
      final newRec = record.copyWith(id: record.id ?? nextId);
      _memoryRecords.removeWhere((r) => r.id == newRec.id);
      _memoryRecords.add(newRec);
      return newRec.id!;
    }
  }

  // 2. Read the list of all khatians (Read All)
  // Only 'mutant' and 'neon' accounts receive the 150-decimal default records;
  // new users or guests see only what they have added themselves.
  Future<List<KhatianRecord>> getAllKhatians() async {
    final isDemoAccount = await _isDefaultDemoUser();
    List<KhatianRecord> userRecords = [];

    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'khatian_records',
        orderBy: 'id DESC',
      );
      userRecords = List.generate(maps.length, (i) {
        return KhatianRecord.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('Using in-memory fallback for getAllKhatians: $e');
      userRecords = List<KhatianRecord>.from(_memoryRecords);
    }

    if (isDemoAccount) {
      final existingIds = userRecords.map((r) => r.id).toSet();
      final combined = List<KhatianRecord>.from(userRecords);
      for (final defRec in _defaultAccountRecords) {
        if (!existingIds.contains(defRec.id)) {
          final overriddenTax =
              _demoTaxStatusOverrides[defRec.id] ?? defRec.isTaxPaid;
          combined.add(defRec.copyWith(isTaxPaid: overriddenTax));
        }
      }
      return combined;
    }

    return userRecords;
  }

  // 3. Update an existing khatian record (including Tax Paid toggle)
  Future<int> updateKhatian(KhatianRecord record) async {
    if (record.id != null && record.id! >= 9001 && record.id! <= 9003) {
      _demoTaxStatusOverrides[record.id!] = record.isTaxPaid;
    }
    try {
      final db = await database;
      final rows = await db.update(
        'khatian_records',
        record.toMap(),
        where: 'id = ?',
        whereArgs: [record.id],
      );
      if (rows == 0 && record.id != null) {
        await db.insert(
          'khatian_records',
          record.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return 1;
      }
      return rows;
    } catch (e) {
      debugPrint('Using in-memory fallback for updateKhatian: $e');
      final idx = _memoryRecords.indexWhere((r) => r.id == record.id);
      if (idx != -1) {
        _memoryRecords[idx] = record;
        return 1;
      }
      return 0;
    }
  }

  // 4. Delete a khatian record by ID
  Future<int> deleteKhatian(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'khatian_records',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Using in-memory fallback for deleteKhatian: $e');
      _memoryRecords.removeWhere((r) => r.id == id);
      return 1;
    }
  }

  // 5. Clear all user-added khatian records
  Future<void> clearAllKhatians() async {
    try {
      final db = await database;
      await db.delete('khatian_records');
    } catch (e) {
      debugPrint('Using in-memory fallback for clearAllKhatians: $e');
      _memoryRecords.clear();
    }
  }
}
