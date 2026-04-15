import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'beautyscan.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        name            TEXT    NOT NULL,
        email           TEXT    NOT NULL UNIQUE,
        password_hash   TEXT    NOT NULL,
        profile_photo   TEXT,
        created_at      TEXT    NOT NULL
      )
    ''');

    // Tabla de resultados de colorimetría
    await db.execute('''
      CREATE TABLE colorimetry_results (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id             INTEGER NOT NULL,
        photo_path          TEXT    NOT NULL,
        skin_tone           TEXT    NOT NULL,
        undertone           TEXT    NOT NULL,
        season              TEXT    NOT NULL,
        recommended_colors  TEXT    NOT NULL,
        colors_to_avoid     TEXT    NOT NULL,
        makeup_tips         TEXT,
        created_at          TEXT    NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Tabla de resultados de peinados
    await db.execute('''
      CREATE TABLE hairstyle_results (
        id                    INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id               INTEGER NOT NULL,
        original_photo_path   TEXT    NOT NULL,
        hairstyle_name        TEXT    NOT NULL,
        result_image_url      TEXT    NOT NULL,
        created_at            TEXT    NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  // ─── USERS ───────────────────────────────────────────────

  Future<int> insertUser(Map<String, dynamic> userMap) async {
    final db = await database;
    return db.insert('users', userMap);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> values) async {
    final db = await database;
    return db.update(
      'users',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─── COLORIMETRY ─────────────────────────────────────────

  Future<int> insertColorimetryResult(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('colorimetry_results', data);
  }

  Future<List<Map<String, dynamic>>> getColorimetryResultsByUser(int userId) async {
    final db = await database;
    return db.query(
      'colorimetry_results',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getColorimetryResultById(int id) async {
    final db = await database;
    final result = await db.query(
      'colorimetry_results',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ─── STATS ───────────────────────────────────────────────

  Future<int> countColorimetryResults(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM colorimetry_results WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countHairstyleResults(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM hairstyle_results WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
