import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vehicles.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE vehicles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            year INTEGER NOT NULL,
            price REAL NOT NULL,
            description TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE vehicle_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vehicleId INTEGER NOT NULL,
            imagePath TEXT NOT NULL,
            FOREIGN KEY (vehicleId) REFERENCES vehicles (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS vehicle_images');
        await db.execute('DROP TABLE IF EXISTS vehicles');
        await db.execute('''
          CREATE TABLE vehicles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            year INTEGER NOT NULL,
            price REAL NOT NULL,
            description TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE vehicle_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vehicleId INTEGER NOT NULL,
            imagePath TEXT NOT NULL,
            FOREIGN KEY (vehicleId) REFERENCES vehicles (id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }
}