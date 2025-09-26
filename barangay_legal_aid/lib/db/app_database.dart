import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const int _dbVersion = 1;
  static const String _dbName = 'barangay_legal_aid.db';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Barangays
    await db.execute('''
      CREATE TABLE barangays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        city TEXT,
        province TEXT
      );
    ''');

    // Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('user','admin','superadmin')),
        phone TEXT,
        address TEXT,
        barangay_id INTEGER,
        created_at TEXT NOT NULL,
        FOREIGN KEY (barangay_id) REFERENCES barangays(id)
      );
    ''');

    // Cases
    await db.execute('''
      CREATE TABLE cases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL DEFAULT 'open',
        created_by_user_id INTEGER NOT NULL,
        assigned_admin_user_id INTEGER,
        barangay_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (created_by_user_id) REFERENCES users(id),
        FOREIGN KEY (assigned_admin_user_id) REFERENCES users(id),
        FOREIGN KEY (barangay_id) REFERENCES barangays(id)
      );
    ''');

    // Chat sessions
    await db.execute('''
      CREATE TABLE chat_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    ''');

    // Chat messages
    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        sender TEXT NOT NULL CHECK (sender IN ('user','bot')),
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES chat_sessions(id)
      );
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_users_email ON users(email);');
    await db.execute('CREATE INDEX idx_cases_status ON cases(status);');
    await db.execute('CREATE INDEX idx_chat_messages_session ON chat_messages(session_id);');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }
}


